import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rideshare/core/widgets/modals/confirm_ride_modal.dart';
import '../../../../core/utils/globals/loading.dart';
import '../../../../core/widgets/bottom_sheets/cancel_reason_bottom_sheet.dart';
import '../../../../core/widgets/custom/continue_button.dart';
import '../../../drawer_wrapper/schedules_driver/presentation/providers/schedule_provider.dart';
import '../providers/passenger_ride_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/router/app_state.dart';
import '../../../../core/router/models/page_action.dart';
import '../../../../core/router/models/page_config.dart';
import '../../../../core/utils/constants/app_assets.dart';
import '../../../../core/utils/constants/app_url.dart';
import '../../../../core/utils/enums/page_state_enum.dart';
import '../../../../core/utils/globals/globals.dart';
import '../../../../core/widgets/custom/dotted_line_painter.dart';

import '../../data/models/chat_receiver_model.dart';
import '../providers/chat_provider.dart';
import 'chat_screen.dart';

class PassengerRideScreen extends StatelessWidget {
  PassengerRideScreen({Key? key}) : super(key: key);
  final PassengerRideProvider passengerRideProvider = sl();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [ChangeNotifierProvider.value(value: passengerRideProvider)],
        child: const PassengerRideScreenContent());
  }
}

class PassengerRideScreenContent extends StatefulWidget {
  const PassengerRideScreenContent({Key? key}) : super(key: key);

  @override
  State<PassengerRideScreenContent> createState() =>
      _PassengerRideScreenContentState();
}

class _PassengerRideScreenContentState
    extends State<PassengerRideScreenContent> {
  PassengerRideProvider passengerRideProvider = sl();

  @override
  void initState() {
    super.initState();
    passengerRideProvider.showLiveLocations = true;
    passengerRideProvider.isInScreen = true;
    passengerRideProvider.newMessageReceivedCountListener();
  }

  @override
  void dispose() {
    super.dispose();
    passengerRideProvider.updateActiveRIdeStatusListnerOff();
    passengerRideProvider.newMessageReceivedCountListenerOff();
    passengerRideProvider.isInScreen = false;
    // passengerRideProvider.updateActiveRIdeStatusListnerOff();
    passengerRideProvider.showLiveLocations = false;
    passengerRideProvider.googleMapController!.dispose();
    passengerRideProvider.googleMapController = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:
            Consumer<PassengerRideProvider>(builder: (context, provider, ch) {
          return Stack(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: .57.sh,
                    width: double.infinity,
                    child: GoogleMap(
                      onMapCreated: provider.onMapCreated,
                      myLocationEnabled: true,
                      zoomControlsEnabled: false,
                      myLocationButtonEnabled: true,
                      initialCameraPosition: const CameraPosition(
                        target: LatLng(33.6844, 73.0479),
                        zoom: 15,
                      ),
                      polylines: provider.polylines,
                      markers: provider.markers,
                    ),
                  ),
                  Expanded(
                      child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black12,
                              spreadRadius: 1.5,
                              blurRadius: 1.5,
                              offset: Offset(0, -1))
                        ],
                        borderRadius: BorderRadius.circular(15.sp)),
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                    child: Column(
                      children: [
                        returnStatus(provider.currentRide!.status),
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 26.r,
                              backgroundImage: NetworkImage(AppUrl.fileBaseUrl +
                                  provider.currentRide!.data.route.userId
                                      .profileImage),
                            ),
                            SizedBox(
                              width: 8.w,
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  provider.currentRide!.data.route.userId
                                          .firstName +
                                      ' ' +
                                      provider.currentRide!.data.route.userId
                                          .lastName,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                  ),
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
                                      getFormattedRating(
                                          provider.currentRide!.data.route
                                              .userId.totalRating,
                                          provider.currentRide!.data.route
                                              .userId.totalRatingCount),
                                      style: TextStyle(
                                          color: Theme.of(context).canvasColor,
                                          fontSize: 16.sp),
                                    )
                                  ],
                                )
                              ],
                            ),
                            Expanded(child: Container()),
                            if (provider.currentRide!.status != 'completed')
                              Stack(
                                children: [
                                  SizedBox(
                                    height: 40.r,
                                    width: 35.r,
                                    child: FloatingActionButton(
                                      onPressed: _messageOnTap,
                                      child: Padding(
                                        padding: EdgeInsets.all(4.r),
                                        child: Icon(
                                          Icons.message,
                                          color: Colors.white,
                                          size: 23.sp,
                                        ),
                                      ),
                                      mini: true,
                                      backgroundColor: Colors.deepPurpleAccent,
                                    ),
                                  ),
                                  if (provider.currentRide!.count > 0)
                                    CircleAvatar(
                                      radius: 8.r,
                                      backgroundColor: Colors.redAccent,
                                      child: Center(
                                        child: Text(
                                          provider.currentRide!.count
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 7.sp,
                                              color: Colors.white),
                                        ),
                                      ),
                                    )
                                ],
                              ),
                            SizedBox(
                              width: 5.w,
                            ),
                            SizedBox(
                              height: 40.r,
                              width: 35.r,
                              child: FloatingActionButton(
                                onPressed: _onPhoneOnTap,
                                child: Padding(
                                  padding: EdgeInsets.all(4.r),
                                  child: Icon(
                                    Icons.call,
                                    color: Colors.white,
                                    size: 25.sp,
                                  ),
                                ),
                                mini: true,
                                backgroundColor: Theme.of(context).primaryColor,
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
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
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    provider.currentRide!.data.schedule
                                        .startPoint.placeName,
                                    style: TextStyle(fontSize: 14.sp),
                                  ),
                                  SizedBox(
                                    height: 8.h,
                                  ),
                                  Text(
                                    provider.currentRide!.data.schedule.endPoint
                                        .placeName,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(fontSize: 14.sp),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(AppAssets.carSvg),
                            SizedBox(
                              width: 20.w,
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  RideStatWidget(
                                      title: 'DISTANCE',
                                      value:
                                          '${(provider.currentRide!.data.schedule.distance / 1000).toStringAsFixed(1)} KM'),
                                  RideStatWidget(
                                      title: 'TIME',
                                      value:
                                          '${(provider.currentRide!.data.schedule.duration / 60) ~/ 60}h:${(provider.currentRide!.data.schedule.duration % 3600 / 60).floor()}m'),
                                  RideStatWidget(
                                      title: 'SEAT',
                                      value: provider
                                          .currentRide!.data.schedule.seats),
                                  RideStatWidget(
                                      title: 'FARE',
                                      value: 'Rs: ' +
                                          provider
                                              .currentRide!.data.schedule.fare
                                              .toString()),
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            if (provider.currentRide!.status == 'pending' ||
                                provider.currentRide!.status == 'arrived' ||
                                provider.currentRide!.status == 'active')
                              SizedBox(
                                height: 35.h,
                                width: 120.w,
                                child: ContinueButton(
                                    backgroundColor: Colors.red.withOpacity(.8),
                                    text: 'Cancel',
                                    onPressed: () => _onCancelTap(context)),
                              ),
                            if (provider.currentRide!.status == 'arrived')
                              SizedBox(
                                height: 35.h,
                                width: 120.w,
                                child: ContinueButton(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    text: 'Confirm',
                                    onPressed: () async {
                                      ConfirmRideModal confirmRideModel =
                                          ConfirmRideModal(context);
                                      confirmRideModel.show();
                                    }),
                              )
                          ],
                        ),
                      ],
                    ),
                  ))
                ],
              ),
              Positioned(
                top: 10.h,
                left: 10.h,
                child: GestureDetector(
                  onTap: () {
                    AppState appState = sl();
                    appState.moveToBackScreen();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            spreadRadius: 1,
                            blurRadius: 1,
                          )
                        ]),
                    child: Icon(
                      Icons.keyboard_arrow_left,
                      color: Theme.of(context).primaryColor,
                      size: 25.sp,
                    ),
                  ),
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}

