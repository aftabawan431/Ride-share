import 'package:flutter/material.dart';
import 'package:flutter_rideshare/core/widgets/custom_column_appbar.dart';
import '../providers/driver_dashboard_provider.dart';
import '../widgets/dashboard_history_ride_widget.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/globals/globals.dart';

class DashbardRideHistoryPage extends StatelessWidget {
  final String status;
  final DashboardProvider provider = sl();

  DashbardRideHistoryPage({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: provider,
        child: DashboardRideHistoryPageContent(
          status: status,
        ));
  }
}

class DashboardRideHistoryPageContent extends StatefulWidget {
  final String status;

  const DashboardRideHistoryPageContent({Key? key, required this.status})
      : super(key: key);

  @override
  State<DashboardRideHistoryPageContent> createState() =>
      _DashboardRideHistoryPageContentState();
}

class _DashboardRideHistoryPageContentState
    extends State<DashboardRideHistoryPageContent> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<DashboardProvider>().getDashboardHistoryRides(widget.status);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomColumnAppBar(
              title: widget.status == 'upcoming'
                  ? 'Upcoming Rides'
                  : widget.status == 'completed'
                      ? "Completed Rides"
                      : widget.status == 'cancelled'
                          ? 'Cancelled Rides'
                          : 'Total Rides',
            ),
            ValueListenableBuilder<bool>(
                valueListenable: context
                    .read<DashboardProvider>()
                    .dashboardHistoryRidesLoading,
                builder: (_, loading, __) {
                  return Expanded(
                      child: loading
                          ? const Center(
                              child: CircularProgressIndicator.adaptive(),
                            )
                          : context
                                  .read<DashboardProvider>()
                                  .dashboardRideHistoryReponseModel!
                                  .data
                                  .isEmpty
                              ? const Center(
                                  child: Text("No rides found!"),
                                )
                              :     Consumer<DashboardProvider>(
                          builder: (context, provider, ch) {
                                  return SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          ListView.builder(
                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(),
                                            itemCount: context
                                                .read<DashboardProvider>()
                                                .dashboardRideHistoryReponseModel!
                                                .data
                                                .length,
                                            itemBuilder: (context, index) {
                                              return DashboardHistoryRideWidget(
                                                  status: widget.status,
                                                  model: provider
                                                      .dashboardRideHistoryReponseModel!
                                                      .data[index]);
                                            },
                                          ),
                                      if (provider.showReadMore)
                                     provider.readMoreLoading
                                        ? const Center(
                                      child:
                                      CircularProgressIndicator(),
                                    )
                                        : TextButton(
                                        onPressed: () {
                                          provider
                                              .getDashboardHistoryRides(
                                              widget.status,
                                              isFirstTime: false);
                                        },
                                        child: Text("Read more"))


                                        ],
                                      ),
                                    );
                                }
                              ));
                })
          ],
        ),
      ),
    );
  }
}
