import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../../features/authentication/auth_wrapper/presentation/providers/auth_provider.dart';
import '../../../features/dashboard/presentation/providers/driver_dashboard_provider.dart';
import '../../../features/dashboard/presentation/widgets/horizontal_line.dart';
import '../../../features/drawer_wrapper/schedules_driver/presentation/providers/schedule_provider.dart';
import '../../../features/vehicles/presentation/providers/vechicle_provider.dart';
import '../../modals/place_prediction.dart';
import '../../router/app_state.dart';
import '../../router/models/page_config.dart';
import '../../utils/globals/globals.dart';
import '../../utils/globals/snake_bar.dart';
import '../custom/continue_button.dart';
import '../custom/custom_form_field.dart';
import 'choose_location_bottom_sheet.dart';
import 'custom_datetime_picker.dart';

class DriverScheduleRideBottomSheet {
  final BuildContext context;
  AuthProvider authProvider = sl();
  DashboardProvider provider = sl();
  bool isDriver;
  bool fromDashboardScreen;
  bool isRescheduling;

  String? id;
  DriverScheduleRideBottomSheet(
      {required this.context,
      this.isDriver = true,
      this.fromDashboardScreen = false,
      this.isRescheduling = false,
      this.id});

  Future show() async {
    DashboardProvider dashboardProvider=sl();
    dashboardProvider.setDateTimeControllerDefaultValue();

    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
      builder: (BuildContext bottomSheetContext) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: provider),
          ],
          child: Builder(builder: (context) {
            return Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.r)),
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                    left: 20.w,
                    right: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 10.h,
                    ),
                    const Center(child:  HorizontalLine()),
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(isRescheduling ? "Reschedule ride" : "Schedule ride"),
                    // if (false)
                    //   Row(
                    //     children: [
                    //       Checkbox(value: false, onChanged: (value) {}),
                    //       const Text("One Time"),
                    //       Expanded(child: Container()),

                    //       // Checkbox(value: false, onChanged: (value){}),
                    //       // Text("Reaccuring"),
                    //     ],
                    //   ),
                    SizedBox(
                      height: 10.h,
                    ),

                    // date controller
                    CustomTextFormField(
                      controller: provider.dateTimeController,
                      hintText:
                          authProvider.currentUser!.selectedUserType == '1'
                              ? "Enter date and time"
                              : 'Enter date',
                      labelText:
                          authProvider.currentUser!.selectedUserType == '1'
                              ? "Date and time"
                              : 'Date',
                      readOnly: true,
                      onTap: () async {
                        CustomDatetimePIcker bottomSheet = CustomDatetimePIcker(
                            context: context,
                            mode: authProvider.currentUser!.selectedUserType ==
                                    '1'
                                ? CupertinoDatePickerMode.dateAndTime
                                : CupertinoDatePickerMode.date,
                            minDate: DateTime.now());
                        final result = await bottomSheet.show();
                        if (result != null) {
                          Logger().i(result);
                          if (authProvider.currentUser!.selectedUserType ==
                              '1') {
                            provider.dateTimeController.text =
                                DateFormat('yyyy-MM-dd  h:mm a').format(result);
                          } else {
                            provider.dateTimeController.text =
                                DateFormat('yyyy-MM-dd').format(result);
                          }

                          provider.selectedSchduleDate = result;
                        }
                      },
                    ),
                    if (authProvider.currentUser!.selectedUserType == '2')
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 5.h,),
                           Text("Search ride in between",  style: Theme.of(context).textTheme.bodyText2?.copyWith(fontWeight: FontWeight.w800),),
                          SizedBox(height: 5.h,),
                          Row(

                            children: [
                              Expanded(
                                child: CustomTextFormField(
                                  controller: provider.startTimeController,
                                  hintText: 'Enter time',
                                  labelText: '',
                                  readOnly: true,
                                  onTap: () async {
                                    CustomDatetimePIcker bottomSheet =
                                        CustomDatetimePIcker(
                                            context: context,
                                            mode: CupertinoDatePickerMode.time,
                                            minDate: DateTime.now());
                                    final result = await bottomSheet.show();
                                    if (result != null) {
                                      Logger().i(result);

                                      provider.startTimeController.text =
                                          DateFormat('h:mm a').format(result);
                                      provider.selectedStartTime = result;
                                    }
                                  },
                                ),
                              ),
                              SizedBox(width: 10.w,),
                              Expanded(
                                child: CustomTextFormField(
                                  controller: provider.endTimeController,
                                  hintText: 'Enter time',
                                  labelText: '',
                                  readOnly: true,
                                  onTap: () async {
                                    CustomDatetimePIcker bottomSheet =
                                    CustomDatetimePIcker(
                                        context: context,
                                        mode: CupertinoDatePickerMode.time,
                                        minDate: DateTime.now());
                                    final result = await bottomSheet.show();
                                    if (result != null) {
                                      Logger().i(result);
                                      if (result.isBefore(provider.selectedStartTime!)) {
                                        return ShowToast.show(
                                            'End time should not be after start time');
                                      }

                                      provider.endTimeController.text =
                                          DateFormat('h:mm a').format(result);
                                      provider.selectedEndTime = result;
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                        ],
                      ),


                    SizedBox(
                      height: 20.h,
                    ),
                    ContinueButton(
                        text: 'Schedule',

                        onPressed: () async {

                          AuthProvider authProvider = sl();
                          if (authProvider.currentUser!.selectedUserType ==
                              '2') {
                            if (provider.selectedEndTime!
                                .isBefore(provider.selectedStartTime!)) {
                              return ShowToast.show(
                                  'End time should not be after start time');
                            }
                          }

                          if (!isRescheduling) {
                            provider.setIsScheduled(true);
                            if (fromDashboardScreen) {
                              provider.setDashboardDropdownValue('Later');
                            }
                          } else {
                            ScheduleProvider schduleProvider = sl();
                            if (isDriver) {
                              schduleProvider.rescheduleDriverRoute(
                                routeId: id!,
                              );
                            } else {
                              schduleProvider.reschedulePassengerSchedule(
                                scheduleId: id!,
                              );
                            }
                          }




                          if(fromDashboardScreen){
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
                              Navigator.of(context).pop();
                              var place = result as PlacePridictions;
                              await context
                                  .read<DashboardProvider>()
                                  .setDashboardDropOfLocation(place.place_id);


                              goToNewRideScreen();
                            }
                          }else{
                            Navigator.of(context).pop();
                          }
                        }),
                    SizedBox(
                      height: 20.h,
                    ),
                  ],
                ));
          }),
        );
      },
    ).then((value) {
      if (value != null) {
        return value;
      }
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
