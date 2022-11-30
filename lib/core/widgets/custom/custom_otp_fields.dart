import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class CustomOtpFields extends StatelessWidget {
   CustomOtpFields(
      {this.controller,
      this.errorStream,
      this.onCompleted,

      required this.onChanged,
         this.verified=false,
      this.beforeTextPaste,
        this.readOnly=false,
      Key? key})
      : super(key: key);

  bool verified;

  final TextEditingController? controller;
  final StreamController<ErrorAnimationType>? errorStream;
  final Function(String)? onCompleted;
  final Function(String) onChanged;
  final bool Function(String?)? beforeTextPaste;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(

      readOnly: readOnly,
      appContext: context,
      pastedTextStyle: TextStyle(
        color: Theme.of(context).primaryColor,
        fontWeight: FontWeight.bold,
      ),
      length: 4,
      obscureText: false,
      obscuringCharacter: '*',
      animationType: AnimationType.fade,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.underline,
        borderRadius: BorderRadius.circular(100.r),
        fieldHeight: 50.w,
        fieldWidth: 60.w,
        borderWidth: 5,

        activeFillColor: Theme.of(context).scaffoldBackgroundColor,
        activeColor:verified?Theme.of(context).primaryColor: Colors.black12,
        inactiveFillColor: verified?Theme.of(context).primaryColor:Colors.black12,
        inactiveColor: Colors.grey.withOpacity(0.7),
        errorBorderColor: Colors.redAccent,
        selectedFillColor: verified?Theme.of(context).primaryColor:Colors.black12,
        selectedColor: Colors.grey.withOpacity(0.7),
      ),
      cursorColor: Colors.black,
      animationDuration: const Duration(milliseconds: 300),
      textStyle: const TextStyle(fontSize: 20, height: 1.6),
      enableActiveFill: false,
      errorAnimationController: errorStream,
      controller: controller,
      keyboardType: TextInputType.number,
      autoDisposeControllers: false,
      // boxShadows: const [
      //   BoxShadow(
      //     offset: Offset(0, 2),
      //     color: Colors.black12,
      //     blurRadius: 10,
      //   )
      // ],
      onCompleted: onCompleted,
      onChanged: onChanged,
      beforeTextPaste: beforeTextPaste,
    );
  }
}
