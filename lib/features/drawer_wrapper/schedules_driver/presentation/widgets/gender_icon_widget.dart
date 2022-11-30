import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class GenderIconWidget extends StatelessWidget {
  const GenderIconWidget({Key? key,required this.gender}) : super(key: key);
  final String gender;

  @override
  Widget build(BuildContext context) {
    return gender == 'male'
        ? const Icon(Icons.boy)
        : gender == 'female'
        ? const Icon(Icons.girl)
        : Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
            width: 12.sp,
            child: const Icon(Icons.boy)),
        // Text("|"),
        SizedBox(
            width: 12.sp,
            child: const Icon(Icons.girl))
      ],
    );
  }
}
