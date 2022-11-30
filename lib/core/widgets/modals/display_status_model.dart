import 'package:flutter/material.dart';
import '../../utils/constants/app_assets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DisplayStatusModel {
  final BuildContext context;
  final String icon;
  final String title;
  final String content;
  Function()? onTap;
  DisplayStatusModel(this.context,
      {required this.icon, required this.title, required this.content,this.onTap});

  show() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  icon.split('.').last == 'png'
                      ? Image.asset(icon, width: 80.sp, height: 80.sp,)
                      : SvgPicture.asset(
                          icon,
                          width: 80.sp,
                          height: 80.sp,
                        ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    title,
                    style:
                        TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                      ),
                      child: Text(
                        content,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black26),
                      )),
                  SizedBox(
                    height: 30.h,
                  ),
                  const Divider(
                    color: Colors.black12,
                    height: 1,
                    thickness: 1,
                  ),
                  Row(
                    children: [
                      if (false)
                        Expanded(
                            child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const Center(
                              child: Text(
                            "Cancel",
                            style: TextStyle(color: Colors.black26),
                          )),
                        )),
                      Container(
                        height: 50,
                        width: 1,
                        color: Colors.black12,
                      ),
                      Expanded(
                          child: InkWell(
                        onTap:onTap?? () {
                          Navigator.of(context).pop();
                        },
                        child: Center(
                            child: Text(
                          "Done",
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        )),
                      )),
                    ],
                  )
                ],
              ),
            ),
          );

        });
  }


}
