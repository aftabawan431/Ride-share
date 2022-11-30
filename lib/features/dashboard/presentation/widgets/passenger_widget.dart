import 'package:flutter/material.dart';
import '../../../../core/utils/constants/app_assets.dart';
import '../../../../core/widgets/modals/display_status_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class  PassengerWideget extends StatelessWidget {
  const PassengerWideget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        margin: EdgeInsets.only(bottom: 15.h),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow:const [
               BoxShadow(
                  spreadRadius: 2,
                  blurRadius: 2,
                  color: Colors.black12,
                  offset: Offset(0, 0))
            ]),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 26.r,
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Ahmad Ali",
                          style: TextStyle(
                              fontSize: 18.sp, fontWeight: FontWeight.w700),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              AppAssets.star1Svg,
                              width: 18,
                              color: Colors.orangeAccent,
                            ),
                            SizedBox(
                              width: 4.w,
                            ),
                            Text(
                              "4.9",
                              style: TextStyle(
                                  color: Theme.of(context).canvasColor,
                                  fontSize: 16.sp),
                            )
                          ],
                        )
                      ],
                    ),
                    Expanded(child: Container()),
                    SvgPicture.asset(AppAssets.rejectSvg),
                    SizedBox(
                      width: 10.w,
                    ),
                    GestureDetector(

                        onTap: (){

                        },
                        child: SvgPicture.asset(AppAssets.acceptSvg)),
                  ],
                )),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 18.h),
              decoration: const BoxDecoration(
                  border:
                      Border(top:  BorderSide(color: Colors.black12, width: 1))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SvgPicture.asset(AppAssets.carSvg),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "DISTANCE",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).canvasColor),
                      ),
                      const Text(
                        "0.2 km",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Tune",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).canvasColor),
                      ),
                      const Text(
                        "2 min",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "PRICE",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).canvasColor),
                      ),
                      const Text(
                        "200 pkr",
                        style:  TextStyle(fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
