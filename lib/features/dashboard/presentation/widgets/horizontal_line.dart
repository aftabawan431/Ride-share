import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class HorizontalLine extends StatelessWidget {
  const HorizontalLine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 7,
      width: 60.w,
      decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(20)
      ),
    );
  }
}
