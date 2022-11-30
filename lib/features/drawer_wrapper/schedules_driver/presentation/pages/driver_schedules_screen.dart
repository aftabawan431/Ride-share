import 'package:flutter/material.dart';
import 'package:flutter_rideshare/core/widgets/back_aerro_button.dart';
import '../../../../../core/router/app_state.dart';
import '../../../../../core/utils/globals/globals.dart';
import '../../../../ride/presentation/providers/driver_ride_provider.dart';
// import 'package:flutter_rideshare/features/dashboard/presentation/widgets/passenger_schdule_ui.dart';
// import 'package:flutter_rideshare/features/drawer_wrapper/history/presentation/widgets/history_widget.dart';
// import 'package:flutter_rideshare/features/drawer_wrapper/schedules_driver/presentation/widgets/passenger_schdule_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../providers/schedule_provider.dart';
import '../widgets/schedules_list.dart';

class DriverSchedulesScreen extends StatelessWidget {
  DriverSchedulesScreen({Key? key}) : super(key: key);

  ScheduleProvider scheduleProvider = sl();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: scheduleProvider, child: const SchedulesScreenContent());
  }
}


class SchedulesScreenContent extends StatefulWidget {
  const SchedulesScreenContent({Key? key}) : super(key: key);

  @override
  State<SchedulesScreenContent> createState() => _SchedulesScreenContentState();
}

class _SchedulesScreenContentState extends State<SchedulesScreenContent> {
  @override
  void initState() {
    super.initState();
    context.read<ScheduleProvider>().getDriverSchedules();
    DriverRideProvider driverRideProvider = sl();
    driverRideProvider.passengerRideCancellationListener();
    ScheduleProvider scheduleProvider = sl();
    scheduleProvider.refreshDriverScheduleListner();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    ScheduleProvider scheduleProvider = sl();
    scheduleProvider.refreshDriverScheduleListnerOff();
    // Navigator.of(navigatorKeyGlobal.currentContext!).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Scaffold(
        body: ValueListenableBuilder<bool>(
            valueListenable:
                context.read<ScheduleProvider>().getSchedulesLoading,
            builder: (_, loading, __) {
              return loading
                  ? const Center(
                      child: CircularProgressIndicator.adaptive(),
                    )
                  : SafeArea(
                      child: Stack(
                        children: [
                          Positioned(
                              left: 0,
                              right: 0,
                              top: 0,
                              height: 180.h,
                              child:
                                  const CustomStackAppBar(title: 'Schedules')),
                          Positioned(
                            top: 180.h - 100.h,
                            left: 0,
                            right: 0,
                            bottom: 10,
                            child: Consumer<ScheduleProvider>(
                                builder: (_, provider, ch) {
                              if (provider
                                  .getSchedulesResponseModel!.data.isEmpty) {
                                return Container(
                                  height: 200.h,
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 30.w),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child:
                                      const Center(child: Text("No schedules")),
                                );
                              }

                              return Container(
                                margin: EdgeInsets.symmetric(horizontal: 18.w),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      ListView.builder(
                                        shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          itemCount: provider
                                              .getSchedulesResponseModel!.data.length,
                                          itemBuilder: (context, index) {
                                            return DriverScheduleListWidget(
                                              schedule: provider
                                                  .getSchedulesResponseModel!
                                                  .data[index],
                                            );
                                          }),
                                      if(provider.scheduleReadMore)
                                        provider.readMoreloading?Center(child: CircularProgressIndicator(),):
                                        TextButton(onPressed: (){
                                          provider.getDriverSchedules(isFirstTime: false);
                                        }, child: Text("Read more"))
                                    ],
                                  ),
                                ),
                              );
                            }),
                          )
                        ],
                      ),
                    );
            }),
      ),
    );
  }
}
