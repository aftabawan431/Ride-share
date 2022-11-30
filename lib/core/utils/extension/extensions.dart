import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension ScaffoldHelper on BuildContext? {
  void show({required String message, Color backgroundColor = Colors.grey}) {
    if (this == null) {
      return;
    }

    // Fluttertoast.showToast(
    //   msg: message,
    //   toastLength: Toast.LENGTH_LONG,
    //   gravity: ToastGravity.SNACKBAR,
    //   timeInSecForIosWeb: 1,
    //   backgroundColor: Colors.redAccent,
    //   textColor: Colors.white,
    //   fontSize: 16.sp,
    // );

    ScaffoldMessenger.maybeOf(this!)
      ?..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12.sp),
          ),
          backgroundColor: backgroundColor,
          duration: const Duration(seconds: 2),
          // shape: const StadiumBorder(),
          // margin: const EdgeInsets.only(bottom: 100, left: 40, right: 40),
          // padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 16.h),
          behavior: SnackBarBehavior.fixed,
        ),
      );
  }
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
  String ext() => this.split('.').last;
  String formatPhone(){
    String sub=this.replaceAll('-', "").substring(1,11);
    return "92"+sub;
  }

}

extension GetGenderText on int {
  String getGender() {
    if (this == 0) {
      return 'Male';
    } else if (this == 1) {
      return 'Female';
    } else {
      return 'Prefer not to say';
    }
  }
}
