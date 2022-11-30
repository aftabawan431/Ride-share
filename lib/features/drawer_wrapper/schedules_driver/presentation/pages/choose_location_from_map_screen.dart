import 'package:flutter/material.dart';
import '../../../../../core/utils/enums/page_state_enum.dart';
import '../../../../../core/utils/location/dashboard_helper.dart';
import '../../../../../core/widgets/custom/continue_button.dart';
import '../../../../dashboard/presentation/providers/driver_dashboard_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../../../../core/router/app_state.dart';
import '../../../../../core/router/models/page_config.dart';
import '../../../../../core/utils/globals/globals.dart';
import '../../../../../core/utils/globals/snake_bar.dart';
import '../../../../authentication/auth_wrapper/presentation/providers/auth_provider.dart';

// ignore: must_be_immutable
class ChooseLocationFromMapScreen extends StatelessWidget {
  ChooseLocationFromMapScreen(
      {Key? key, this.isStartPoint = false, this.isDashboardWhereTo = false})
      : super(key: key);
  bool isStartPoint;
  bool isDashboardWhereTo = false;
  DashboardProvider provider = sl();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: provider,
        child: ChooseLocationFromMapScreenContent(
            isStartPoint: isStartPoint,
            isDashboardWhereTo: isDashboardWhereTo));
  }
}

// ignore: must_be_immutable
class ChooseLocationFromMapScreenContent extends StatefulWidget {
  ChooseLocationFromMapScreenContent(
      {Key? key, required this.isStartPoint, required this.isDashboardWhereTo})
      : super(key: key);
  bool isStartPoint;
  bool isDashboardWhereTo;


  @override
  State<ChooseLocationFromMapScreenContent> createState() =>
      _ChooseLocationFromMapScreenContentState();
}

class _ChooseLocationFromMapScreenContentState
    extends State<ChooseLocationFromMapScreenContent> with AutomaticKeepAliveClientMixin {

  bool clicked=false;
  ValueNotifier<bool> addLocationLoading = ValueNotifier(false);

  LatLng _lastMapPosition =
      LatLng(userCurrentLocation!.latitude, userCurrentLocation!.longitude);

  _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;

    setState(() {
      _markers = {};
      _markers.add(Marker(
        markerId: const MarkerId('current'),
        position: LatLng(position.target.latitude, position.target.longitude),
      ));
    });
  }

  Set<Marker> _markers = {};

  _handleTap(LatLng tappedPoint) {
    setState(() {
      _markers = {};

      _markers.add(Marker(
          markerId: const MarkerId('current'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          position: tappedPoint,
          draggable: true,
          onTap: () {},
          onDragEnd: (dragEndPosition) {}));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            GoogleMap(
                zoomControlsEnabled: false,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                onCameraMove: _onCameraMove,
                markers: _markers,
                onMapCreated: (controller) async {
                  setState(() {
                    _markers.add(Marker(
                      markerId: const MarkerId('current'),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueRed),
                      // anchor: Offset(0.5, 0.5),
                      position: LatLng(
                        userCurrentLocation!.latitude,
                        userCurrentLocation!.longitude,
                      ),
                    ));
                  });

                  controller.animateCamera(CameraUpdate.newCameraPosition(
                      CameraPosition(
                          target: LatLng(userCurrentLocation!.latitude,
                              userCurrentLocation!.longitude),
                          zoom: 15)));
                },
                onTap: _handleTap,
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                      userCurrentLocation == null
                          ? 33.6844
                          : userCurrentLocation!.latitude,
                      userCurrentLocation == null
                          ? 73.0479
                          : userCurrentLocation!.longitude),
                  zoom: 16,
                )),
            // Align(
            //   alignment: Alignment.center,
            //   child: Icon(Icons.location_on_sharp,color: Colors.red,),
            // ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
                  child: ContinueButton(
                      loadingNotifier: addLocationLoading,
                      text: 'Done',
                      onPressed: () async {
                        DashBoardHelper dashboardHelper = sl();

                        DashboardProvider dashboardProvider = sl();

                        final position = Position(
                            longitude: _lastMapPosition.longitude,
                            latitude: _lastMapPosition.latitude,
                            timestamp: DateTime.now(),
                            accuracy: 0,
                            altitude: 0,
                            heading: 0,
                            speed: 0,
                            speedAccuracy: 0);
                        addLocationLoading.value = true;
                        final response = await dashboardHelper
                            .searchCoordinateAddress(position);
                        Logger().v(response.placeId);
                        AppState appState = sl();

                        if (widget.isDashboardWhereTo) {
                          await dashboardProvider
                              .setDashboardDropOfLocation(response.placeId);
                          addLocationLoading.value = false;
                          goToNewRideScreen();
                          return;

                          // return appState.moveToBackScreen()  ;
                        }

                        // this is where to value
                        if (widget.isStartPoint) {
                          dashboardProvider.setPickUpLocation(response.placeId);

                          return appState.moveToBackScreen();
                        } else {
                          // this is where from value
                          dashboardProvider.setDropOfLocation(response.placeId);
                          addLocationLoading.value = false;

                          return appState.moveToBackScreen();
                        }
                      })),
            ),
            Positioned(
              top: 10.h,
              left: 10.h,
              child: GestureDetector(
                onTap: () {
                  if(clicked){
                    return;
                  }
                  clicked=true;
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
        ),
      ),
    );
  }

  goToNewRideScreen() {
    if(clicked==true){
      return;
    }
    clicked=true;
    DashboardProvider provider = sl();

    AuthProvider authProvider = sl();

    if (authProvider.currentUser!.selectedUserType == '1' &&
        authProvider.currentUser!.selectedVehicle == null) {
      ShowSnackBar.show('Please add a vehicle first');

      AppState appState = GetIt.I.get<AppState>();
      appState.goToNext(PageConfigs.vehicleDetailsPageConfig,
          pageState: PageState.replace);

      return;
    } else if (authProvider.currentUser!.selectedUserType == '1' &&
        authProvider.currentUser!.selectedVehicle != null) {
      provider.setDriverVehicleCapacity();
    }

    if (provider.dashboardDropofLocation != null) {
      provider.setDropOfLocation(provider.dashboardDropofLocation!.placeId);
    } else {
      provider.setDropOfLocation(null);
    }
    if (provider.isRequesting) {
      provider.setDefaultHeight(provider.defaultHeight - 200.h);
      provider.setIsRequesting(false);
    }

    AppState appState = sl();
    appState.goToNext(PageConfigs.newRidePageConfig,
        pageState: PageState.replace);
  }
  @override
  bool get wantKeepAlive => true;
}
