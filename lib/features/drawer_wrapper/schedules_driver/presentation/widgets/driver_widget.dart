import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import '../../../../../core/utils/enums/ScheduleListType.dart';
import '../../../../../core/widgets/modals/map_model.dart';
import '../../data/models/get_drivers_list_response_model.dart';
import '../providers/schedule_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../../core/utils/constants/app_assets.dart';
import '../../../../../core/utils/constants/app_url.dart';
import '../../../../../core/utils/services/date_formating.dart';
import '../../../../../core/widgets/custom/dotted_line_painter.dart';
import 'owners_list_widget.dart';

// ignore: must_be_immutable
class DriverWidget extends StatelessWidget {

  DriverWidget({required this.driver, Key? key,required this.type}) : super(key: key);
  NearestDriver driver;
  ScheduleListType type;
  @override
  Widget build(BuildContext context) {
    return Consumer<ScheduleProvider>(builder: (context, provider, ch) {
      return Visibility(
        visible: !provider.getDriversListResponseModel!.data.schedule.rejected
            .contains(driver.id),
        child: GestureDetector(
          onTap: () {
            MapModel mapModel = MapModel(context,
                start: LatLng(double.parse(driver.startPoint.latitude),
                    double.parse(driver.startPoint.longitude)),
                end: LatLng(double.parse(driver.endPoint.latitude),
                    double.parse(driver.endPoint.longitude)),
                points: PolylinePoints().decodePolyline(driver.encodedPolyline),
                boundsNe: driver.boundsNe,
                boundsSw: driver.boundsSw);

            mapModel.show();
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              margin: EdgeInsets.only(bottom: 15.h),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const[
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
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 10.h),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 26.r,
                            backgroundImage: NetworkImage(AppUrl.fileBaseUrl +
                                driver.userId.profileImage),
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
                                  driver.userId.firstName +
                                      ' ' +
                                      driver.userId.lastName,
                                  maxLines: 1,
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w700),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
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
                                      (driver.userId.totalRating /
                                                  driver
                                                      .userId.totalRatingCount)
                                              .isNaN
                                          ? '0'
                                          : (driver.userId.totalRating /
                                                  driver
                                                      .userId.totalRatingCount)
                                              .toStringAsFixed(2),
                                      style: TextStyle(
                                          color: Theme.of(context).canvasColor,
                                          fontSize: 16.sp),
                                    ),
                                    SizedBox(
                                      width: 4.w,
                                    ),
                                    Text("Rs.${driver.fare}"),
                                    Expanded(child: Container()),
                                    driver.gender == 'male'
                                        ? const Icon(Icons.boy)
                                        : driver.gender == 'female'
                                            ? const Icon(Icons.girl)
                                            : Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  SizedBox(
                                                      width: 12.sp,
                                                      child: const Icon(Icons.boy)),
                                                  // Text("|"), 
                                                  SizedBox(
                                                      width: 12.sp,
                                                      child: const Icon(Icons.girl))
                                                ],
                                              ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          driver.accepted.contains(provider
                                  .getDriversListResponseModel!
                                  .data
                                  .schedule
                                  .id)
                              ? const Text("Accepted")
                              : driver.rejected.contains(provider
                                      .getDriversListResponseModel!
                                      .data
                                      .schedule
                                      .id)
                                  ? const Text("Rejected")
                                  : driver.cancelled.contains(provider
                                          .getDriversListResponseModel!
                                          .data
                                          .schedule
                                          .id)
                                      ? const Text("Cancelled")
                                      : provider.getDriversListResponseModel!
                                              .data.schedule.request
                                              .contains(driver.id)
                                          ? const Text("Requested")
                                          : Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                GestureDetector(
                                                    onTap: () {
                                                      context
                                                          .read<
                                                              ScheduleProvider>()
                                                          .rejectRequest(
                                                              driver.id);
                                                    },
                                                    child: SvgPicture.asset(
                                                        AppAssets.rejectSvg)),
                                                SizedBox(
                                                  width: 10.w,
                                                ),
                                                GestureDetector(
                                                    onTap: () {
                                                      if(type==ScheduleListType.requests){
                                                        context
                                                            .read<
                                                            ScheduleProvider>()
                                                            .acceptDriverRequest(
                                                            driver.id);
                                                      }else{
                                                        context
                                                            .read<
                                                            ScheduleProvider>()
                                                            .newrequest(
                                                            driver.id);
                                                      }

                                                    },
                                                    child: SvgPicture.asset(
                                                        AppAssets.acceptSvg)),
                                              ],
                                            )
                        ],
                      )),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                    decoration: const BoxDecoration(
                        border: Border(
                            top: BorderSide(color: Colors.black12, width: 1))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text(DateFormatService.formattedDate(driver.date)),
                            const SizedBox(
                              width: 5,
                            ),
                            // Text(driver.time),
                          ],
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
                            const SizedBox(
                              width: 6,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(driver.startPoint.placeName),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Text(driver.endPoint.placeName),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
