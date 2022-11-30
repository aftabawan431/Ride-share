import 'package:flutter/material.dart';
import '../../../../../core/router/app_state.dart';
import '../../../../../core/router/models/page_config.dart';
import '../../../../../core/utils/enums/page_state_enum.dart';
import '../providers/auth_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../../core/utils/firebase/push_notification_service.dart';
import '../../../../../core/utils/globals/globals.dart';

class LocationPermissionScreen extends StatelessWidget {
  const LocationPermissionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 18.w),
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 15.h),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.r),
                color: Colors.white,
                boxShadow:const [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 1,
                      spreadRadius: 1,
                      offset: Offset(1, 1))
                ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Permission Required",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Text(
                  "Rahper collects location data to enable passengers to track ${USER_TITLE.toLowerCase()}'s location when app is closed or not in use.",
                  style: TextStyle(
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(
                  height: 8.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _customButton(context, 'DISAGREE', () async {
                      AppState appState = sl();
                      await PushNotifcationService.joinRooms();

                      await const FlutterSecureStorage().delete(key: 'user');
                      appState.goToNext(PageConfigs.selectUserPageConfig,
                          pageState: PageState.replaceAll);
                    }),
                    SizedBox(
                      width: 5.w,
                    ),
                    _customButton(context, 'AGREE', () async {
                      AuthProvider authProvider = sl();
                      await authProvider.updateUserOnDisk();
                      AppState appState = sl();
                      appState.goToNext(PageConfigs.dashboardPageConfig,
                          pageState: PageState.replaceAll);
                    }),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _customButton(BuildContext context, String text, Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 100.w,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
        decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(100),
            color: Colors.transparent),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                fontSize: 14.sp, color: Theme.of(context).primaryColor),
          ),
        ),
      ),
    );
  }
}
