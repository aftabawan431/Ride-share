import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import '../../../../core/utils/globals/globals.dart';
import '../../../drawer_wrapper/schedules_driver/data/models/get_requested_passenger_response_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/constants/app_assets.dart';
import '../../../../core/utils/constants/app_url.dart';
import '../../../../core/widgets/custom/dotted_line_painter.dart';
import '../../../../core/widgets/modals/map_model.dart';
import '../pages/passenger_ride_screen.dart';
import '../providers/driver_ride_provider.dart';

class InRidePassengerRequestWidget extends StatefulWidget {
  final RequestedPassengerRequest passenger;
  const InRidePassengerRequestWidget({Key? key, required this.passenger})
      : super(key: key);

  @override
  State<InRidePassengerRequestWidget> createState() =>
      _InRidePassengerRequestWidgetState();
}

class _InRidePassengerRequestWidgetState
    extends State<InRidePassengerRequestWidget>
    with SingleTickerProviderStateMixin {
  bool visible = true;

  int counter = 30;

  late Animation<double> _animation;
  late Tween<double> _tween;
   AnimationController? _animationController;
  double value = 1;

  @override
  void initState() {
    super.initState();

    DriverRideProvider driverRideProvider = sl();
    if(driverRideProvider.inrideRequests.length>2){
      _animationController =
          AnimationController(duration: const Duration(seconds: 30), vsync: this);
      _tween = Tween(begin: 1, end: 0);
      _animation = _tween.animate(_animationController!)
        ..addListener(() {
          setState(() {
            value = _animation.value;
            if (value == 0) {
              if (driverRideProvider.inrideRequests.contains(widget.passenger)) {
                driverRideProvider
                    .removeInrideRequestFromList(widget.passenger.id);
                _animationController!.dispose();
              } else {
                _animationController!.dispose();
                _animationController!.dispose();
              }
            }
          });
        });

      _animationController!.forward();
    }

  }

  @override
  void dispose() {
    super.dispose();
    if(_animationController!=null){
      _animationController!.clearListeners();
      _animationController!.dispose();
    }

  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DriverRideProvider>(builder: (context, provider, ch) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        child: GestureDetector(
          onTap: () {
            MapModel mapModel = MapModel(context,
                start: LatLng(
                    double.parse(widget.passenger.startPoint.latitude),
                    double.parse(widget.passenger.startPoint.longitude)),
                end: LatLng(double.parse(widget.passenger.endPoint.latitude),
                    double.parse(widget.passenger.endPoint.longitude)),
                points: PolylinePoints()
                    .decodePolyline(widget.passenger.encodedPolyline),
                boundsNe: widget.passenger.boundsNe,
                boundsSw: widget.passenger.boundsSw);

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
                  LinearProgressIndicator(
                    value: value,
                    color: Theme.of(context).primaryColor,
                    backgroundColor: Colors.black12,
                    minHeight: 7.h,
                  ),
                  Container(
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 10.h),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 23.r,
                            backgroundImage: NetworkImage(AppUrl.fileBaseUrl +
                                widget.passenger.userId.profileImage),
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
                                  widget.passenger.userId.firstName +
                                      ' ' +
                                      widget.passenger.userId.lastName +
                                      ' ',
                                  maxLines: 1,
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w700),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SvgPicture.asset(
                                      AppAssets.star1Svg,
                                      width: 18.sp,
                                      color: Colors.orangeAccent,
                                    ),
                                    SizedBox(
                                      width: 4.w,
                                    ),
                                    Text(
                                      (widget.passenger.userId.totalRating /
                                                  widget.passenger.userId
                                                      .totalRatingCount)
                                              .isNaN
                                          ? '0'
                                          : (widget.passenger.userId
                                                      .totalRating /
                                                  widget.passenger.userId
                                                      .totalRatingCount)
                                              .toStringAsFixed(2),
                                      style: TextStyle(
                                          color: Theme.of(context).canvasColor,
                                          fontSize: 16.sp),
                                    ),
                                    Expanded(child: Container()),
                                    widget.passenger.userId.gender == 'male'
                                        ? const Icon(Icons.boy)
                                        : widget.passenger.gender == 'female'
                                            ? const Icon(Icons.girl)
                                            : Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  SizedBox(
                                                      width: 12.sp,
                                                      child: const Icon(
                                                          Icons.boy)),
                                                  // Text("|"), TODO:
                                                  SizedBox(
                                                      width: 12.sp,
                                                      child: const Icon(
                                                          Icons.girl))
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
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    context
                                        .read<DriverRideProvider>()
                                        .rejectInRideRequest(
                                            widget.passenger.id);
                                  },
                                  child: SvgPicture.asset(
                                    AppAssets.rejectSvg,
                                    width: 35.sp,
                                  )),
                              SizedBox(
                                width: 5.w,
                              ),
                              GestureDetector(
                                  onTap: () {
                                    context
                                        .read<DriverRideProvider>()
                                        .acceptInRideRequest(
                                            widget.passenger.id);
                                  },
                                  child: SvgPicture.asset(
                                    AppAssets.acceptSvg,
                                    width: 35.sp,
                                  )),
                            ],
                          )
                        ],
                      )),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: const BoxDecoration(
                        border: Border(
                            top: BorderSide(color: Colors.black12, width: 1))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text(
                              DateFormat("dd-MM-yyyy, hh:mm a").format(
                                  DateTime.parse(widget.passenger.date)
                                      .toLocal()),
                              style: TextStyle(fontSize: 13.sp),
                            ),
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
                                  size: 16.sp,
                                ),
                                CustomPaint(
                                    size: Size(1, 12.h),
                                    painter: DashedLineVerticalPainter()),
                                Icon(
                                  Icons.location_on,
                                  color: Theme.of(context).errorColor,
                                  size: 16.sp,
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
                                  Text(
                                    widget.passenger.startPoint.placeName,
                                    style: TextStyle(fontSize: 14.sp),
                                  ),
                                  SizedBox(
                                    height: 6.h,
                                  ),
                                  Text(
                                    widget.passenger.endPoint.placeName,
                                    style: TextStyle(fontSize: 14.sp),
                                  )
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
                                    '${(widget.passenger.distance / 1000).toStringAsFixed(1)} KM'),
                            RideStatWidget(
                                title: 'DURATION',
                                value:
                                    '${(widget.passenger.duration / 60) ~/ 60}h:${(widget.passenger.duration % 3600 / 60).floor()}m'),
                            RideStatWidget(
                                title: 'PASSENGERS',
                                value: widget.passenger.bookedSeats.toString()),
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
        ),
      );
    });
  }
}
