import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rideshare/core/router/app_state.dart';
import 'package:flutter_rideshare/core/router/models/page_config.dart';
import 'package:flutter_rideshare/core/utils/constants/app_assets.dart';
import 'package:flutter_rideshare/core/utils/enums/otp_reset_enum.dart';
import 'package:flutter_rideshare/core/utils/theme/app_theme.dart';
import 'package:flutter_rideshare/core/widgets/custom/continue_button.dart';
import 'package:flutter_rideshare/features/authentication/auth_wrapper/presentation/providers/otp_provider.dart';
import 'package:flutter_rideshare/features/wallet/data/models/get_wallet_info_response_model.dart';
import 'package:flutter_rideshare/features/wallet/presentation/manager/wallet_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/globals/globals.dart';

class UserWalletScreen extends StatelessWidget {
  UserWalletScreen({Key? key}) : super(key: key);
  WalletProvider walletProvider = sl();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: walletProvider, child: const _UserWalletScreenContent());
  }
}

class _UserWalletScreenContent extends StatefulWidget {
  const _UserWalletScreenContent({Key? key}) : super(key: key);

  @override
  State<_UserWalletScreenContent> createState() =>
      _UserWalletScreenContentState();
}

class _UserWalletScreenContentState extends State<_UserWalletScreenContent> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<WalletProvider>().getWalletInfo(reCall: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 330.h,
              child: Stack(
                children: [
                  Positioned.fill(
                      child: SvgPicture.asset(
                    AppAssets.inviteFriendsBgSvg,
                    fit: BoxFit.cover,
                  )),
                  Positioned(
                    top: 10.h,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        _returnTopAppBar(),
                        SizedBox(
                          height: 20.h,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10.w),
                          padding: EdgeInsets.symmetric(
                              horizontal: 18.w, vertical: 10.h),
                          width: double.infinity,
                          height: 180.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.r),
                              color: Colors.white.withOpacity(.7),
                              image: const DecorationImage(
                                  image: AssetImage(
                                    AppAssets.cardPng,
                                  ),
                                  fit: BoxFit.cover)),
                          child: Selector<WalletProvider,
                                  GetWalletInfoResponseModel?>(
                              selector: (context, provider) =>
                                  provider.getWalletInfoResponseModel,
                              builder: (context, value, ch) {
                                if (value == null) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                return Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        value.data.walletInfo.getFullName(),
                                        style: TextStyle(
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.bold),
                                        maxLines: 2,
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "Available Balance",
                                            style: TextStyle(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green),
                                          ),
                                          RichText(
                                            text: TextSpan(
                                                text: 'PKR ',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12.sp),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text: value.data.walletInfo
                                                        .wallet.balance
                                                        .toStringAsFixed(2),
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 28.sp,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                ]),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                );
                              }),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 25.h,
            ),
            Selector<WalletProvider, GetWalletInfoResponseModel?>(
                selector: (context, provider) =>
                    provider.getWalletInfoResponseModel,
                builder: (context, value, ch) {
                  if (value == null) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18.w),
                      child: ContinueButton(
                        loadingNotifier: context.read<WalletProvider>().accountLoading,
                          text: value.data.walletInfo.zindgiWallet.linked
                              ? 'Unlink your account'
                              : 'Link Zindigi Account',
                          onPressed: () async {
                            if (value.data.walletInfo.zindgiWallet.linked) {
                              if (await confirm(navigatorKeyGlobal.currentContext!,
                                  content: Text(
                                      "Are you sure you want to unlink your account?"))) {
                                OtpProvider otpProvider=sl();
                                otpProvider.otpResetType=OtpResetType.unlinkZindigiAccount;
                                context.read<WalletProvider>().zindigiWalletOtp();
                              }
                            } else {
                              AppState appState = sl();
                              appState.goToNext(
                                  PageConfigs.linkZindigiAccountPageConfig);
                            }
                          }));
                })
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
            'Wallet',
            style: TextStyle(fontSize: 22.sp, color: Colors.white),
          ),
          Expanded(child: Container()),

        ],
      ),
    );
  }

  Widget _customButton(
      {required VoidCallback onTap, required String title, IconData? icon}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: AppTheme.appTheme.primaryColor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null)
            Icon(
              icon,
              color: Colors.white,
              size: 13.sp,
            ),
          if (icon != null)
            SizedBox(
              width: 2.w,
            ),
          Text(
            title,
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }
}
