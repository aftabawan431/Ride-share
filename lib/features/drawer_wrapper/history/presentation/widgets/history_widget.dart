import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger/logger.dart';

import '../../../../../core/router/app_state.dart';
import '../../../../../core/router/models/page_action.dart';
import '../../../../../core/router/models/page_config.dart';
import '../../../../../core/utils/enums/page_state_enum.dart';
import '../../../../../core/utils/globals/globals.dart';
import '../../../../../core/utils/services/date_formating.dart';
import '../../../../../core/widgets/custom/dotted_line_painter.dart';
import '../../../../authentication/auth_wrapper/presentation/providers/auth_provider.dart';
import '../../../../dashboard/presentation/providers/rating_provider.dart';
import '../../../../ride/presentation/pages/passenger_ride_screen.dart';
import '../../model/get_history_response_model.dart';

class HistoryWidget extends StatelessWidget {
  HistoryWidget({Key? key, required this.history}) : super(key: key);
  final Data history;

  final AuthProvider authProvider = sl();
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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 7.h,
            ),
            Padding(

              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Text(
                  DateFormatService.formattedDate(history.createdAt)
              )
            ),
            Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                child: Row(
                  children: [
                    SizedBox(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            Icons.radio_button_checked,
                            color: Theme.of(context).primaryColor,
                          ),
                          CustomPaint(
                              size:const Size(1, 20),
                              painter: DashedLineVerticalPainter()),
                          Icon(Icons.location_on,
                              color: Theme.of(context).errorColor)
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            isDriver()
                                ? history.routeId.startPoint.placeName
                                : history.scheduleId.startPoint.placeName,
                            style: TextStyle(fontSize: 16.sp),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Text(
                            isDriver()
                                ? history.routeId.endPoint.placeName
                                : history.scheduleId.endPoint.placeName,
                            style: TextStyle(fontSize: 16.sp),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                    ),
                  ],
                )),
            if (!history.isRated)
              Center(
                child: TextButton(
                    onPressed: () {
                      RatingProvider ratingProvider = sl();
                      if (isDriver()) {
                        ratingProvider.fullName =
                            "${history.routeId.userId.firstName} ${history.routeId.userId.lastName}";
                        ratingProvider.ratingTo = history.scheduleId.userId.id;
                        ratingProvider.profileImage =
                            history.routeId.userId.profileImage;
                      } else {
                        ratingProvider.fullName =
                            "${history.scheduleId.userId.firstName} ${history.scheduleId.userId.lastName}";
                        ratingProvider.ratingTo = history.routeId.userId.id;
                        ratingProvider.profileImage =
                            history.scheduleId.userId.profileImage;
                      }
                      ratingProvider.scheduleId = history.scheduleId.id;
                      ratingProvider.routeId = history.routeId.id;
                      ratingProvider.historyId = history.id;

                      AppState appState = sl();
                      appState.currentAction = PageAction(
                        state: PageState.addPage,
                        page: PageConfigs.ratingPageConfig,
                      );
                    },
                    child: const Text("Rate now")),
              ),
           const Divider(
              height: 5,
              thickness: 1,
              color: Colors.black12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RideStatWidget(
                    title: 'DISTANCE',
                    value:
                        '${(isDriver() ? history.routeId.distance / 1000 : history.scheduleId.distance / 1000).toStringAsFixed(1)} KM'),
                RideStatWidget(
                    title: 'DURATION',
                    value:
                        '${(isDriver() ? history.routeId.duration / 60 : history.scheduleId.duration / 60) ~/ 60}h:${(isDriver() ? history.routeId.duration % 3600 / 60 : history.scheduleId.duration % 3600 / 60).floor()}m'),

                RideStatWidget(
                    title: 'Fare',
                    value:
                    "Rs ${history.scheduleId.fare}"),
              ],
            ),
            SizedBox(
              height: 5.h,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              decoration: const BoxDecoration(
                  border:
                      Border(top: BorderSide(color: Colors.black12, width: 1))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Text("${isDriver()?history.routeId.:} PKR"),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        history.scheduleId.status.toUpperCase(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor),
                      ),
                      // Icon(
                      //   Icons.arrow_forward_ios_rounded,
                      //   size: 18.sp,
                      // )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  bool isDriver() {
    return authProvider.currentUser!.selectedUserType == '1';
  }
}
