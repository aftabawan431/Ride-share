import 'package:flutter/material.dart';
import 'package:flutter_rideshare/features/authentication/auth_wrapper/presentation/providers/auth_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../router/app_state.dart';
import '../utils/globals/globals.dart';

class CustomColumnAppBar extends StatelessWidget {
  const CustomColumnAppBar(
      {Key? key,
      this.showBackButton = true,
      required this.title,
      this.showActionButton = false,
      this.actionOnTap,
      this.actionIcon,
      this.leadingTap})
      : super(key: key);
  final bool showBackButton;
  final String title;
  final bool showActionButton;
  final Function()? actionOnTap;
  final Function()? leadingTap;
  final IconData? actionIcon;


  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 13.h),
        color: Theme.of(context).primaryColor,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.min, children: [
          Row(
            children: [
              if (showBackButton)
                GestureDetector(
                  onTap:leadingTap?? () {
                    AppState appState = sl();
                    appState.moveToBackScreen();
                  },
                  child: Icon(
                    Icons.keyboard_arrow_left_sharp,
                    color: Colors.white,
                    size: 35.r,
                  ),
                ),
              SizedBox(
                width: 15.w,
              ),
              Expanded(
                child: Center(
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 22.sp, color: Colors.white),
                  ),
                ),
              ),
              if (showActionButton && actionIcon != null)
                GestureDetector(
                  onTap: actionOnTap,
                  child: CircleAvatar(
                    radius: 20.r,
                    backgroundColor: Colors.white.withOpacity(.3),
                    child: Icon(
                      actionIcon!,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                  ),
                ),
            ],
          ),
        ]));
  }
}
