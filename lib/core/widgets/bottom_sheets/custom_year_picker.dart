import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../custom/continue_button.dart';

class CustomYearPicker {
  final BuildContext context;

  DateTime firstDate;
  DateTime lastDate;
  CustomYearPicker({
    required this.context,
    required this.firstDate,
    required this.lastDate,
  });

  Future show() async {
    DateTime dateTime = DateTime.now();
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
      builder: (BuildContext bottomSheetContext) {
        return StatefulBuilder(builder: (context,setState) {
          return Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.r)),
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  left: 20.w,
                  right: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 200.h,
                    child: YearPicker(
                        firstDate: firstDate,
                        lastDate: lastDate,
                        selectedDate: dateTime,
                        onChanged: (value) {
                          setState((){
                            dateTime = value;

                          });
                        }),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  ContinueButton(
                      text: 'Done',
                      onPressed: () {
                        Navigator.of(context).pop(dateTime);
                      }),
                  SizedBox(
                    height: 10.h,
                  )
                ],
              ));
        });
      },
    ).then((value) {
      if (value != null) {
        return value;
      }
    });
  }
}
