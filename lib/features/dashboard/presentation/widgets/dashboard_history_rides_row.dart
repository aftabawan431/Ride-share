import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../../../../core/router/app_state.dart';
import '../../../../core/router/models/page_action.dart';
import '../../../../core/router/models/page_config.dart';
import '../../../../core/router/pages.dart';
import '../../../../core/utils/constants/app_assets.dart';
import '../../../../core/utils/enums/page_state_enum.dart';
import '../../../../core/utils/globals/globals.dart';
import '../../../authentication/auth_wrapper/presentation/providers/auth_provider.dart';
import '../../data/model/dashboard_data_response_model.dart';
import '../pages/dashboard_rides_history_page.dart';
import '../providers/driver_dashboard_provider.dart';

class DashboardHistoryRidesRow extends StatelessWidget {
  const DashboardHistoryRidesRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Selector<DashboardProvider,

          GetDashboardDataResponseModel>(
          selector: (_, provider) =>
          provider.getDashboardDataResponseModel!,
          builder: (context, data, ch) {
            return GridView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 5.0,
              mainAxisSpacing: 5.0,
            ),children: [GestureDetector(
              onTap: () {
                AppState appState = sl();
                appState.currentAction = PageAction(
                    state: PageState.addWidget,
                    page: PageConfigs
                        .dashboardRideHistoryPageConfig,
                    widget: DashbardRideHistoryPage(
                      status: 'total',
                    ));


              },
              child: _infoContents(
                  icon: AppAssets.totalRidesSvg,
                  context: context,
                  text: 'Total Rides till today',
                  number:
                  data.data.totalRides.toString()),
            ),
              GestureDetector(
                onTap: () {
                  AppState appState = sl();
                  appState.currentAction = PageAction(
                      state: PageState.addWidget,
                      page: PageConfigs
                          .dashboardRideHistoryPageConfig,
                      widget: DashbardRideHistoryPage(
                        status: 'upcoming',
                      ));
                },
                child: _infoContents(
                    icon: AppAssets.upcomingRidesSvg,
                    context: context,
                    text: 'Upcoming Rides',
                    number: data.data.upcomingRides
                        .toString()),
              ),
              GestureDetector(
                onTap: () {
                  AppState appState = sl();
                  appState.currentAction = PageAction(
                      state: PageState.addWidget,
                      page: PageConfigs
                          .dashboardRideHistoryPageConfig,
                      widget: DashbardRideHistoryPage(
                        status: 'completed',
                      ));
                  return;

                },
                child: _infoContents(
                    icon: AppAssets.completeRidesSvg,
                    context: context,
                    text: 'Completed Rides',
                    number: data.data.completedRides
                        .toString()),
              ),
              GestureDetector(
                onTap: () {
                  AppState appState = sl();
                  appState.currentAction = PageAction(
                      state: PageState.addWidget,
                      page: PageConfigs
                          .dashboardRideHistoryPageConfig,
                      widget: DashbardRideHistoryPage(
                        status: 'cancelled',
                      ));
                  return;

                },
                child: _infoContents(
                    icon: AppAssets.cancelRidesSvg,
                    context: context,
                    text: 'Cancelled Rides',
                    number: data.data.cancelledRides
                        .toString()),
              )],);
          }),
    );
  }
  goToNext(PageConfiguration pageConfigs) {
    AppState appState = GetIt.I.get<AppState>();
    appState.currentAction = PageAction(
      state: PageState.addPage,
      page: pageConfigs,
    );
  }


  Widget _infoContents(
      {required BuildContext context,
        required String icon,
        required String number,
        required String text}) {
    return Container(
      margin: EdgeInsets.only(right: 6.w, top: 4, bottom: 4, left: 1),
      padding: const EdgeInsets.symmetric(vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        // border: Border.all(
        //   color: Colors.grey,
        //   width: 1,
        // ),
        // color: Colors.grey.withOpacity(.15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: .5,
            blurRadius: .5,
          ),
        ],
      ),
      width: 100.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            icon,
            width: 74.sp,
          ),
          SizedBox(
            height: 7.h,
          ),
          Text(
            text,
            style: Theme.of(context)
                .textTheme
                .headline4
                ?.copyWith(fontSize: 10.sp, color: Colors.black),
            textAlign: TextAlign.center,

          ),
          SizedBox(
            height: 5.h,
          ),
          Text(
            number,
            style: Theme.of(context)
                .textTheme
                .headline4
                ?.copyWith(fontSize: 18.sp, color: Colors.green,fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
