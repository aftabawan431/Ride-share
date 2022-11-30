import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_rideshare/core/utils/globals/snake_bar.dart';
import 'package:flutter_rideshare/core/widgets/custom/continue_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class CancelReasonBottomSheet {
  final BuildContext context;

  CancelReasonBottomSheet(
      {required this.context, required this.reasons, required this.onPressed});
  List<String> reasons = [];
  Function(String) onPressed;

  String selectedReason = '';
  Future show() async {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
      builder: (BuildContext bottomSheetContext) {
        return StatefulBuilder(builder: (context, setState) {
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
                    height: 10.h,
                  ),
                  Text(
                    "Reason for cancelling ride",
                    style:
                        TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w400),
                  ),
                  ...reasons.map((e) => Row(
                        children: [
                          Checkbox(
                              value: selectedReason == e,
                              onChanged: (value) {
                                setState(() {
                                  selectedReason = e;
                                });
                              }),
                          Expanded(child: Text(e))
                        ],
                      )),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: ContinueButton(
                        text: 'Cancel',
                        onPressed: (){
                          if(selectedReason.isEmpty){
                             ShowToast.show('Please select a reason');
                             return;
                          }

                          onPressed(selectedReason);
                        },
                        backgroundColor: Colors.red,
                      )),
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