_messageOnTap() {
  PassengerRideProvider provider = sl();
  provider.setNewMessageCountToZero();
  ChatProvider chatProvider = sl();
  chatProvider.receiver = ChatReceiverModel(
      id: provider.currentRide!.data.route.userId.id,
      profileImage: provider.currentRide!.data.route.userId.profileImage,
      name: provider.currentRide!.data.route.userId.getFullName());
  AppState appState = sl();
  appState.currentAction = PageAction(
      state: PageState.addWidget,
      page: PageConfigs.chatPageConfig,
      widget: ChatScreen(
        receiverId: provider.currentRide!.data.route.userId.id,
      ));
}

_onCancelTap(BuildContext context) async {
PassengerRideProvider provider=sl();
  List<String> reasons =provider.currentRide!.status=='arrived'?["Driver didn't arrive"]: [
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
        PassengerRideProvider provider = sl();


        Loading.show();
        ScheduleProvider scheduleProvider = sl();
        scheduleProvider.cancelPassengerInrideScheduledRide(
            routeId: provider.currentRide!.data.route.id,
            scheduleId: provider.currentRide!.data.schedule.id,
            reason:reason
        );
        Navigator.of(context)
            .pop();
      });
  bottomSheet.show();





}

_onPhoneOnTap() async {
  PassengerRideProvider provider = sl();

  String url =
      'tel:' + provider.currentRide!.data.route.userId.mobile.toString();
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    throw 'Could not launch $url';
  }
}

Widget returnStatus(String text) {
  return Text(
    text == 'pending'
        ? "Your ride is enroute"
        : text == 'active'
            ? 'Driver is on the way'
            : text == 'arrived'
                ? 'Driver has arrived'
                : text == 'inprogress'
                    ? 'To the destination'
                    : 'Completed',
    style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700),
  );
}

class RideStatWidget extends StatelessWidget {
  const RideStatWidget({Key? key, required this.value, required this.title})
      : super(key: key);
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title.toUpperCase(),
          style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).canvasColor),
        ),
        SizedBox(
          height: 3.h,
        ),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp),
        )
      ],
    );
  }
}
