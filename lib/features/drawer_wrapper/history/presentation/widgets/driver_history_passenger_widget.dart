import 'package:flutter/material.dart';
import 'package:flutter_rideshare/features/authentication/auth_wrapper/presentation/providers/auth_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/router/app_state.dart';
import '../../../../../core/router/models/page_action.dart';
import '../../../../../core/router/models/page_config.dart';
import '../../../../../core/utils/enums/page_state_enum.dart';
import '../../../../../core/utils/globals/globals.dart';
import '../../../../../core/utils/services/date_formating.dart';
import '../../../../../core/widgets/custom/dotted_line_painter.dart';
import '../../../../dashboard/presentation/providers/rating_provider.dart';
import '../../../../ride/presentation/pages/passenger_ride_screen.dart';
import '../../model/get_driver_history_response_model.dart';

class DriverHistoryPassengerWidget extends StatelessWidget {
  DriverHistoryPassengerModel model;
   DriverHistoryPassengerWidget({Key? key,required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(13.r),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 1,
              blurRadius: 1,
            ),
          ],
          borderRadius: BorderRadius.circular(6.r),
        ),
        margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  width: 120.w,
                  padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(6.r),
                          bottomLeft: Radius.circular(6.r))),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        model.scheduleId.userId.getFullname(),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          Text(
                            getFormattedRating(model.scheduleId.userId.totalRating,
                                model.scheduleId.userId.totalRatingCount),
                            style: const TextStyle(color: Colors.white),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: 5.w,
                ),
                Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        // if(status=='total'&&model.status!=null)
                        //   Center(
                        //     child: Text(model.status!.toTitleCase(),style: TextStyle(
                        //         fontSize: 14.sp,
                        //         fontWeight: FontWeight.bold,
                        //         color:model.status=='cancelled'?Colors.red: AppTheme.appTheme.primaryColor
                        //     ),),
                        //   ),
                        Row(
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
                                    size: Size(1, 15.h),
                                    painter: DashedLineVerticalPainter()),
                                Icon(
                                  Icons.location_on,
                                  color: Theme.of(context).errorColor,
                                  size: 20.sp,
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    model.scheduleId.startPoint.placeName,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 10.sp),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 15.w),
                                    child: Divider(
                                      height: 10.h,
                                      color: Colors.black12,
                                      thickness: 1,
                                    ),
                                  ),
                                  Text(
                                    model.scheduleId.endPoint.placeName,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 10.sp),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),

                      ],
                    )),

              ],
            ),
            SizedBox(height: 10.h,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RideStatWidget(
                    title: 'DISTANCE',
                    value:
                    '${(model.scheduleId.distance / 1000).toStringAsFixed(1)} KM'),
                RideStatWidget(
                    title: 'Seats',
                    value:
                    '${model.scheduleId.bookedSeats}'),

                RideStatWidget(
                    title: 'Fare',
                    value:
                    "Rs ${model.scheduleId.fare}"),
              ],
            ),
            if (!model.isRated)
              Center(
                child: TextButton(
                    onPressed: () {
                      RatingProvider ratingProvider = sl();
                        ratingProvider.fullName =
                        model.scheduleId.userId.getFullname();
                        ratingProvider.ratingTo = model.scheduleId.userId.id;
                        ratingProvider.profileImage =
                            model.scheduleId.userId.profileImage;

                      ratingProvider.scheduleId = model.scheduleId.id;
                      ratingProvider.routeId = model.routeId;
                      ratingProvider.historyId = model.id;

                      AppState appState = sl();
                      appState.currentAction = PageAction(
                        state: PageState.addPage,
                        page: PageConfigs.ratingPageConfig,
                      );
                    },
                    child: const Text("Rate now")),
              ),
            SizedBox(height: 15.h,)

          ],
        ),
      ),
    );
  }
  bool isDriver() {
    AuthProvider authProvider=sl();
    return authProvider.currentUser!.selectedUserType == '1';
  }
}
