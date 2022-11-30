import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rideshare/core/widgets/custom/custom_text_button.dart';
import '../../../../../core/utils/constants/app_url.dart';
import '../../../../../core/utils/globals/loading.dart';
import '../../../../../core/widgets/bottom_sheets/cancel_reason_bottom_sheet.dart';
import '../pages/requested_passengers_screen.dart';
import '../providers/schedule_provider.dart';
import '../../../../ride/presentation/providers/driver_ride_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logger/logger.dart';
import '../../../../../core/router/app_state.dart';
import '../../../../../core/router/models/page_action.dart';
import '../../../../../core/router/models/page_config.dart';
import '../../../../../core/utils/constants/app_assets.dart';
import '../../../../../core/utils/enums/page_state_enum.dart';
import '../../../../../core/utils/globals/globals.dart';
import '../../../../../core/utils/services/date_formating.dart';
import '../../../../../core/widgets/bottom_sheets/driver_schedule_ride_bottom_sheet.dart';
import '../../../../ride/presentation/pages/passenger_ride_screen.dart';
import '../../data/models/get_driver_schedules_response_model.dart';
import '../../../../../core/widgets/custom/dotted_line_painter.dart';
import 'gender_icon_widget.dart';

class DriverScheduleListWidget extends StatelessWidget {
  const DriverScheduleListWidget({required this.schedule, Key? key})
      : super(key: key);
  final Data schedule;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: EdgeInsets.only(bottom: 15.h),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                  spreadRadius: 2,
                  blurRadius: 2,
                  color: Colors.black12,
                  offset: Offset(0, 0))
            ]),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 26.r,
                      backgroundImage: NetworkImage(
                          AppUrl.fileBaseUrl + schedule.userId.profileImage),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            schedule.userId.firstName.trim() +
                                ' ' +
                                schedule.userId.lastName.trim(),
                            style: TextStyle(
                                fontSize: 18.sp, fontWeight: FontWeight.w700),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SvgPicture.asset(
                                AppAssets.star1Svg,
                                width: 18,
                                color: Colors.orangeAccent,
                              ),
                              SizedBox(
                                width: 4.w,
                              ),
                              Text(
                                getFormattedRating(schedule.userId.totalRating,
                                    schedule.userId.totalRatingCount),
                                style: TextStyle(
                                    color: Theme.of(context).canvasColor,
                                    fontSize: 16.sp),
                              ),
                              Expanded(child: Container()),
                              Icon(
                                Icons.radio_button_checked_sharp,
                                size: 14.sp,
                              ),
                              SizedBox(
                                width: 3.w,
                              ),
                              Text(
                                "${schedule.kmLeverage} KM",
                              ),
                              SizedBox(
                                width: 6.w,
                              ),
                              Container(
                                color: Colors.black26,
                                width: 1.5,
                                height: 20.h,
                              ),
                              GenderIconWidget(
                                gender: schedule.gender,
                              ),
                              const SizedBox(
                                width: 14,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.black26,
                      width: 1.5,
                      height: 55.h,
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    schedule.status == 'completed'
                        ? const Text('Completed')
                        : schedule.status == 'cancelled'
                            ? const Text("Cancelled")
                            : GestureDetector(
                                onTap: _viewRequestsTap,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Text('View'),
                                    Text('Requests'),
                                  ],
                                ),
                              )
                  ],
                )),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              decoration: const BoxDecoration(
                  border:
                      Border(top: BorderSide(color: Colors.black12, width: 1))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(DateFormatService.formattedDate(schedule.date)),
                    ],
                  ),
                  _routeInfoWidget(context),
                ],
              ),
            ),
            _scheduleDetailsWidget(),
            if (schedule.status == 'active')
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                if (schedule.status == 'active')
                  CustomTextButton(
                    onPressed: () => _onCancelTap(context),
                    title: 'Cancel',
                    color: CustomTextButtonColor.red,
                  ),
                CustomTextButton(
                  onPressed: () => _onStartTap(context),
                  title: 'Start',
                ),
              ]),
            if (schedule.status == 'started')
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                CustomTextButton(
                  onPressed: () => _onFinishTap(context),
                  title: 'Finish',
                  color: CustomTextButtonColor.red,
                ),
                CustomTextButton(
                  onPressed: _contiueTap,
                  title: 'Continue',
                ),
              ]),
            if (schedule.status == 'completed' ||
                schedule.status == 'cancelled')
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomTextButton(
                    onPressed: () => _onDeleteTap(context),
                    title: 'Delete',
                    color: CustomTextButtonColor.red,
                  ),
                  CustomTextButton(
                    onPressed: () => _rescheduleTap(context),
                    title: 'Reschedule',
                  ),
                ],
              ),
            SizedBox(
              height: 5.h,
            )
          ],
        ),
      ),
    );
  }

  //methods
  _rescheduleTap(BuildContext context) {
    final bottomSheet = DriverScheduleRideBottomSheet(
        context: context, isRescheduling: true, id: schedule.id);
    bottomSheet.show();
  }

  _onDeleteTap(BuildContext context) async {
    if (await confirm(navigatorKeyGlobal.currentContext!,
        content: const Text('Are you sure you want to delete this route?'))) {
      ScheduleProvider provider = sl();
      await provider.deleteRouteDriver(schedule.id);
    }
  }

  _contiueTap() {
    DriverRideProvider driverRideProvider = sl();
    driverRideProvider.getAndSetCurrentRide(schedule.id);
  }

  _onFinishTap(BuildContext context) async {
    if (await confirm(navigatorKeyGlobal.currentContext!,
        content: const Text('Are you sure you want to finish this ride?'))) {
      ScheduleProvider provider = sl();

      provider.finishRideDriver(schedule.id);
    }
  }

  _onStartTap(BuildContext context) async {
    if (await confirm(navigatorKeyGlobal.currentContext!,
        content: const Text('Are you sure you want to start this ride?'))) {
      DriverRideProvider driverRideProvider = sl();

      driverRideProvider.getAndSetCurrentRide(schedule.id);
    }
  }

  _onCancelTap(BuildContext context) async {
    List<String> reasons = ["Wrong schedule time", "Other"];

    CancelReasonBottomSheet bottomSheet = CancelReasonBottomSheet(
        context: navigatorKeyGlobal.currentContext!,
        reasons: reasons,
        onPressed: (reason) async {
          print(reason);

          Loading.show();
          ScheduleProvider provider = sl();
          await provider.cancelRouteDriver(schedule.id);
          Navigator.of(context).pop();
        });
    bottomSheet.show();

    // if (await confirm(navigatorKeyGlobal.currentContext!,
    //     content: const Text('Are you sure to cancel this route?'))) {}
  }

  _viewRequestsTap() {
    ScheduleProvider scheduleProvider = sl();
    scheduleProvider.isFromNewRideScreen = false;
    AppState appState = sl();
    appState.currentAction = PageAction(
        state: PageState.addWidget,
        page: PageConfigs.requestedPassengersPageConfigs,
        widget: RequestedPassengersScreen(
          id: schedule.id,
        ));
  }

  //widgets
  Widget _routeInfoWidget(BuildContext context) {
    return Row(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.radio_button_checked,
              color: Theme.of(context).primaryColor,
              size: 20.sp,
            ),
            CustomPaint(
                size: Size(1, 15.h), painter: DashedLineVerticalPainter()),
            Icon(
              Icons.location_on,
              color: Theme.of(context).errorColor,
              size: 20.sp,
            ),
          ],
        ),
        const SizedBox(
          width: 6,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(schedule.startPoint.placeName),
              SizedBox(
                height: 10.h,
              ),
              Text(schedule.endPoint.placeName)
            ],
          ),
        )
      ],
    );
  }

  Widget _scheduleDetailsWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        RideStatWidget(
            title: 'DISTANCE',
            value: '${(schedule.distance / 1000).toStringAsFixed(1)} KM'),
        RideStatWidget(
            title: 'DURATION',
            value:
                '${(schedule.duration / 60) ~/ 60}h:${(schedule.duration % 3600 / 60).floor()}m'),
        RideStatWidget(title: 'Seats', value: schedule.initialSeats.toString()),
        RideStatWidget(
            title: 'Booked',
            value:
                (schedule.initialSeats - schedule.availableSeats).toString()),
      ],
    );
  }
}
