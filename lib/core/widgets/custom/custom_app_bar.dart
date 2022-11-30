import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

import '../../router/app_state.dart';




class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  const CustomAppBar({required this.title, this.showBackButton = true, Key? key}) : super(key: key);

  final String title;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      titleSpacing: 0.3,
      backgroundColor: Theme.of(context).primaryColor,
      toolbarHeight: 60.h,
      leading: showBackButton
          ? GestureDetector(
              onTap: () {
                GetIt.I.get<AppState>().moveToBackScreen();
              },
              child: Icon(Icons.chevron_left_rounded, color: Colors.white,size: 40.sp,)
            )
          : null,
      centerTitle: true,
      title: Padding(
        padding: EdgeInsets.only(left: showBackButton ? 0 : 20),
        child: Text(title, style: Theme.of(context).textTheme.subtitle2?.copyWith(color: Colors.white,fontSize: 22.sp)),
      ),

    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
