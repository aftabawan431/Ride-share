import 'package:flutter/material.dart';
import 'package:flutter_rideshare/core/widgets/custom_column_appbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../../../../core/utils/constants/app_url.dart';
import '../../../../../core/utils/extension/extensions.dart';
import '../../../../../core/utils/globals/globals.dart';
import '../../../../../core/widgets/back_aerro_button.dart';
import '../../../../../core/widgets/modals/notificaiton_details.dart';
import '../providres/notification_provider.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({Key? key}) : super(key: key);

  final SystemNotificationsProvider provider = sl();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: provider, child: const NotificationScreenContent());
  }
}

class NotificationScreenContent extends StatefulWidget {
  const NotificationScreenContent({Key? key}) : super(key: key);

  @override
  State<NotificationScreenContent> createState() =>
      _NotificationScreenContentState();
}

class _NotificationScreenContentState extends State<NotificationScreenContent> {
  @override
  void initState() {
    super.initState();
    SystemNotificationsProvider provider = sl();
    provider.getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<bool>(
          valueListenable: context
              .read<SystemNotificationsProvider>()
              .getNotificationsLoading,
          builder: (_, loading, __) {
            if (loading) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            } else {
              return SafeArea(
                child: Column(
                  children: [
                    CustomColumnAppBar(title: 'Notifications'),
                    Consumer<SystemNotificationsProvider>(
                        builder: (context, provider, ch) {
                      return Expanded(
                          child: provider
                                  .getNotificationsResponseModel!.data.isEmpty
                              ? const Center(
                                  child: Text("No new notifications"),
                                )
                              : ListView.builder(
                                  itemCount: provider
                                      .getNotificationsResponseModel!
                                      .data
                                      .length,
                                  itemBuilder: (context, int index) {
                                    final model = provider
                                        .getNotificationsResponseModel!
                                        .data[index];
                                    return GestureDetector(
                                      onTap: (){
                                        Logger().v("here it is");
                                        NotificationDetailsModel model=NotificationDetailsModel(context, model: provider
                                            .getNotificationsResponseModel!
                                            .data[index]);
                                        model.show();
                                      },
                                      child: _notificationWidget(
                                          title: model.title,
                                          subTitle: model.message,
                                          icon: model.icon,
                                          date: model.createdAt),
                                    );
                                  },
                                ));
                    })
                  ],
                ),
              );
            }
          }),
    );
  }

  Widget _notificationWidget(
      {required String title,
      required String subTitle,
      required String icon,
      required String date}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 1),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      color: Colors.white,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.white.withOpacity(.8),
          child: Image.network(AppUrl.fileBaseUrl + icon),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title.toTitleCase(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 5.w,),
            Text(DateFormat("yyyy-MM-dd hh:mm a")
                .format(DateTime.parse(date).toLocal()),style: TextStyle(
              color: Colors.black26,
              fontSize: 9.sp,

            ),)
          ],
        ),
        subtitle: Text(
          subTitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
