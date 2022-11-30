import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../providers/driver_dashboard_provider.dart';

class LevrageKmWidget extends StatefulWidget {
  const LevrageKmWidget({Key? key}) : super(key: key);

  @override
  State<LevrageKmWidget> createState() => _LevrageKmWidgetState();
}

class _LevrageKmWidgetState extends State<LevrageKmWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(builder: (contex, provider, ch) {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 10.h,
            ),
            Text(
              'How far you are willing to deviate from your route?'
              ,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () {
                      if (provider.kmLeverage > 1) {
                        provider.subtractKmLeverage();
                      }
                    },
                    icon: const Icon(Icons.remove)),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: const[
                        BoxShadow(
                            spreadRadius: 1.5,
                            blurRadius: 1.5,
                            offset: Offset(1, 2),
                            color: Colors.black12)
                      ]),
                  child: Text(
                    "${provider.kmLeverage}km",
                    style: TextStyle(
                        fontSize: 22.sp, color: Theme.of(context).primaryColor),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      if (provider.kmLeverage < 5) provider.addKmLeverage();
                    },
                    icon: const Icon(Icons.add)),
              ],
            ),
          ],
        ),
      );
    });
  }
}
