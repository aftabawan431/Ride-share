import 'package:flutter/material.dart';
import 'package:flutter_rideshare/core/utils/extension/extensions.dart';
import 'package:flutter_rideshare/core/utils/theme/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/globals/globals.dart';
import '../../../../core/utils/services/date_formating.dart';
import '../../../../core/widgets/custom/dotted_line_painter.dart';
import 'dashboard_ride_history_widget.dart';

// ignore: must_be_immutable
class DashboardHistoryRideWidget extends StatelessWidget {
  DashboardHistoryRideWidget(
      {Key? key, required this.model, required this.status})
      : super(key: key);
  String status;
  DashboardRideHistoryModel model;

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
        child: Row(
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
                    model.userId.getFullName(),
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
                        getFormattedRating(model.userId.totalRating,
                            model.userId.totalRatingCount),
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

                if(status=='total'&&model.status!=null)
                  Center(
                    child: Text(model.status!.toTitleCase(),style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      color:model.status=='cancelled'?Colors.red: AppTheme.appTheme.primaryColor
                    ),),
                  ),
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
                            model.startPoint.placeName,
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
                            model.endPoint.placeName,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 10.sp),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [

                    Padding(
                      padding: EdgeInsets.only(right: 15.w),
                      child: Text(
                        DateFormatService.formattedDate(model.date!),
                        style: TextStyle(fontSize: 10.sp),
                      ),
                    ),
                  ],
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}
