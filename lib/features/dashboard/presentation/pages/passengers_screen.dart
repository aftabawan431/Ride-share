import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/passenger_widget.dart';

class PassengerScreen extends StatelessWidget {
  const PassengerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const PassengerScreenContent();
  }
}

class PassengerScreenContent extends StatelessWidget {
  const PassengerScreenContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
                height: 230.h,
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Theme.of(context).primaryColor,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 18.w, vertical: 20.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.keyboard_arrow_left_sharp,
                          color: Colors.white,
                          size: 40.r,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          "Passengers",
                          style:
                              TextStyle(fontSize: 30.sp, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                )),
            Positioned(
              top: 230.h - 100.h,
              left: 0,
              right: 0,
              bottom: 10,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 18.w),
                child: SingleChildScrollView(
                  child: Column(
                    children: const[
                      PassengerWideget(),
                      PassengerWideget(),
                      PassengerWideget(),

                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
