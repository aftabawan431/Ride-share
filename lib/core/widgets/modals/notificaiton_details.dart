import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../features/drawer_wrapper/notification/data/models/get_notifications_response_model.dart';
import '../../utils/constants/app_url.dart';
import '../../utils/extension/extensions.dart';

class NotificationDetailsModel {
  final BuildContext context;
  NotificationDetailsModel(this.context, {required this.model});
  NotificationModel model;
  show() {
    showDialog(
        context: context,
        barrierDismissible: true,
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
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white.withOpacity(.8),
                        child: Image.network(AppUrl.fileBaseUrl + model.icon),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Text(
                        model.title.toTitleCase(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Text(
                        DateFormat("yyyy-MM-dd hh:mm a")
                            .format(DateTime.parse(model.createdAt).toLocal()),
                        style: TextStyle(
                          color: Colors.black26,
                          fontSize: 9.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(model.message)
                ],
              ),
            ),
          );
        });
  }
}
