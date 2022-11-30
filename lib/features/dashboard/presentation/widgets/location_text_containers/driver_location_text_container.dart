import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import '../../../../../core/modals/place_prediction.dart';

import '../../../../../core/utils/globals/loading.dart';
import '../../../../../core/utils/globals/snake_bar.dart';
import '../../../../../core/widgets/bottom_sheets/choose_location_bottom_sheet.dart';
import '../../providers/driver_dashboard_provider.dart';
import '../schedule_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../../core/utils/globals/globals.dart';
import '../../../../../core/widgets/custom/continue_button.dart';
import '../../../../../core/widgets/custom/dotted_line_painter.dart';
import '../../../../authentication/auth_wrapper/presentation/providers/auth_provider.dart';
import '../dashboard_bottom_container_decoration.dart';
import '../horizontal_line.dart';
import 'package:socket_io_client/socket_io_client.dart' as soIO;

// ignore: must_be_immutable
class DriverLocationTextContainer extends StatelessWidget {
  DriverLocationTextContainer({Key? key}) : super(key: key);

  late soIO.Socket socket;
  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(builder: (context, provider, ch) {
      return Container(
        decoration: kDashboardBottomContainerDecoration,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // TextButton(onPressed: (){
              //   DriverDashboardProvider driverDashboardProvider=sl();
              //
              //   Logger().v(driverDashboardProvider.vehicleCapacityModel!.data.seatingCapacity);
              // }, child: Text("Test")),
              SizedBox(
                height: 10.h,
              ),
              const HorizontalLine(),
              Row(
                children: [
                  SizedBox(
                    width: 15.w,
                  ),
                  SizedBox(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          Icons.radio_button_checked,
                          color: Theme.of(context).primaryColor,
                          size: 30.sp,
                        ),
                        CustomPaint(
                            size: Size(1, 66.h),
                            painter: DashedLineVerticalPainter()),
                        Icon(
                          Icons.location_on,
                          color: Theme.of(context).errorColor,
                          size: 30.sp,
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.w, vertical: 20.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "START POINT",
                            style: TextStyle(
                                color: Theme.of(context).canvasColor,
                                fontSize: 16.sp),
                          ),
                          GestureDetector(

                            onTap: () async {

                              if (provider.isRequesting) return;
                              ChooseLocationBottomSheet bottomSheet =
                                  ChooseLocationBottomSheet(
                                      locationType: LocationType.startPoint,
                                      context: context,
                                      title: 'Where from?',
                                      icon: Icon(
                                        Icons.radio_button_checked,
                                        color: Theme.of(context).primaryColor,
                                      ));
                              final result = await bottomSheet.show();
                              if (result != null) {
                                var place = result as PlacePridictions;
                                provider.setPickUpLocation(place.place_id);
                              }
                            },
                            child: Text(
                              provider.pickUpLocation == null
                                  ? 'Where from?'
                                  : provider
                                      .pickUpLocation!.placeFormattedAddress,
                              style: TextStyle(
                                  fontSize: 19.sp,
                                  overflow: TextOverflow.ellipsis),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Divider(
                            thickness: 1,
                            color: Colors.black12,
                            height: 20,
                          ),
                          Text(
                            "END POINT",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Theme.of(context).canvasColor,
                              fontSize: 16.sp,
                            ),
                          ),
                          // destination
                          GestureDetector(
                            onTap: () async {
                              if (provider.isRequesting) return;
                              ChooseLocationBottomSheet bottomSheet =
                                  ChooseLocationBottomSheet(
                                      locationType: LocationType.dropOff,
                                      context: context,
                                      title: 'Where to?',
                                      icon: Icon(
                                        Icons.location_on,
                                        color: Theme.of(context).errorColor,
                                      ));
                              final result = await bottomSheet.show();
                              if (result != null) {
                                var place = result as PlacePridictions;
                                provider.setDropOfLocation(place.place_id);
                              }
                            },
                            child: Text(
                              provider.dropOfLocation != null
                                  ? provider
                                      .dropOfLocation!.placeFormattedAddress
                                  : 'Where to?',
                              style: TextStyle(
                                  fontSize: 19.sp,
                                  overflow: TextOverflow.ellipsis),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              if (provider.isRequesting)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  child: ScheduleWidget(),
                ),
              Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 40.w, vertical: 15.h),
                  child: ContinueButton(
                      text: provider.isRequesting ? 'Submit' : 'Next',
                      onPressed: () async {
                        if (provider.isRequesting) {
                          if (provider.selectedGender == null) {
                            return ShowSnackBar.show('Please select an gender');
                          }

                           Loading.show(message: 'Adding request');
                          AuthProvider authProvider = sl();
                          Timer(const Duration(milliseconds: 100), () {
                            if (authProvider.currentUser!.selectedUserType ==
                                '1') {
                              provider.addDriverRide();
                            } else {
                              provider.addPassengerRide();
                            }
                          });


                        } else {

                          if (provider.dropOfLocation == null) {
                            return;
                          }
                          await provider.getAndSetPolyline();
                          provider.setDefaultHeight(270.h + 200.h);
                          provider.setIsRequesting(true);
                        }
                      }))
            ],
          ),
        ),
      );
    });
  }
}
