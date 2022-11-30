import 'package:flutter/material.dart';
import 'package:flutter_rideshare/features/ride/presentation/providers/passenger_ride_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/constants/app_assets.dart';
import '../../utils/globals/globals.dart';

class ConfirmationDialog {
  PassengerRideProvider provider = sl();
  final BuildContext context;
  ConfirmationDialog(
    this.context, {
    required this.leftTap,
    required this.rightTap,
    required this.leftTitle,
    required this.rightTitle,
    required this.details,
    required this.title,
  });

  Function() leftTap;
  Function() rightTap;
  String leftTitle;
  String rightTitle;
  String title;
  String details;

  show() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
              padding: EdgeInsets.only(top: 12.sp),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                            height: 80.h,
                            child: SvgPicture.asset(
                              AppAssets.logoSvg,
                              color: Theme.of(context).primaryColor,
                            )),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          title,
                          style: TextStyle(
                              fontSize: 20.sp, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          details,
                          style:
                              TextStyle(fontSize: 14.sp, color: Colors.black54),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  const Divider(
                    color: Colors.black12,
                    height: 1,
                    thickness: 1,
                  ),
                  Row(
                    children: [
                      if (leftTitle.isNotEmpty)
                        Expanded(
                            child: InkWell(
                          onTap: leftTap,
                          child:  Center(
                              child: Text(
                            leftTitle,
                            style: TextStyle(color: Colors.black26),
                          )),
                        )),
                      if (leftTitle.isNotEmpty && rightTitle.isNotEmpty)
                        Container(
                          height: 50,
                          width: 1,
                          color: Colors.black12,
                        ),
                      if (rightTitle.isNotEmpty)
                        Expanded(
                            child: InkWell(
                          onTap: rightTap,
                          child: Center(
                              child: Text(
                            rightTitle,
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          )),
                        )),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
