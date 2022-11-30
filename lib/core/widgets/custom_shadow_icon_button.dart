import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomShadowIconButton extends StatelessWidget {
  CustomShadowIconButton(
      {Key? key, required this.onTap, this.icon, required this.iconSize})
      : super(key: key);

  final Function() onTap;
  IconData? icon;
  double iconSize;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Icon(
          icon,
          color: Theme.of(context).primaryColor,
          size: 30.sp,
        ),
      ),
    );
  }
}
