import 'package:flutter/material.dart';
import 'package:flutter_rideshare/core/router/models/page_config.dart';
import 'package:flutter_rideshare/core/utils/enums/button_type.dart';
import 'package:flutter_rideshare/core/widgets/custom/continue_button.dart';
import 'package:flutter_rideshare/core/widgets/modals/display_status_model.dart';
import 'package:flutter_rideshare/features/authentication/auth_wrapper/presentation/providers/auth_provider.dart';
import 'package:flutter_rideshare/features/wallet/presentation/manager/wallet_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../../core/router/app_state.dart';
import '../../../../core/utils/constants/app_assets.dart';
import '../../../../core/utils/globals/globals.dart';

class LinkZindigiAccountScreen extends StatelessWidget {
  final WalletProvider walletProvider = sl();
  LinkZindigiAccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: walletProvider, child: _LinkAccountScreenContent());
  }
}

class _LinkAccountScreenContent extends StatefulWidget {
  _LinkAccountScreenContent({Key? key}) : super(key: key);

  @override
  State<_LinkAccountScreenContent> createState() => _LinkAccountScreenContentState();
}

class _LinkAccountScreenContentState extends State<_LinkAccountScreenContent> {
  AuthProvider authProvider = sl();

  @override
  void initState() {
    super.initState();
    WalletProvider walletProvider=sl();
    walletProvider.linkingLoading.value=false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
                height: 480.h,
                child: Stack(children: [
                  Positioned.fill(
                      child: SvgPicture.asset(
                    AppAssets.inviteFriendsBgSvg,
                    fit: BoxFit.cover,
                  )),
                  Positioned(
                      top: 10.h,
                      left: 0,
                      right: 0,
                      child: Column(children: [
                        _returnTopAppBar(),
                        SizedBox(
                          height: 30.h,
                        ),
                        Image.asset(
                          AppAssets.zindigiPng,
                          width: 180.sp,
                          height: 180.sp,
                        ),
                        SizedBox(
                          height: 30.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30.w),
                          child: Text(
                            "Are you sure you want your existing number (+${authProvider.currentUser!.mobile}) to be linked with Zindigi account?",
                            style: TextStyle(
                              fontSize: 19.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ]))
                ])),
            SizedBox(
              height: 30.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child: ContinueButton(
                text: 'Change Number',
                onPressed: () {
                  AppState appState = sl();
                  appState.goToNext(PageConfigs.editProfilePageConfig);
                },
                buttonType: ButtonType.Bordered,
                iconData: Icons.phone,
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child: ContinueButton(
                loadingNotifier: context.read<WalletProvider>().linkingLoading,
                text: 'Link Account',
                onPressed: () {
                  context.read<WalletProvider>().validateZindigiAccount();

                  return;
                  DisplayStatusModel modal = DisplayStatusModel(context,
                      title: 'Linking Unsuccessful!',
                      content:
                          'You have Successfully Linked Your Account To Zindigi',
                      icon: AppAssets.alertIconPng);
                  modal.show();
                },
                icon: AppAssets.linkAccountPng,
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
          ],
        ),
      ),
    );
  }

  Widget _returnTopAppBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              AppState appState = sl();
              appState.moveToBackScreen();
            },
            child: Icon(
              Icons.keyboard_arrow_left_sharp,
              color: Colors.white,
              size: 35.r,
            ),
          ),
         Expanded(child: Container()),
          Text(
            'Link Account',
            style: TextStyle(fontSize: 22.sp, color: Colors.white),
          ),
          Expanded(child: Container()),

        ],
      ),
    );
  }
}
