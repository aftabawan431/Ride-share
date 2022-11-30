import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../core/modals/place_prediction.dart';
import '../../../../core/router/app_state.dart';
import '../../../../core/router/models/page_config.dart';
import '../../../../core/utils/constants/app_assets.dart';
import '../../../../core/utils/globals/globals.dart';
import '../../../../core/utils/globals/snake_bar.dart';
import '../../../../core/utils/location/location_api.dart';
import '../../../../core/widgets/bottom_sheets/choose_location_bottom_sheet.dart';
import '../../../../core/widgets/bottom_sheets/driver_schedule_ride_bottom_sheet.dart';
import '../../../authentication/auth_wrapper/presentation/providers/auth_provider.dart';
import '../../../vehicles/presentation/providers/vechicle_provider.dart';
import '../providers/driver_dashboard_provider.dart';

class DashboardWhereToWidget extends StatelessWidget {
  const DashboardWhereToWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(builder: (context, provider, ch) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white.withOpacity(.1),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: .5,
              blurRadius: .5,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  final canLocate = await LocationApi.canLocate();
                  if (!canLocate) {
                    return;
                  }
                  ChooseLocationBottomSheet bottomSheet =
                      ChooseLocationBottomSheet(
                          locationType: LocationType.dropOff,
                          context: context,
                          title: 'Where to?',
                          isDashboardWhereTo: true,
                          icon: Icon(
                            Icons.radio_button_checked,
                            color: Theme.of(context).primaryColor,
                          ));
                  final result = await bottomSheet.show();
                  if (result != null) {
                    var place = result as PlacePridictions;
                    await context
                        .read<DashboardProvider>()
                        .setDashboardDropOfLocation(place.place_id);

                    goToNewRideScreen();
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    provider.dashboardDropofLocation != null
                        ? provider
                            .dashboardDropofLocation!.placeFormattedAddress
                        : 'Where to?',
                    style:
                        TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                final canLocate = await LocationApi.canLocate();
                if (!canLocate) {
                  return;
                }
                if (provider.isScheduled) {
                  provider.setIsScheduled(false);
                } else {
                  final scheduleBottomSheet = DriverScheduleRideBottomSheet(
                      context: context, fromDashboardScreen: true);

                  await scheduleBottomSheet.show();
                  final canLocate = await LocationApi.canLocate();
                  if (!canLocate) {
                    return;
                  }
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.8),
                    borderRadius: BorderRadius.circular(3),
                    // color: Colors.grey.withOpacity(.15),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black12,
                          spreadRadius: 1,
                          blurRadius: 1),
                    ],
                  ),
                  child: Center(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            AppAssets.scheduleSvg,
                            width: 18.sp,
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Text(
                            provider.isScheduled
                                ? "${DateFormat("hh:mm a/ dd").format(provider.selectedSchduleDate!.toLocal())}"
                                : "Ride",
                            style: TextStyle(
                                fontSize: provider.isScheduled ? 14.sp : 16.sp,
                                fontWeight: FontWeight.bold),
                          ),
                          if (false)
                            SizedBox(
                              width: 62.w,
                              height: 28.h,
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  isExpanded: false,
                                  value: provider.dashboardDropdownValue,
                                  onChanged: (value) {
                                    if (value == 'Later') {
                                      final bottomSheet =
                                          DriverScheduleRideBottomSheet(
                                              context: context,
                                              fromDashboardScreen: true);

                                      bottomSheet.show();
                                    } else {
                                      provider.setIsScheduled(false);
                                      provider.setDashboardDropdownValue(value);
                                    }
                                  },
                                  items: ['Later', 'Now']
                                      .map((e) => DropdownMenuItem<String>(
                                            child: Text(e),
                                            value: e,
                                          ))
                                      .toList(),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      );
    });
  }

  goToNewRideScreen() {
    DashboardProvider provider = sl();

    AuthProvider authProvider = sl();

    if (authProvider.currentUser!.selectedUserType == '1' &&
        authProvider.currentUser!.selectedVehicle == null) {
      ShowSnackBar.show('Please add a vehicle first');

      AppState appState = GetIt.I.get<AppState>();
      VehicleProvider vehicleProvider = sl();
      vehicleProvider.directToNewRideScreen = true;

      appState.goToNext(PageConfigs.vehicleDetailsPageConfig);

      return;
    } else if (authProvider.currentUser!.selectedUserType == '1' &&
        authProvider.currentUser!.selectedVehicle != null) {
      provider.setDriverVehicleCapacity();
    }

    if (provider.dashboardDropofLocation != null) {
      provider.setDropOfLocation(provider.dashboardDropofLocation!.placeId);
    } else {
      provider.setDropOfLocation(null);
    }
    if (provider.isRequesting) {
      provider.setDefaultHeight(provider.defaultHeight - 200.h);
      provider.setIsRequesting(false);
    }

    AppState appState = sl();
    appState.goToNext(PageConfigs.newRidePageConfig);
  }
}
