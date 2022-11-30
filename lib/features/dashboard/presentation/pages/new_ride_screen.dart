import 'package:flutter/material.dart';
import 'package:flutter_rideshare/core/utils/globals/loading.dart';
import '../../../../core/router/models/page_config.dart';
import '../../../../core/router/places_provider.dart';
import '../../../../core/utils/globals/globals.dart';
import '../../../../core/utils/globals/snake_bar.dart';
import '../../../authentication/auth_wrapper/presentation/providers/auth_provider.dart';
import '../providers/driver_dashboard_provider.dart';
import '../widgets/maps/driver_map_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../../../../core/router/app_state.dart';
import '../../../../core/router/models/page_action.dart';
import '../../../../core/utils/enums/page_state_enum.dart';
import '../widgets/location_text_containers/driver_location_text_container.dart';



// ignore: must_be_immutable
class NewRideScreen extends StatelessWidget {
  NewRideScreen({Key? key}) : super(key: key);
  AuthProvider authProvider = sl();

  DashboardProvider driverDashboardProvider = sl();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider.value(value: driverDashboardProvider),
      ChangeNotifierProvider.value(value: authProvider),
    ], child: const DriverDashboardScreenContent());
  }
}

class DriverDashboardScreenContent extends StatefulWidget {
  const DriverDashboardScreenContent({Key? key}) : super(key: key);

  @override
  State<DriverDashboardScreenContent> createState() =>
      _DriverDashboardScreenContentState();
}

class _DriverDashboardScreenContentState
    extends State<DriverDashboardScreenContent> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  PlacesProvider placesProvider = sl();

  late Socket socket;

  @override
  void initState() {
    super.initState();
    placesProvider.getPlaces('Islamabad');
if(mounted){
  AuthProvider authProvider=sl();
  context.read<DashboardProvider>().markers.clear();
  context.read<DashboardProvider>().polylines.clear();
  context.read<DashboardProvider>().circles.clear();
  context.read<DashboardProvider>().selectedSeat=1;
  context.read<DashboardProvider>().kmLeverage=5;
  context.read<DashboardProvider>().corporateCodeStatus=true;
  context.read<DashboardProvider>().corporateCodeStatus=authProvider.currentUser!.activeCorporateCode;
  context.read<DashboardProvider>().setDefaultHeight(context.read<DashboardProvider>().defaultHeight);


  _fetchPermissionStatus();
}
  }

  void _fetchPermissionStatus() {
    Permission.locationWhenInUse.status.then((status) {
      if (status != PermissionStatus.granted) {
        ShowSnackBar.show('Please allow location permissions');
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    DashboardProvider provider = sl();
    provider.googleMapController!.dispose();
    if (provider.positionStream != null) {
      provider.positionStream!.cancel();
    }
    // provider.campusStream!.cancel();
    provider.googleMapController = null;
    provider.positionStream = null;
    // provider.campusStream=null;
    provider.markers.clear();
    provider.circles.clear();
    provider.polylines.clear();
    Loading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
            key: _key,
            // drawer: const DriverDashboardDrawer(),
            body: Consumer<DashboardProvider>(
                child: const DriverMapWidget(),
                builder: (context, provider, ch) {
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      //driver map widget
                      ch!,
                      Positioned(
                        bottom: provider.defaultHeight + 20.h,
                        right: 20,
                        child: GestureDetector(
                          onTap: () {
                            context
                                .read<DashboardProvider>()
                                .moveToCurrentLocation();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(100),
                                boxShadow: const[
                                   BoxShadow(
                                    color: Colors.black12,
                                    spreadRadius: 1,
                                    blurRadius: 1,
                                  )
                                ]),
                            child: Icon(
                              Icons.my_location_rounded,
                              color: Colors.black,
                              size: 25.sp,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20.w,
                        top: 20.h,
                        child: GestureDetector(
                          onTap: () async {
                            if (provider.isRequesting) {
                              await provider.setCurrentLocation();
                              provider.setDefaultHeight(
                                  provider.defaultHeight - 200.h);
                              provider.setIsRequesting(false);
                              provider.setDashboardDropOfLocation(null);
                            } else {
                              AppState appState = sl();
                              appState.moveToBackScreen();
                              // _key.currentState!.openDrawer();
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
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
                            child: provider.isRequesting
                                ? Icon(
                                    Icons.close,
                                    color: Theme.of(context).primaryColor,
                                    size: 25.sp,
                                  )
                                : Icon(
                                    Icons.keyboard_arrow_left,
                                    color: Theme.of(context).primaryColor,
                                    size: 25.sp,
                                  ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 20.w,
                        top: 20.h,
                        child: GestureDetector(
                          onTap: () {
                            AppState appState = GetIt.I.get<AppState>();
                            appState.currentAction = PageAction(
                              state: PageState.addPage,
                              page: PageConfigs.profileScreenPageConfig,
                            );
                          },
                          child: Container(
                            padding:const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(100),
                                boxShadow: const[
                                  BoxShadow(
                                    color: Colors.black12,
                                    spreadRadius: 1,
                                    blurRadius: 1,
                                  )
                                ]),
                            child: Icon(
                              Icons.person,
                              color: Theme.of(context).primaryColor,
                              size: 25.sp,
                            ),
                          ),
                        ),
                      ),

                      //container 1
                      Positioned(
                          height: provider.defaultHeight,
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: DriverLocationTextContainer())
                    ],
                  );
                })),
      ),
    );
  }
}
