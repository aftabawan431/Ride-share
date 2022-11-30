import 'package:carousel_slider/carousel_slider.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rideshare/features/ride/presentation/widgets/in_ride_passengers_widget.dart';
import '../../../../core/router/app_state.dart';
import '../../../../core/widgets/custom/continue_button.dart';
import '../../data/models/chat_receiver_model.dart';
import 'chat_screen.dart';
import 'passenger_ride_screen.dart';
import '../providers/chat_provider.dart';
import '../providers/driver_ride_provider.dart';
import '../widgets/inride_passenger_request_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/router/models/page_action.dart';
import '../../../../core/router/models/page_config.dart';
import '../../../../core/utils/constants/app_assets.dart';
import '../../../../core/utils/constants/app_url.dart';
import '../../../../core/utils/enums/page_state_enum.dart';
import '../../../../core/utils/globals/globals.dart';
import '../../../../core/widgets/custom/dotted_line_painter.dart';
import '../../../drawer_wrapper/schedules_driver/presentation/providers/schedule_provider.dart';

class DriverRideScreen extends StatelessWidget {
  DriverRideScreen({Key? key}) : super(key: key);
  final DriverRideProvider driverRideProvider = sl();
  final ScheduleProvider scheduleProvider = sl();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider.value(value: driverRideProvider),
      ChangeNotifierProvider.value(value: scheduleProvider),
    ], child: const DriverRideScreenContent());
  }
}

class DriverRideScreenContent extends StatefulWidget {
  const DriverRideScreenContent({Key? key}) : super(key: key);

  @override
  State<DriverRideScreenContent> createState() =>
      _DriverRideScreenContentState();
}

class _DriverRideScreenContentState extends State<DriverRideScreenContent> {
  @override
  void initState() {
    super.initState();
    DriverRideProvider driverRideProvider = sl();
    driverRideProvider.selectedPassengerIndex = 0;
    driverRideProvider.inRideNewRequestListnerOn();
    driverRideProvider.passengerRideCancellationListener();
    driverRideProvider.isInDriverRideScreen = true;
    driverRideProvider.newMessageReceivedCountListener();
    driverRideProvider.confirmationByPassengerListener();
  }

  @override
  void dispose() {
    super.dispose();

    DriverRideProvider driverRideProvider = sl();
    driverRideProvider.confirmationByPassengerListenerOff();
    driverRideProvider.newMessageReceivedCountListenerOff();
    driverRideProvider.googleMapController!.dispose();
    // driverRideProvider.positionStream!.cancel();
    driverRideProvider.googleMapController = null;
    // driverRideProvider.positionStream = null;
    driverRideProvider.markers.clear();
    driverRideProvider.polylines.clear();
    driverRideProvider.inRideNewRequestListnerOff();
    // driverRideProvider.passengerRideCancellationListenerOff();
    driverRideProvider.isInDriverRideScreen = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<DriverRideProvider>(builder: (context, provider, ch) {
          return Stack(
            children: [
              Column(
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        height: .6.sh,
                        width: double.infinity,
                        child: GoogleMap(
                          onMapCreated: provider.onMapCreated,
                          myLocationEnabled: true,
                          zoomControlsEnabled: false,
                          myLocationButtonEnabled: true,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(userCurrentLocation!.latitude,
                                userCurrentLocation!.longitude),
                            zoom: 15,
                          ),
                          polylines: provider.polylines,
                          markers: provider.markers,
                        ),
                      ),
                      if (provider.inrideRequests.isNotEmpty)
                        SizedBox(
                          height: .6.sh,
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsets.only(top: 60.h),
                            child: ListView.builder(
                              itemCount: provider.inrideRequests.length,
                              itemBuilder: (context, index) {
                                return InRidePassengerRequestWidget(
                                    passenger: provider.inrideRequests[index]);
                              },
                            ),
                          ),
                        )
                    ],
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
                    padding: EdgeInsets.symmetric(horizontal: 2.w),
                    child: provider.currentRide.passengers.isEmpty
                        ? const Center(
                            child: Text("No passengers"),
                          )
                        : CarouselSlider(
                            options: CarouselOptions(
                              height: 260.h,
                              reverse: false,
                              autoPlay: false,
                              enableInfiniteScroll: false,
                              viewportFraction: .90,
                              onPageChanged: (index, reason) {
                                provider.setSelectedPassengerIndex(index);
                                provider.addSelectedPassengerLine();
                              },
                            ),
                            items: provider.currentRide.passengers
                                .map((passenger) {
                              return InRidePassenerWidget(passenger: passenger);
                            }).toList(),
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
