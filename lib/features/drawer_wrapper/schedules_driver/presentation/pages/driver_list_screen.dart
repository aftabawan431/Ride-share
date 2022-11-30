import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_rideshare/features/drawer_wrapper/schedules_driver/presentation/widgets/owners_list_widget.dart';
import '../../../../../core/utils/enums/ScheduleListType.dart';
import '../../../../../core/utils/sockets/sockets.dart';
import '../../../../../core/widgets/back_aerro_button.dart';
import '../../data/models/requests_length_model.dart';
import '../widgets/driver_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../../../../core/utils/constants/socket_point.dart';
import '../../../../../core/utils/globals/globals.dart';
import '../providers/schedule_provider.dart';
import '../widgets/requested_passengers_widge.dart';

// ignore: must_be_immutable
class DriverListScreen extends StatelessWidget {
  DriverListScreen({required this.id, Key? key}) : super(key: key);
  String id;

  ScheduleProvider scheduleProvider = sl();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: scheduleProvider),
        ],
        child: DriverListScreenContent(
          id: id,
        ));
  }
}

// ignore: must_be_immutable
class DriverListScreenContent extends StatefulWidget {
  String id;
  DriverListScreenContent({required this.id, Key? key}) : super(key: key);

  @override
  State<DriverListScreenContent> createState() =>
      _DriverListScreenContentState();
}

class _DriverListScreenContentState extends State<DriverListScreenContent> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ScheduleProvider scheduleProvider = sl();

    scheduleProvider.driverActionsListener();

    scheduleProvider.getDriversList(widget.id);
    // scheduleProvider.refreshDriversList();
    scheduleProvider.isInDriverListScreen = true;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    ScheduleProvider scheduleProvider = sl();
    scheduleProvider.isInDriverListScreen = false;
    if (scheduleProvider.isFromNewRideScreen) {
      scheduleProvider.driverActionsListener();
      SocketService.socket!.off(SocketPoint.refreshPassengerScheduleListner);
      SocketService.socket!.off(SocketPoint.refreshEverything);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Scaffold(
        body: ValueListenableBuilder<bool>(
            valueListenable:
                context.read<ScheduleProvider>().getDriversListLoading,
            builder: (_, loading, __) {
              if (loading) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              } else {
                return DefaultTabController(
                  length: 3,
                  child: SafeArea(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 18.w, vertical: 10.h),
                          color: Theme.of(context).primaryColor,
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const BackAerroButton(),
                                Expanded(child: Center(
                                  child: Text(
                                    "${USER_TITLE}s",
                                    style: TextStyle(
                                        fontSize: 25.sp,
                                        color: Colors.white),
                                  ),
                                )),

                                GestureDetector(
                                    onTap: () {
                                      context
                                          .read<ScheduleProvider>()
                                          .refreshDriversList();

                                      // SocketService.socket!.emit('matcheddrivers',context.read<ScheduleProvider>().getDriversListResponseModel!.data.schedule.id);
                                    },
                                    child: const Icon(
                                      Icons.refresh,
                                      color: Colors.white,
                                    ))
                              ],
                            ),
                          ),
                        ),
                        ValueListenableBuilder<RequestsLengthModel?>(
                            valueListenable:
                                context.read<ScheduleProvider>().requestsLength,
                            builder: (_, requestsLength, __) {
                              if (requestsLength == null) {
                                return TabBar(
                                    indicatorColor:
                                        Theme.of(context).primaryColor,
                                    tabs: const [
                                      Tab(
                                        child: RequestsTabWidget(
                                          title: 'Requests',
                                        ),
                                      ),
                                      Tab(
                                        child: RequestsTabWidget(
                                          title: 'Matched',
                                        ),
                                      ),
                                      Tab(
                                        child: RequestsTabWidget(
                                          title: 'Confirmed',
                                        ),
                                      ),
                                    ]);
                              } else {
                                return TabBar(
                                    indicatorColor:
                                        Theme.of(context).primaryColor,
                                    tabs: [
                                      Tab(
                                        child: RequestsTabWidget(
                                          title: 'Requests',
                                          length: requestsLength.requests,
                                        ),
                                      ),
                                      Tab(
                                        child: RequestsTabWidget(
                                          title: 'Matched',
                                          length: requestsLength.matched,
                                        ),
                                      ),
                                      Tab(
                                        child: RequestsTabWidget(
                                          title: 'Confirmed',
                                          length: requestsLength.confirmed,
                                        ),
                                      ),
                                    ]);
                              }
                            }),
                        SizedBox(
                          height: 5.h,
                        ),
                        Expanded(child: Consumer<ScheduleProvider>(
                            builder: (_, provider, ch) {
                          final confirmList = provider
                              .getDriversListResponseModel!.data.nearestDriver
                              .where((element) => element.accepted.contains(
                                  provider.getDriversListResponseModel!.data
                                      .schedule.id))
                              .where((element) => !provider
                              .getDriversListResponseModel!
                              .data
                              .schedule
                              .rejected
                              .contains(element.id))
                              .toList();

                          final requestsList = provider
                              .getDriversListResponseModel!.data.nearestDriver
                              .where((element) => provider
                                  .getDriversListResponseModel!
                                  .data
                                  .schedule
                                  .driversRequest
                                  .contains(element.id))
                              .where((element) => !provider
                                  .getDriversListResponseModel!
                                  .data
                                  .schedule
                                  .rejected
                                  .contains(element.id))
                              .where((element) => !provider
                              .getDriversListResponseModel!
                              .data
                              .schedule
                              .cancelled
                              .contains(element.id))
                              .toList();

                          final matchedList = provider
                              .getDriversListResponseModel!.data.nearestDriver
                              .where((element) => (!provider
                                      .getDriversListResponseModel!
                                      .data
                                      .schedule
                                      .driversRequest
                                      .contains(element.id) &&
                                  !element.accepted.contains(provider
                                      .getDriversListResponseModel!
                                      .data
                                      .schedule
                                      .id)))
                              .where((element) => !provider
                                  .getDriversListResponseModel!
                                  .data
                                  .schedule
                                  .rejected
                                  .contains(element.id))
                              .where((element) => !provider
                                  .getDriversListResponseModel!
                                  .data
                                  .schedule
                                  .cancelled
                                  .contains(element.id))
                              .toList();

                          // Delaying to overcome mark state issue
                          Timer(const Duration(milliseconds: 300), () {
                            provider.requestsLength.value = RequestsLengthModel(
                                requests: requestsList.length,
                                confirmed: confirmList.length,
                                matched: matchedList.length);
                          });

                          return TabBarView(
                            children: [
                              OwnersListWidget(
                                type: ScheduleListType.requests,
                                list: requestsList,
                              ),
                              OwnersListWidget(
                                type: ScheduleListType.matched,
                                list: matchedList,
                              ),
                              OwnersListWidget(
                                type: ScheduleListType.confirmed,
                                list: confirmList,
                              ),
                            ],
                          );
                        }))
                      ],
                    ),
                  ),
                );
              }
            }),
      ),
    );
  }
}
