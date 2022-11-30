import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../core/widgets/custom/dotted_line_painter.dart';
import '../../data/model/dashboard_data_response_model.dart';
import '../providers/driver_dashboard_provider.dart';

class DashboardUpcomingRideWidget extends StatelessWidget {
  const DashboardUpcomingRideWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<DashboardProvider, GetDashboardDataResponseModel>(
        selector: (_, provider) => provider.getDashboardDataResponseModel!,
        builder: (context, data, ch) {
          if (data.data.upcoming.isEmpty) {
            return const SizedBox.shrink();
          }

          final date = DateTime.parse(data.data.upcoming.first.date).toLocal();
          Duration? duration;
          if (date.isAfter(DateTime.now().toLocal())) {
            duration = date.difference(DateTime.now().toLocal());
          }

          return Container(
            padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.grey.withOpacity(.2),
                width: 1,
              ),
              // color: Colors.grey.withOpacity(.15),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  spreadRadius: .5,
                  blurRadius: .5,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Upcoming Ride',
                        style: TextStyle(
                            fontSize: 12.sp, fontWeight: FontWeight.bold)),

                    // Text("In ${duration!.inm>0?'${duration.inDays} days':''} ${duration.inMinutes>0?'${duration.inMinutes} minutes':''}",style: TextStyle(fontWeight: FontWeight.w600,color: Theme.of(context).primaryColor),)
                  ],
                ),
                SizedBox(
                  height: 7.h,
                ),
                Row(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.radio_button_checked,
                          color: Theme.of(context).primaryColor,
                          size: 14.sp,
                        ),
                        CustomPaint(
                            size: Size(1, 15.h),
                            painter: DashedLineVerticalPainter()),
                        Icon(
                          Icons.location_on,
                          color: Theme.of(context).errorColor,
                          size: 14.sp,
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.data.upcoming.first.startPoint.placeName,
                            style: TextStyle(fontSize: 11.sp),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            data.data.upcoming.first.endPoint.placeName,
                            style: TextStyle(fontSize: 11.sp),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          DateFormat('MMM-dd hh:mm a').format(
                              DateTime.parse(data.data.upcoming.first.date)
                                  .toLocal()),
                          style: TextStyle(fontSize: 10.sp),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        if (data.data.upcoming.first.fare != null)
                          Text(
                            "Rs ${data.data.upcoming.first.fare!}",
                            style: TextStyle(fontSize: 11.sp),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
