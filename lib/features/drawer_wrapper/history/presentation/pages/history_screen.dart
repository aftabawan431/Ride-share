import 'package:flutter/material.dart';
import 'package:flutter_rideshare/core/widgets/custom_column_appbar.dart';
import 'package:flutter_rideshare/features/authentication/auth_wrapper/presentation/providers/auth_provider.dart';
import '../../../../../core/widgets/back_aerro_button.dart';
import '../providers/history_provider.dart';
import '../widgets/history_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../core/utils/globals/globals.dart';

class HistoryScreen extends StatelessWidget {
  HistoryScreen({Key? key}) : super(key: key);
  final HistoryProvider historyProvider = sl();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: historyProvider, child: const HistoryScreenContent());
  }
}

class HistoryScreenContent extends StatefulWidget {
  const HistoryScreenContent({Key? key}) : super(key: key);

  @override
  State<HistoryScreenContent> createState() => _HistoryScreenContentState();
}

class _HistoryScreenContentState extends State<HistoryScreenContent> {
  @override
  void initState() {
    super.initState();
    HistoryProvider historyProvider = sl();
    historyProvider.getHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
             const CustomColumnAppBar(title: 'History' ),
              SizedBox(height: 10.h,),

              Expanded(
                child : ValueListenableBuilder<bool>(
                    valueListenable:
                    context.read<HistoryProvider>().getHistoryLoading,
                    builder: (_, value, __) {
                      if (value) {
                        return const Center(
                            child:  CircularProgressIndicator.adaptive());
                      } else {
                        return Consumer<HistoryProvider>(
                            builder: (context, provider, ch) {
                              if (provider.getHistoryResponseModel!.data.isEmpty) {
                                return Container(
                                  height: 200.h,
                                  margin: EdgeInsets.symmetric(horizontal: 30.w),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: const Center(
                                      child: Text("No history found!")),
                                );
                              }

                              return Container(
                                margin: EdgeInsets.symmetric(horizontal: 18.w),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Column(
                                        children: [
                                          ...provider.getHistoryResponseModel!.data
                                              .map((e) => HistoryWidget(
                                            history: e,
                                          ))
                                              .toList()
                                        ],
                                      ),

                                      if(provider.showReadMoreHistory)
                                        provider.readMoreHistoryLoading?const Center(child: CircularProgressIndicator(),):
                                        TextButton(onPressed: (){
                                          AuthProvider authProvider=sl();
                                          if(authProvider.currentUser!.isDriver()){
                                            provider.getDriverHistory(isFirstTime:false);
                                          }else{
                                            provider.getHistory(isFirstTime:false);

                                          }
                                          // provider.getPassengerSchedules(isFirstTime: false);
                                        }, child: Text("Read more"))
                                    ],
                                  ),
                                ),
                              );
                            });
                      }
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
