import 'package:flutter/material.dart';
import 'package:flutter_rideshare/features/drawer_wrapper/history/model/get_driver_history_response_model.dart';
import 'package:flutter_rideshare/features/drawer_wrapper/history/presentation/widgets/driver_history_passenger_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/services/date_formating.dart';
import '../../../../../core/widgets/custom/dotted_line_painter.dart';

class DriverHistoryWidget extends StatefulWidget {
  DriverHistoryModel model;
  DriverHistoryWidget({Key? key, required this.model}) : super(key: key);

  @override
  State<DriverHistoryWidget> createState() => _DriverHistoryWidgetState();
}

class _DriverHistoryWidgetState extends State<DriverHistoryWidget> {
  bool expanded=false;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: EdgeInsets.only(bottom: 15.h),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                  spreadRadius: 2,
                  blurRadius: 2,
                  color: Colors.black12,
                  offset: Offset(0, 0))
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 7.h,
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Text(DateFormatService.formattedDate(widget.model.date))),
            Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                child: Row(
                  children: [
                    SizedBox(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            Icons.radio_button_checked,
                            color: Theme.of(context).primaryColor,
                          ),
                          CustomPaint(
                              size: const Size(1, 20),
                              painter: DashedLineVerticalPainter()),
                          Icon(Icons.location_on,
                              color: Theme.of(context).errorColor)
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.model.startPoint.placeName,
                            style: TextStyle(fontSize: 16.sp),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Text(
                            widget.model.endPoint.placeName,
                            style: TextStyle(fontSize: 16.sp),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                    ),
                    if(widget.model.history.isNotEmpty)
                    IconButton(onPressed: (){
                      setState(() {
                        expanded=!expanded;
                      });
                    }, icon: Icon(expanded?Icons.keyboard_arrow_up: Icons.keyboard_arrow_down)),
                  ],
                )),
            SizedBox(
              height: 5.h,
            ),
            if(expanded)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...widget.model.history.map((e) => DriverHistoryPassengerWidget(model: e)).toList()
              ],
            )
          ],
        ),
      ),
    );
  }
}
