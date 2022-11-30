import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../custom/continue_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDatetimePIcker {
  final BuildContext context;

  CupertinoDatePickerMode mode;
  bool adulDate;
  DateTime? maxDate;
  DateTime? minDate;
  DateTime? initialDate;
  CustomDatetimePIcker(
      {required this.context,
      this.mode = CupertinoDatePickerMode.dateAndTime,
      this.minDate,
      this.maxDate,
      this.initialDate,
      this.adulDate = false});

  Future show() async {
    DateTime dateTime = initialDate??DateTime.now();
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
      builder: (BuildContext bottomSheetContext) {
        return Builder(builder: (context) {
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
                    child: CupertinoDatePicker(
                      initialDateTime: initialDate ?? DateTime.now(),
                      mode: mode,
                      maximumDate: maxDate,
                      minimumDate:mode==CupertinoDatePickerMode.time?DateTime.now().subtract(const Duration(days: 2)): minDate,
                      onDateTimeChanged: (DateTime date) {
                        dateTime = date;
                        print(date);
                      },
                    ),
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
