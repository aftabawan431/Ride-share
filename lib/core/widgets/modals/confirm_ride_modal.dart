import 'package:flutter/material.dart';
import 'package:flutter_rideshare/core/utils/theme/app_theme.dart';
import 'package:flutter_rideshare/features/ride/presentation/providers/passenger_ride_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../features/drawer_wrapper/schedules_driver/presentation/providers/schedule_provider.dart';
import '../../../features/ride/presentation/providers/driver_ride_provider.dart';
import '../../utils/constants/app_assets.dart';
import '../../utils/globals/globals.dart';
import '../custom/continue_button.dart';

class ConfirmRideModal {
  PassengerRideProvider provider = sl();
  final BuildContext context;
  ConfirmRideModal(
    this.context,
  );

  show() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
              padding: EdgeInsets.only(left: 12.sp, right: 12.sp, top: 12.sp),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
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
                  if (provider.currentRide!.verifyPin != null)
                    Text(
                      "${provider.currentRide!.verifyPin}",
                      style: TextStyle(
                          fontSize: 25.sp,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.appTheme.primaryColor),
                    ),
                  Text(
                    "Confirm Ride",
                    style:
                        TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Please confirm your host has arrived. ",
                    style: TextStyle(fontSize: 14.sp, color: Colors.black54),
                  ),
                  Text(
                    "Your tentative fare will be deducted from your Zindigi wallet.",
                    style: TextStyle(fontSize: 10.sp, color: Colors.black54),
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
                      Expanded(
                          child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child:  Center(
                            child: Text(
                          "No",
                          style: TextStyle(color: Colors.red.withOpacity(.9)),
                        )),
                      )),
                      Container(
                        height: 50,
                        width: 1,
                        color: Colors.black12,
                      ),
                      Expanded(
                          child: InkWell(
                        onTap: () {
                          PassengerRideProvider passengerRideProvider = sl();
                          passengerRideProvider.confirmRide();
                          Navigator.of(context).pop();
                        },
                        child: Center(
                            child: Text(
                          "Yes",
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
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
