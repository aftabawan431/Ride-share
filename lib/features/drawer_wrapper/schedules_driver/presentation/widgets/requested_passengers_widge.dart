import 'package:flutter/material.dart';
import 'package:flutter_rideshare/core/utils/theme/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RequestsTabWidget extends StatelessWidget {
  const RequestsTabWidget({Key? key, required this.title, this.length})
      : super(key: key);
  final String title;
  final int? length;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [

        Text(title),
        if (length != null&&length!>0)
          Positioned(
            top: -10,
            right: -8,
            child: CircleAvatar(
              radius: 7.r,
              backgroundColor: Colors.red,
              child: Center(
                child: Text(
                  length.toString(),
                  style: TextStyle(fontSize: 8.sp, color: Colors.white),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
