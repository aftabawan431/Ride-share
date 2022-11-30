import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class SelectedSeatWidget extends StatelessWidget {
   SelectedSeatWidget({Key? key,
  required this.value,
    required this.selected

  }) : super(key: key);
  bool selected;
  int value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 40,
      margin: EdgeInsets.symmetric(horizontal: 5.w,vertical: 5.h),



      decoration: BoxDecoration(
          color: selected?Theme.of(context).primaryColor:Colors.white,
          borderRadius: BorderRadius.circular(4),
          boxShadow: const[
            BoxShadow(
                spreadRadius: 2,
                blurRadius: 2,
                color: Colors.black12
            ),
          ]

      ),
      child: Center(child: Text(value.toString(),
        style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: selected?Colors.white:Colors.black
        ),)),
    );
  }
}
