import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_rideshare/core/utils/theme/app_theme.dart';
import 'package:flutter_rideshare/features/drawer_wrapper/schedules_driver/data/models/requests_length_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../core/utils/constants/socket_point.dart';
import '../../../../../core/utils/enums/ScheduleListType.dart';
import '../../../../../core/utils/enums/page_state_enum.dart';
import '../../../../../core/utils/globals/globals.dart';
import '../../../../../core/utils/sockets/sockets.dart';
import '../../../../../core/widgets/back_aerro_button.dart';
import '../../../../ride/presentation/providers/driver_ride_provider.dart';
import '../providers/schedule_provider.dart';
import '../widgets/passenger_list_widget.dart';
import '../widgets/request_passenger_widget.dart';
import '../widgets/requested_passengers_widge.dart';

class RequestedPassengersScreen extends StatelessWidget {
  RequestedPassengersScreen({Key? key, required this.id}) : super(key: key);
  ScheduleProvider scheduleProvider = sl();
  DriverRideProvider driverRideProvider = sl();

  final String id;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: scheduleProvider),
          ChangeNotifierProvider.value(value: driverRideProvider),
        ],
        child: RequestPassengersScreenContent(
          id: id,
        ));
  }
}

class RequestPassengersScreenContent extends StatefulWidget {
  const RequestPassengersScreenContent({Key? key, required this.id})
      : super(key: key);
  final String id;

  @override
  State<RequestPassengersScreenContent> createState() =>
      _RequestPassengersScreenContentState();
}

class _RequestPassengersScreenContentState
    extends State<RequestPassengersScreenContent> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<ScheduleProvider>().newRequestDriver();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    SocketService.socket!.off(SocketPoint.driverNewRequestOn);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    context.read<ScheduleProvider>().getRequestedPassengers(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          body: ValueListenableBuilder<bool>(
              valueListenable: context
                  .read<ScheduleProvider>()
                  .getRequestedPassengersLoading,
              builder: (_, loading, __) {
                if (loading) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                } else {
                  return SafeArea(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 18.w, vertical: 10.h),
                          decoration: BoxDecoration(
                              color: AppTheme.appTheme.primaryColor),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const BackAerroButton(),
                              Expanded(
                                  child: Center(
                                child: Text(
                                  "Requests",
                                  style: TextStyle(
                                      fontSize: 30.sp, color: Colors.white),
                                ),
                              )),
                              if (!context
                                  .read<ScheduleProvider>()
                                  .getRequestedPassengerResponseModel!
                                  .data
                                  .isScheduled)
                                TextButton(
                                  onPressed: () {
                                    context
                                        .read<DriverRideProvider>()
                                        .getAndSetCurrentRide(
                                            context
                                                .read<ScheduleProvider>()
                                                .getRequestedPassengerResponseModel!
                                                .data
                                                .id,
                                            pageState: PageState.replace);
                                  },
                                  child: Text(
                                      context
                                                  .read<ScheduleProvider>()
                                                  .getRequestedPassengerResponseModel!
                                                  .data
                                                  .status ==
                                              'active'
                                          ? "Start"
                                          : "Ride",
                                      style:
                                          const TextStyle(color: Colors.white)),
                                ),
                              SizedBox(
                                height: 10.h,
                              ),
                            ],
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
                          height: 10.h,
                        ),

                        Expanded(child: Consumer<ScheduleProvider>(
                            builder: (_, provider, __) {
                          final model =
                              provider.getRequestedPassengerResponseModel!.data;

                          final requestsList = model.request
                              .where((element) =>
                                  !model.accepted.contains(element.id))
                              .where((element) =>
                                  !model.cancelled.contains(element.id))
                              .where((element) =>
                                  !model.rejected.contains(element.id))
                              .where((e) => e.status != 'cancelled')
                              .toList();

                          final matchedList = provider
                              .getRequestedPassengerResponseModel!
                              .matchedPassengers
                              .where((element) =>
                                  !model.accepted.contains(element.id))
                              .where((element) =>
                                  !model.cancelled.contains(element.id))
                              .where((element) =>
                                  !model.rejected.contains(element.id))
                              .where((element) => element.status != 'cancelled')
                              .toList();

                          final confirmedList = [
                            ...model.request
                                .where((element) =>
                                    model.accepted.contains(element.id))
                                .toList(),
                            ...provider.getRequestedPassengerResponseModel!
                                .matchedPassengers
                                .where((element) =>
                                    (model.accepted.contains(element.id) &&
                                        (!model.request
                                            .map((e) => e.id)
                                            .contains(element.id))))
                                .toList(),
                          ]
                              .where((element) => element.status != 'completed')
                              .toList();

                          // Delaying to overcome mark state issue
                          Timer(const Duration(milliseconds: 300), () {
                            provider.requestsLength.value = RequestsLengthModel(
                                requests: requestsList.length,
                                confirmed: confirmedList.length,
                                matched: matchedList.length);
                          });

                          return TabBarView(
                            children: [
                              PassengersListWidget(
                                type: ScheduleListType.requests,
                                list: requestsList,
                              ),
                              PassengersListWidget(
                                type: ScheduleListType.matched,
                                list: matchedList,
                              ),
                              PassengersListWidget(
                                type: ScheduleListType.confirmed,
                                list: confirmedList,
                              ),
                            ],
                          );
                        })),

                        // Expanded(
                        //   child: Consumer<ScheduleProvider>(
                        //       builder: (_, provider, ch) {
                        //         if (provider.getRequestedPassengerResponseModel!
                        //             .data.request.isEmpty) {
                        //           return Container(
                        //             height: 200.h,
                        //             margin:
                        //             EdgeInsets.symmetric(horizontal: 30.w),
                        //             width: double.infinity,
                        //             decoration: BoxDecoration(
                        //               color: Colors.white,
                        //               borderRadius: BorderRadius.circular(15),
                        //             ),
                        //             child:
                        //             const Center(child: Text("No requests")),
                        //           );
                        //         }
                        //
                        //         return Container(
                        //           margin: EdgeInsets.symmetric(horizontal: 18.w),
                        //           child: SingleChildScrollView(
                        //             child: Column(
                        //               children: [
                        //                 ...provider
                        //                     .getRequestedPassengerResponseModel!
                        //                     .data
                        //                     .request
                        //                     .map((e) => RequestedPassengerWidget(
                        //                   passenger: e,
                        //                 ))
                        //                     .toList(),
                        //               ],
                        //             ),
                        //           ),
                        //         );
                        //       }),
                        // )
                      ],
                    ),
                  );
                }
              }),
        ),
      ),
    );
  }
}
