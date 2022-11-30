import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rideshare/core/utils/extension/extensions.dart';
import 'package:flutter_rideshare/core/utils/globals/loading.dart';
import 'package:flutter_rideshare/core/widgets/bottom_sheets/cancel_reason_bottom_sheet.dart';
import '../../../../../core/router/app_state.dart';
import '../../../../../core/utils/constants/app_url.dart';
import '../../../../../core/widgets/custom/custom_text_button.dart';
import '../pages/driver_list_screen.dart';
import '../providers/schedule_provider.dart';
import '../../../../ride/presentation/providers/passenger_ride_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../../../core/router/models/page_action.dart';
import '../../../../../core/router/models/page_config.dart';
import '../../../../../core/utils/constants/app_assets.dart';
import '../../../../../core/utils/enums/page_state_enum.dart';
import '../../../../../core/utils/globals/globals.dart';
import '../../../../../core/utils/services/date_formating.dart';
import '../../../../../core/widgets/bottom_sheets/driver_schedule_ride_bottom_sheet.dart';
import '../../../../../core/widgets/custom/dotted_line_painter.dart';
import '../../../../ride/presentation/pages/passenger_ride_screen.dart';
import '../../data/models/get_passenger_schdules_response_model.dart';
import 'gender_icon_widget.dart';

// ignore: must_be_immutable
class PassengerScheduleListWidget extends StatelessWidget {
  PassengerScheduleListWidget({required this.schedule, Key? key})
      : super(key: key);
  Data schedule;

  TextStyle timeStyle = const TextStyle(color: Colors.black54);
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.r),
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
                            schedule.userId.firstName +
                                ' ' +
                                schedule.userId.lastName,
                            maxLines: 1,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                                fontSize: 16.sp, fontWeight: FontWeight.w700),
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
                              GenderIconWidget(
                                gender: schedule.gender,
                              ),
                              SizedBox(
                                width: 10.h,
                              )
                            ],
                          )
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
                    schedule.status == 'cancelled'
                        ? const Text("Cancelled")
                        : schedule.status == 'completed'
                            ? const Text("Completed")
                            : schedule.accepted != null
                                ? const Text("Accepted")
                                : GestureDetector(
                                    onTap: _viewOwnersTap,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text('View'),
                                        Text(USER_TITLE.toTitleCase() + 's'),
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
                      Text(
                        DateFormatService.formattedDate(schedule.date,
                            dateFormatType: DateFormatType.year),
                        style: timeStyle,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        DateFormatService.formattedDate(schedule.startTime,
                            dateFormatType: DateFormatType.time),
                        style: timeStyle,
                      ),
                      Text(
                        " - ",
                        style: timeStyle,
                      ),

                      Text(
                        DateFormatService.formattedDate(schedule.endTime,
                            dateFormatType: DateFormatType.time),
                        style: timeStyle,
                      ),
                      // Text(schedule.time),
                    ],
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  _routeInfoWidget(context),
                  _scheduleDetailsWidget(),
                  if (schedule.status == 'active')
                    Center(
                        child: CustomTextButton(
                      onPressed: _onRideTap,
                      title: 'Ride',
                    )),
                  if (schedule.status == 'pending')
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _deleteWidget(context),
                      ],
                    ),
                  if (schedule.status == 'cancelled')
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _deleteWidget(context),
                        _rescheduleWidget(context),
                      ],
                    ),
                  if (schedule.status == 'completed')
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _deleteWidget(context),
                        _rescheduleWidget(context),
                      ],
                    ),
                  if (schedule.status == 'accepted')
                    Center(child: _cancelWidget(context)),
                ],
              ),
            )
          ],
        ),
      ),
    );
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
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(schedule.startPoint.placeName),
              SizedBox(
                height: 10.h,
              ),
              Text(
                schedule.endPoint.placeName,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
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
        RideStatWidget(title: 'Seats', value: schedule.bookedSeats.toString()),
      ],
    );
  }

  Widget _deleteWidget(BuildContext context) {
    return CustomTextButton(
      onPressed: () => _onDeleteTap(context),
      title: 'Delete',
      color: CustomTextButtonColor.red,
    );
  }

  Widget _cancelWidget(BuildContext context) {
    return CustomTextButton(
      onPressed: () => _onCancelTap(context),
      title: 'Cancel',
      color: CustomTextButtonColor.red,
    );
  }

  Widget _rescheduleWidget(BuildContext context) {
    return CustomTextButton(
      onPressed: () => _rescheduleTap(context),
      title: 'Reschedule',
    );
  }

  //functions

  _onDeleteTap(BuildContext context) async {
    if (await confirm(navigatorKeyGlobal.currentContext!,
        content: const Text("Are you sure you want to delete this schedule?"))) {
      ScheduleProvider provider = sl();
      provider.deletePassengerSchedule(scheduleId: schedule.id);
    }
  }

  _viewOwnersTap() {
    if (schedule.accepted != null) {
      return;
    }
    ScheduleProvider scheduleProvider = sl();
    scheduleProvider.isFromNewRideScreen = false;
    AppState appState = sl();
    appState.addWidget(
        page: PageConfigs.driversListPageConfig,
        child: DriverListScreen(
          id: schedule.id,
        ));
  }

  _onCancelTap(BuildContext context) async {
    List<String> reasons = ["Wrong schedule time", "Other"];

    CancelReasonBottomSheet bottomSheet = CancelReasonBottomSheet(
        context: navigatorKeyGlobal.currentContext!,
        reasons: reasons,
        onPressed: (reason) {
          print(reason);

          Loading.show();
          context.read<ScheduleProvider>().cancelPassengerScheduledRide(
              routeId: schedule.accepted!,
              scheduleId: schedule.id,
              moveToBack: false,
              reason: reason);
          Navigator.of(context).pop();
        });
    bottomSheet.show();
    return;

    // if (await confirm(navigatorKeyGlobal.currentContext!,
    //     content: const Text("Are you sure to cancel this schedule?"))) {
    //   context.read<ScheduleProvider>().cancelPassengerScheduledRide(
    //       routeId: schedule.accepted!,
    //       scheduleId: schedule.id,
    //       moveToBack: true);
    // }
  }

  _rescheduleTap(BuildContext context) {
    final bottomSheet = DriverScheduleRideBottomSheet(
        context: context,
        isRescheduling: true,
        id: schedule.id,
        isDriver: false);
    bottomSheet.show();
  }

  _onRideTap() {
    PassengerRideProvider passengerRideProvider = sl();
    passengerRideProvider.getAndSetCurrentRide(
        routeId: schedule.accepted!, scheduleId: schedule.id);
  }
}
