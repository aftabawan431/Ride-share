import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../router/app_state.dart';
import '../utils/globals/globals.dart';

class BackAerroButton extends StatelessWidget {
 const  BackAerroButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        AppState appState=sl();
        appState.moveToBackScreen();
      },
      child: Icon(
        Icons.keyboard_arrow_left_sharp,
        color: Colors.white,
        size: 40.r,
      ),
    );
  }
}


class CustomStackAppBar extends StatelessWidget {
  const CustomStackAppBar({Key? key,required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: 18.w, vertical: 20.h),
      color: Theme.of(context).primaryColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              BackAerroButton(),
              Expanded(
                child: Center(
                  child: Text(
                    title,
                    style: TextStyle(
                        fontSize: 30.sp,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }
}
