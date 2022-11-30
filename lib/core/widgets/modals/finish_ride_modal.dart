import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../features/drawer_wrapper/schedules_driver/presentation/providers/schedule_provider.dart';
import '../../../features/ride/presentation/providers/driver_ride_provider.dart';
import '../../utils/constants/app_assets.dart';
import '../../utils/globals/globals.dart';
import '../custom/continue_button.dart';

class FinishRideModal {
  final BuildContext context;
  FinishRideModal(
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
              padding: EdgeInsets.all(12.sp),
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
                  Text(
                    "Finish Ride?",
                    style:
                        TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Do you want to finish current ride now?",
                    style: TextStyle(fontSize: 14.sp, color: Colors.black54),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  SizedBox(
                    height: 35.h,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.w),
                      child: ContinueButton(
                          text: 'Finish',
                          onPressed: () {
                            DriverRideProvider driverRideProvider=sl();
                            ScheduleProvider provider = sl();
                            provider.finishRideDriver(
                                driverRideProvider.currentRide.routeId.id,fromModal: true);
                          }),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                ],
              ),
            ),
          );
        });
  }
}
