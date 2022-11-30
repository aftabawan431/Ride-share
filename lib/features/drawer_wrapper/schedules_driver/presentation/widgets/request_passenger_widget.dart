// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../../../../core/utils/constants/app_assets.dart';
import '../../../../../core/utils/constants/app_url.dart';
import '../../../../../core/utils/enums/ScheduleListType.dart';
import '../../../../../core/utils/globals/globals.dart';
import '../../../../../core/utils/globals/loading.dart';
import '../../../../../core/utils/services/date_formating.dart';
import '../../../../../core/widgets/bottom_sheets/cancel_reason_bottom_sheet.dart';
import '../../../../../core/widgets/custom/dotted_line_painter.dart';
import '../../../../../core/widgets/modals/map_model.dart';
import '../../../../ride/presentation/pages/passenger_ride_screen.dart';
import '../../data/models/get_requested_passenger_response_model.dart';
import '../providers/schedule_provider.dart';

// ignore: must_be_immutable
class RequestedPassengerWidget extends StatelessWidget {
  RequestedPassengerWidget(
      {Key? key, required this.passenger, required this.type})
      : super(key: key);
  RequestedPassengerRequest passenger;
  ScheduleListType type;
  @override
  Widget build(BuildContext context) {
    return Consumer<ScheduleProvider>(builder: (context, provider, ch) {
      //   if(passenger.status=='cancelled'){
      //   return const SizedBox.shrink();
      // }

      return GestureDetector(
        onTap: () {
          Logger().v(passenger.toJson());

          MapModel mapModel = MapModel(context,
              start: LatLng(double.parse(passenger.startPoint.latitude),
                  double.parse(passenger.startPoint.longitude)),
              end: LatLng(double.parse(passenger.endPoint.latitude),
                  double.parse(passenger.endPoint.longitude)),
              points:
                  PolylinePoints().decodePolyline(passenger.encodedPolyline),
              boundsNe: passenger.boundsNe,
              boundsSw: passenger.boundsSw);

          mapModel.show();
        },
        child: ClipRRect(
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
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 26.r,
                          backgroundImage: NetworkImage(AppUrl.fileBaseUrl +
                              passenger.userId.profileImage),
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
                                passenger.userId.firstName +
                                    ' ' +
                                    passenger.userId.lastName +
                                    ' ',
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
                                    (passenger.userId.totalRating /
                                                passenger
                                                    .userId.totalRatingCount)
                                            .isNaN
                                        ? '0'
                                        : (passenger.userId.totalRating /
                                                passenger
                                                    .userId.totalRatingCount)
                                            .toStringAsFixed(2),
                                    style: TextStyle(
                                        color: Theme.of(context).canvasColor,
                                        fontSize: 16.sp),
                                  ),
                                  Expanded(child: Container()),
                                  passenger.gender == 'male'
                                      ? const Icon(Icons.boy)
                                      : passenger.gender == 'female'
                                          ? const Icon(Icons.girl)
                                          : Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                SizedBox(
                                                    width: 12.sp,
                                                    child:
                                                        const Icon(Icons.boy)),
                                                // Text("|"),
                                                SizedBox(
                                                    width: 12.sp,
                                                    child:
                                                        const Icon(Icons.girl))
                                              ],
                                            ),
                                  const SizedBox(
                                    width: 8,
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        provider.getRequestedPassengerResponseModel!.data
                                .cancelled
                                .contains(passenger.id)
                            ? Text("Cancelled")
                            : (type == ScheduleListType.matched &&
                                    provider.getRequestedPassengerResponseModel!
                                        .data.myRequests
                                        .contains(passenger.id))
                                ? Text("Requested")
                                : passenger.status == 'completed'
                                    ? const Text("Completed")
                                    : provider
                                            .getRequestedPassengerResponseModel!
                                            .data
                                            .accepted
                                            .contains(passenger.id)
                                        ? GestureDetector(
                                            onTap: () {
                                              List<String> reasons = [
                                                "Wrong schedule time",
                                                "Other"
                                              ];

                                              CancelReasonBottomSheet
                                                  bottomSheet =
                                                  CancelReasonBottomSheet(
                                                      context:
                                                          navigatorKeyGlobal
                                                              .currentContext!,
                                                      reasons: reasons,
                                                      onPressed: (reason) {
                                                        print(reason);

                                                        Loading.show();
                                                        context
                                                            .read<
                                                                ScheduleProvider>()
                                                            .cancelPassengerRide(
                                                                passenger.id,reason);
                                                        Navigator.of(context)
                                                            .pop();
                                                      });
                                              bottomSheet.show();
                                            },
                                            child: SvgPicture.asset(
                                                AppAssets.rejectSvg))
                                        : provider
                                                .getRequestedPassengerResponseModel!
                                                .data
                                                .rejected
                                                .contains(passenger.id)
                                            ? const Text("Rejected")
                                            : Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  GestureDetector(
                                                      onTap: () {
                                                        context
                                                            .read<
                                                                ScheduleProvider>()
                                                            .rejectPassengerRequest(
                                                                passenger.id);
                                                      },
                                                      child: SvgPicture.asset(
                                                          AppAssets.rejectSvg)),
                                                  SizedBox(
                                                    width: 10.w,
                                                  ),
                                                  GestureDetector(
                                                      onTap: () {
                                                        if (type ==
                                                            ScheduleListType
                                                                .matched) {
                                                          context
                                                              .read<
                                                                  ScheduleProvider>()
                                                              .sendRequestToPasenger(
                                                                  passenger.id);
                                                        } else {
                                                          context
                                                              .read<
                                                                  ScheduleProvider>()
                                                              .accpetRequest(
                                                                  passenger.id);
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
                          Text(DateFormatService.formattedDate(passenger.date)),
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
                                Text(passenger.startPoint.placeName),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Text(passenger.endPoint.placeName)
                              ],
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          RideStatWidget(
                              title: 'DISTANCE',
                              value:
                                  '${(passenger.distance / 1000).toStringAsFixed(1)} KM'),
                          RideStatWidget(
                              title: 'DURATION',
                              value:
                                  '${(passenger.duration / 60) ~/ 60}h:${(passenger.duration % 3600 / 60).floor()}m'),
                          RideStatWidget(
                              title: 'Passengers',
                              value: passenger.bookedSeats.toString()),
                          RideStatWidget(
                              title: 'Fare', value: "Rs.${passenger.fare}"),
                        ],
                      ),
                      SizedBox(
                        height: 7.h,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
