import 'package:flutter/material.dart';
import '../../../../core/utils/constants/app_assets.dart';
import '../../../../core/widgets/bottom_sheets/driver_schedule_ride_bottom_sheet.dart';
import '../../../../core/widgets/custom/custom_dropdown_field.dart';
import '../../../authentication/auth_wrapper/presentation/providers/auth_provider.dart';
import 'leverage_km_widget.dart';
import 'schedule_seat_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/globals/globals.dart';
import '../providers/driver_dashboard_provider.dart';

// ignore: must_be_immutable
class ScheduleWidget extends StatelessWidget {
  ScheduleWidget({Key? key}) : super(key: key);

  AuthProvider authProvider = sl();

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(builder: (context, provider, ch) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 50,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.r),
                        boxShadow: const [
                          BoxShadow(
                              spreadRadius: 1,
                              blurRadius: 1,
                              color: Colors.black12),
                        ]),
                    child: SvgPicture.asset(
                      AppAssets.availableseatSvg,
                      width: 20,
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(context
                              .read<AuthProvider>()
                              .currentUser!
                              .selectedUserType ==
                          '1'
                      ? 'Available Seats'
                      : 'Seats'),
                  SizedBox(
                    width: 10.w,
                  ),
                  Expanded(
                      child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: authProvider.currentUser!.selectedUserType == '1'
                        ? provider.getVehicleCapacityValue()
                        : provider.seats.length,
                    itemBuilder: (context, index) {
                      int item = provider.seats[index];

                      return GestureDetector(
                          onTap: () {
                            provider.setSelectedSeat(item);
                          },
                          child: SelectedSeatWidget(
                              value: item,
                              selected: item == provider.selectedSeat));
                    },
                  ))
                ],
              ),
            ),
          ),
          SizedBox(
            height: 15.h,
          ),
          SizedBox(
            height: 50,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        // color: Colors.white,
                        borderRadius: BorderRadius.circular(6.r),
                        boxShadow: const [
                          BoxShadow(
                              spreadRadius: 1,
                              blurRadius: 1,
                              color: Colors.black12),
                        ]),
                    child: SvgPicture.asset(
                      AppAssets.scheduleSvg,
                      width: 20,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text('Schedule Time'),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (provider.isScheduled) {
                            provider.setIsScheduled(false);
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.w, vertical: 5.h),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                              boxShadow: const [
                                BoxShadow(
                                    spreadRadius: 2,
                                    blurRadius: 2,
                                    color: Colors.black12),
                              ]),
                          child: Text(
                            provider.isScheduled ? 'Scheduled' : "Now",
                            style: TextStyle(
                                fontSize: 16.sp, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15.w,
                      ),
                      GestureDetector(
                        onTap: () {
                          Logger().v("Hello");
                          final bottomSheet = DriverScheduleRideBottomSheet(
                            context: context,
                          );

                          bottomSheet.show();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6.r),
                              boxShadow: const [
                                BoxShadow(
                                    spreadRadius: 2,
                                    blurRadius: 2,
                                    color: Colors.black12),
                              ]),
                          child: SvgPicture.asset(AppAssets.scheduleSvg),
                        ),
                      )
                    ],
                  ))
                ],
              ),
            ),
          ),


          if (authProvider.currentUser!.corporateCode != null &&
              authProvider.currentUser!.corporateCode!.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Corporate Code",
                ),
                  Checkbox(
                      value:provider.corporateCodeStatus,
                      onChanged: (bool? value) {
                        provider.changeCorporateCodeStatus(value!);
                      })
                ],
              ),
            ),
          SizedBox(
            height: 5.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: CustomDropDown(
              hintText: 'Select',
              labelText: "You want to travel with?",
              items: const ["male", "female", "any"],
              value: provider.selectedGender,
              onChanged: (value) {
                provider.setSelectedGender(value!);
              },
            ),
          ),
          if (authProvider.currentUser!.selectedUserType == '1')
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: const LevrageKmWidget()),
        ],
      );
    });
  }

  Widget squareWidget(BuildContext context) {
    return Container(
      height: 20,
      width: 20,
      decoration: BoxDecoration(
          border: Border.all(width: 4, color: Theme.of(context).primaryColor)),
    );
  }
}
