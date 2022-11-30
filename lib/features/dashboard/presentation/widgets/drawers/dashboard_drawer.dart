import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../../../core/router/models/page_config.dart';
import '../../../../../core/utils/constants/app_assets.dart';
import '../../../../../core/utils/constants/app_url.dart';
import '../../../../../core/utils/extension/extensions.dart';
import '../../../../../core/utils/globals/globals.dart';
import '../../../../../core/utils/location/location_api.dart';
import '../../../../authentication/auth_wrapper/presentation/providers/auth_provider.dart';
import '../../providers/driver_dashboard_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../../../../core/router/app_state.dart';
import '../../../../../core/router/models/page_action.dart';
import '../../../../../core/router/pages.dart';
import '../../../../../core/utils/enums/page_state_enum.dart';

class DashboardDrawer extends StatelessWidget {
  const DashboardDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Consumer<AuthProvider>(builder: (context, provider, ch) {
            return SizedBox(
              height: 260.h,
              child: Stack(
                children: [
                  SvgPicture.asset(
                    AppAssets.inviteFriendsBgSvg,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                    // decoration: BoxDecoration(color: Theme.of(context).primaryColor),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 40.h,
                        ),
                        CircleAvatar(
                          radius: 40.r,
                          backgroundImage: NetworkImage(AppUrl.fileBaseUrl +
                              provider.currentUser!.profileImage),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                            "${provider.currentUser!.firstName.toTitleCase()} ${provider.currentUser!.lastName.toTitleCase()}"),
                        SizedBox(
                          height: 10.h,
                        ),
                        RatingBar.builder(
                          initialRating: double.parse(getFormattedRating(
                              provider.currentUser!.totalRating,
                              provider.currentUser!.totalRatingCount)),
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: false,
                          glow: false,
                          ignoreGestures: true,
                          itemCount: 5,
                          itemSize: 15.w,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 2.0),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 16,
                          ),
                          onRatingUpdate: (value) {},
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (await confirm(
                                navigatorKeyGlobal.currentContext!,
                                content: Text(
                                    "Are you sure you want to switch to ${provider.currentUser!.selectedUserType == '2' ? USER_TITLE : 'Passenger'}"))) {
                              DashboardProvider driverProvider = sl();
                              onBackPress = () {
                                DashboardProvider dashboardProvider = sl();
                                dashboardProvider.switchRole();
                              };
                              driverProvider.switchRole();
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(100)),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(provider.currentUser!.selectedUserType ==
                                        '2'
                                    ? 'Switch to $USER_TITLE'
                                    : "Switch to Passenger"),
                                SizedBox(
                                  width: 10.w,
                                ),
                                SizedBox(
                                  height: 30,
                                  child: FlutterSwitch(
                                    inactiveColor:
                                        Theme.of(context).primaryColor,
                                    width: 40.0,
                                    height: 18.0,
                                    valueFontSize: 11.0,
                                    toggleSize: 13.0,
                                    value: false,
                                    onToggle: (val) {
                                      Logger().v(val);
                                      DashboardProvider driverProvider = sl();
                                      driverProvider.switchRole();
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
          SizedBox(
            height: 20.h,
          ),
          _getDrawerButton(
              onTap: () async {
                final result = await LocationApi.canLocate();
                if (!result) {
                  Navigator.of(context).pop();
                  return;
                }
                if (userCurrentLocation == null) {
                  final position = await LocationApi.determinePosition();
                  print(position.toJson());
                  userCurrentLocation = position;
                }
                print(userCurrentLocation!.toJson());
                if (context
                        .read<AuthProvider>()
                        .currentUser!
                        .selectedUserType ==
                    '1') {
                  goToNext(PageConfigs.driverSchedulesScreenPageConfig);
                } else {
                  goToNext(PageConfigs.passengerSchedulesScreenPageConfig);
                }
              },
              title: 'Schedules',
              icon: AppAssets.schedulesMenuSvg),
          _getDrawerButton(
              onTap: () {
                goToNext(PageConfigs.notificationPageConfig);
              },
              title: 'Notifications',
              icon: AppAssets.notifications2Svg),
          if (context.read<AuthProvider>().currentUser!.selectedUserType == '1')
            _getDrawerButton(
                onTap: () {
                  goToNext(PageConfigs.vehicleManagmentPageConfig);
                },
                title: 'Vehicles',
                icon: AppAssets.vehicleMenuPng),
          _getDrawerButton(
              onTap: () {
                goToNext(PageConfigs.inviteFriendsPageConfig);
              },
              title: 'Invite Friends',
              icon: AppAssets.inviteFrindsSvg),
          _getDrawerButton(
              onTap: () {
                goToNext(PageConfigs.profileScreenPageConfig);
              },
              title: 'Settings',
              icon: AppAssets.menuSettingPng),
          _getDrawerButton(
              onTap: () {
                AuthProvider authProvider = sl();
                if (authProvider.currentUser!.selectedUserType == '1') {
                  goToNext(PageConfigs.driverHistoryPagePageConfig);
                } else {
                  goToNext(PageConfigs.historyPageConfig);
                }
              },
              title: 'History',
              icon: AppAssets.historyPng),
          if (true)
            _getDrawerButton(
                onTap: () {
                  goToNext(PageConfigs.userWalletPageConfig);
                },
                title: 'Wallet',
                icon: AppAssets.walletIconPng),
          _getDrawerButton(
              onTap: () async {
                if (await confirm(
                  navigatorKeyGlobal.currentContext!,
                  // title: const Text("Confirmation"),
                  content: const Text("Are you sure you want to logout?"),
                )) {
                  AuthProvider _authProvider = sl();
                  _authProvider.logout();
                }
              },
              title: 'Logout',
              icon: AppAssets.logoutSvg),
        ],
      ),
    );
  }

  goToNext(PageConfiguration pageConfigs) {
    AppState appState = GetIt.I.get<AppState>();
    appState.goToNext(pageConfigs);

  }

  Widget _getDrawerButton(
      {required Function() onTap,
      required String title,
      required String icon}) {
    return ListTile(
      onTap: onTap,
      leading: icon.split('.').last == 'png'
          ? Image.asset(
              icon,
              width: 33.sp,
            )
          : SvgPicture.asset(
              icon,
              // color: Colors.black45,
            ),
      title: Text(title),
    );
  }
}
