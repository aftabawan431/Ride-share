import 'package:flutter/material.dart';
import 'package:flutter_rideshare/core/widgets/back_aerro_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../core/router/app_state.dart';
import '../../../../../core/utils/constants/socket_point.dart';
import '../../../../../core/utils/globals/globals.dart';
import '../../../../../core/utils/sockets/sockets.dart';
import '../providers/schedule_provider.dart';
import '../widgets/passenger_schdule_widget.dart';

class PassengerSchedulesScreen extends StatelessWidget {
  PassengerSchedulesScreen({Key? key}) : super(key: key);

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
    ScheduleProvider scheduleProvider = sl();
    scheduleProvider.getPassengerSchedules();
    scheduleProvider.driverActionsListener();
    scheduleProvider.refreshSchedulesSocketOn();
  }

  @override
  void dispose() {
    super.dispose();

    SocketService.off("refreshSchedule");
    SocketService.off(SocketPoint.refreshEverything);
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
              if (loading) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              } else {
                return SafeArea(
                  child: Stack(
                    children: [
                      Positioned(
                          left: 0,
                          right: 0,
                          top: 0,
                          height: 180.h,
                          child: const CustomStackAppBar(title: 'Schedules')),
                      Positioned(
                        top: 180.h - 100.h,
                        left: 0,
                        right: 0,
                        bottom: 10,
                        child: Consumer<ScheduleProvider>(
                            builder: (_, provider, ch) {
                          if (provider.getPassengerSchdulesResponseModel!.data
                              .isEmpty) {
                            return Container(
                              height: 200.h,
                              margin: EdgeInsets.symmetric(horizontal: 30.w),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: const Center(
                                  child: Text("No schedules found")),
                            );
                          }
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 18.w),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  ListView.builder(
                                    shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: provider
                                          .getPassengerSchdulesResponseModel!
                                          .data
                                          .length,
                                      itemBuilder: (context, index) {
                                        return PassengerScheduleListWidget(
                                          schedule: provider
                                              .getPassengerSchdulesResponseModel!
                                              .data[index],
                                        );
                                      }),
                                  if(provider.scheduleReadMore)
                                    provider.readMoreloading?const Center(child: CircularProgressIndicator(),):
                                    TextButton(onPressed: (){
                                      provider.getPassengerSchedules(isFirstTime: false);
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
              }
            }),
      ),
    );
  }

}
