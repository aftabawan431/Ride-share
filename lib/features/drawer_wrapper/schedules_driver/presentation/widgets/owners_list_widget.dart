import 'package:flutter/material.dart';
import 'package:flutter_rideshare/features/drawer_wrapper/schedules_driver/data/models/requests_length_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../core/utils/enums/ScheduleListType.dart';
import '../../data/models/get_drivers_list_response_model.dart';
import '../providers/schedule_provider.dart';
import 'driver_widget.dart';

class OwnersListWidget extends StatelessWidget {
  OwnersListWidget({Key? key, required this.type,required this.list}) : super(key: key);
  List<NearestDriver> list;

  ScheduleListType type;

  @override
  Widget build(BuildContext context) {


    if (list.isEmpty) {
      return const Center(child: Text("No requests"));
    }


    return Container(
        margin: EdgeInsets.symmetric(horizontal: 5.w),
        child: RefreshIndicator(
            onRefresh: () async {
              return await Future.delayed(const Duration(milliseconds: 2000));
            },
            child: SingleChildScrollView(
                child: Column(
                    children: list
                        .map((e) => DriverWidget(
                      driver: e,
                      type: type,
                    ))
                        .toList()))));

    return Consumer<ScheduleProvider>(builder: (_, provider, ch) {


      // provider.requestsLength.value = RequestsLengthModel(
      //     requests: requestsList.length,
      //     confirmed: confirmList.length,
      //     matched: matchedList.length);


    });
  }
}
