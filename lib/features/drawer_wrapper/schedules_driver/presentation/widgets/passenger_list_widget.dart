import 'package:flutter/material.dart';
import 'package:flutter_rideshare/features/drawer_wrapper/schedules_driver/data/models/requests_length_model.dart';
import 'package:flutter_rideshare/features/drawer_wrapper/schedules_driver/presentation/widgets/request_passenger_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../../core/utils/enums/ScheduleListType.dart';
import '../../data/models/get_requested_passenger_response_model.dart';
import '../providers/schedule_provider.dart';

class PassengersListWidget extends StatelessWidget {
  PassengersListWidget({Key? key, required this.type, required this.list})
      : super(key: key);

  ScheduleListType type;
  List<RequestedPassengerRequest> list;

  @override
  Widget build(BuildContext context) {
    return Consumer<ScheduleProvider>(builder: (_, provider, ch) {


      if (list.isEmpty) {
        return const Center(child: Text("No requests found"));
      }

      return Container(
          margin: EdgeInsets.symmetric(horizontal: 5.w),
          child: RefreshIndicator(
              onRefresh: () async {
                return await Future.delayed(const Duration(milliseconds: 2000));
              },
              child: SingleChildScrollView(
                  child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Column(
                    children: list
                        .map((e) => RequestedPassengerWidget(
                            passenger: e, type: type))
                        .toList()),
              ))));
    });
  }
}
