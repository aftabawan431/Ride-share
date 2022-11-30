import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rideshare/core/utils/network/network_service.dart';
import 'package:flutter_rideshare/core/utils/services/device_info_service.dart';
import 'package:flutter_rideshare/core/utils/services/package_info_service.dart';
import 'package:flutter_rideshare/core/widgets/bottom_sheets/cancel_reason_bottom_sheet.dart';
import 'package:flutter_rideshare/core/widgets/custom_shadow_icon_button.dart';
import 'package:flutter_rideshare/core/widgets/modals/update_app_model.dart';
import 'package:flutter_rideshare/features/dashboard/presentation/widgets/active_ride_widget.dart';
import 'package:flutter_rideshare/features/dashboard/presentation/widgets/dashboard_history_rides_row.dart';
import 'package:flutter_rideshare/features/ride/presentation/providers/passenger_ride_provider.dart';
import 'package:logger/logger.dart';
import '../../../../core/router/models/page_config.dart';
import '../../../../core/utils/constants/socket_point.dart';
import '../../../../core/utils/extension/extensions.dart';
import '../../../../core/utils/location/location_api.dart';
import '../../../authentication/auth_wrapper/data/models/login_response_modal.dart';
import '../../../authentication/auth_wrapper/presentation/providers/auth_provider.dart';
import '../../../authentication/select_user/presentation/pages/banner_slider.dart';
import '../../../drawer_wrapper/schedules_driver/presentation/pages/choose_location_from_map_screen.dart';
import '../widgets/dashboard_upcoming_ride_widget.dart';
import '../providers/driver_dashboard_provider.dart';
import '../widgets/dashboard_map_widget.dart';
import '../widgets/loading/dashboard_shimmer_loading.dart';
import '../../../ride/presentation/providers/driver_ride_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import '../../../../core/router/app_state.dart';
import '../../../../core/router/models/page_action.dart';
import '../../../../core/router/places_provider.dart';
import '../../../../core/utils/enums/page_state_enum.dart';
import '../../../../core/utils/firebase/push_notification_service.dart';
import '../../../../core/utils/globals/globals.dart';
import '../../../../core/utils/sockets/sockets.dart';
import '../widgets/dashboard_where_to_widget.dart';
import '../widgets/drawers/dashboard_drawer.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({Key? key}) : super(key: key);
  final AuthProvider authProvider = sl();
  final DashboardProvider driverDashboardProvider = sl();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider.value(value: authProvider),
      ChangeNotifierProvider.value(value: driverDashboardProvider),
    ], child: const DashboardScreenContent());
  }
}

class DashboardScreenContent extends StatefulWidget {
  const DashboardScreenContent({Key? key}) : super(key: key);

  @override
  State<DashboardScreenContent> createState() => _DashboardScreenContentState();
}

class _DashboardScreenContentState extends State<DashboardScreenContent> {
  PlacesProvider placesProvider = sl();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SocketService.init();
    getLocation();

    AuthProvider authProvider = sl();
    PassengerRideProvider passengerRideProvider = sl();
    passengerRideProvider.homeContext = context;
    context.read<DashboardProvider>().getDashboardData();
    context.read<DashboardProvider>().dashboardDropofLocation = null;
    context.read<DashboardProvider>().isScheduled = false;
    context.read<DashboardProvider>().refreshDashboardListner(true);
    context.read<DashboardProvider>().deviceInfoUpdates(true);
    context.read<DashboardProvider>().setErrorListener();
    context.read<DashboardProvider>().driverStartRideListener();
    PushNotifcationService().checkNewStartApp();
    placesProvider.getPlaces('Islamabad');
    context.read<DashboardProvider>().setDateTimeControllerDefaultValue();
    onBackPress = null;
    if (authProvider.currentUser!.selectedUserType == '1') {
      Timer(const Duration(seconds: 10), () {
        if (authProvider.currentUser == null) {
          return;
        }
        context.read<DashboardProvider>().syncIfAnyCachedRides();
      });
    }
  }

  getLocation()async{
    if (userCurrentLocation == null) {
      final position = await LocationApi.determinePosition();
      userCurrentLocation = position;
    }
  }

  @override
  void dispose() {
    super.dispose();
    DriverRideProvider driverRideProvider = sl();
    driverRideProvider.passengerRideCancellationListenerOff();
    DashboardProvider provider = sl();
    provider.refreshDashboardListner(false);
    provider.deviceInfoUpdates(false);
    provider.driverStartRideListnerOff();
    if (SocketService.socket != null) {
      SocketService.off(SocketPoint.errorListner);
    }
    if (provider.positionStream != null) {
      provider.positionStream!.cancel();
    }

    // AuthProvider authProvider = sl();

    // if(authProvider.currentUser!.selectedUserType=='1'){
    //   NetworkService.dispose();
    // }
    SocketService.close();
  }
  Future<bool> onbackpress() async{
    return false;
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onbackpress,

      child: Scaffold(
        key: context.read<DashboardProvider>().dashboardScaffoldKey,
        drawer: const DashboardDrawer(),
        backgroundColor: Colors.white,
        body: ValueListenableBuilder<bool>(
            valueListenable:
                context.read<DashboardProvider>().getDashboardDataLoading,
            builder: (context, loading, ch) {
              if (loading) {
                return const DashboardShimmerLoading();
              } else {
                return SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        child: Column(

                          children: [
                            Selector<AuthProvider, User>(
                                selector: (_, provider) => provider.currentUser!,
                                builder: (context, user, ch) {
                                  return Container(
                                    padding: EdgeInsets.symmetric(vertical: 5.h),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomShadowIconButton(
                                          onTap: () {
                                            context
                                                .read<DashboardProvider>()
                                                .dashboardScaffoldKey
                                                .currentState!
                                                .openDrawer();
                                          },
                                          icon: Icons.menu,
                                          iconSize: 35.sp,
                                        ),
                                        Expanded(
                                          child: Text(
                                            "Welcome, ${user.firstName.toTitleCase()} ${user.lastName.toTitleCase()}",
                                            style: TextStyle(
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.bold),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        CustomShadowIconButton(
                                          onTap: _profileTap,
                                          icon: Icons.person,
                                          iconSize: 30.sp,
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                            const SizedBox(
                              width: 10,
                            ),
                            // TextButton(onPressed: (){
                            //   CancelReasonBottomSheet bottomSheet=CancelReasonBottomSheet(context: navigatorKeyGlobal.currentContext!,
                            //   reasons: [
                            //     "Driver didn't arrive",
                            //     "Other"
                            //   ],
                            //     onPressed: (){
                            //
                            //     }
                            //
                            //   );
                            //   bottomSheet.show();
                            // }, child: Text("test")),
                            const BannerSlider(),
                            SizedBox(
                              height: 25.h,
                            ),
                            const DashboardWhereToWidget(),
                            SizedBox(
                              height: 10.h,
                            ),
                            const DashboardUpcomingRideWidget(),
                            SizedBox(
                              height: 10.h,
                            ),
                            const DashboardActiveRideWidget(),
                            // SizedBox(
                            //   height: 20.h,
                            // ),
                            // // const DashboardMapWidget(),
                            SizedBox(
                              height: 6.h,
                            ),
                            const DashboardHistoryRidesRow(),
                            SizedBox(
                              height: 20.h,
                            ),
                          ],
                        ),
                      ),
                    ));
              }
            }),
      ),
    );
  }

  _profileTap() {
    AppState appState = sl();
    appState.currentAction = PageAction(
      state: PageState.addPage,
      page: PageConfigs.profileScreenPageConfig,
    );
  }
}
