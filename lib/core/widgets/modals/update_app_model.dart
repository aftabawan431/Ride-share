import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rideshare/core/utils/theme/app_theme.dart';
import 'package:flutter_rideshare/core/widgets/custom/continue_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/services/package_info_service.dart';

class UpdateAppModel {
  final BuildContext context;
  UpdateAppModel(
    this.context,
  );

  show() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
              padding: EdgeInsets.all(12.sp),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Rahper',
                    style: TextStyle(
                        fontSize: 25.sp,
                        color: AppTheme.appTheme.primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    "Please update the app to the latest version",
                    style: TextStyle(color: Colors.black54, fontSize: 16.sp),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      width: 120.w,
                      height: 40.h,
                      child: ContinueButton(
                        text: 'Update',
                        onPressed: () async {
                          final info = await PackageInfoService().get();

                          if (Platform.isAndroid) {
                            final url = Uri.parse(
                                'https://play.google.com/store/apps/details?id=${info.packageName}&hl=en&gl=US');
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url,
                                  mode: LaunchMode.externalApplication);
                            } else {}
                          } else if (Platform.isIOS) {
                            final url = Uri.parse(
                                'https://apps.apple.com/app/id${info.packageName}');
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url,
                                  mode: LaunchMode.externalApplication);
                            } else {}
                          }
                        },
                        fontSize: 15.sp,
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
