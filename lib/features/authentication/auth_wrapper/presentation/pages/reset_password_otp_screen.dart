import 'package:flutter/material.dart';
import 'package:flutter_rideshare/core/utils/enums/otp_reset_enum.dart';
import 'package:flutter_rideshare/features/authentication/auth_wrapper/presentation/providers/auth_provider.dart';
import 'package:flutter_rideshare/features/wallet/presentation/manager/wallet_provider.dart';
import '../../../../../core/utils/globals/globals.dart';
import '../../../../../core/widgets/back_aerro_button.dart';
import '../providers/otp_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../core/widgets/custom/custom_otp_fields.dart';

class ResetPasswordOtpScreen extends StatelessWidget {
  ResetPasswordOtpScreen({Key? key}) : super(key: key);

  final OtpProvider _otpProvider = sl();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider.value(value: _otpProvider),
    ], child: const ResetPasswordOtpScreenContent());
  }
}

class ResetPasswordOtpScreenContent extends StatefulWidget {
  const ResetPasswordOtpScreenContent({Key? key}) : super(key: key);

  @override
  State<ResetPasswordOtpScreenContent> createState() =>
      _ResetPasswordOtpScreenContentState();
}

class _ResetPasswordOtpScreenContentState
    extends State<ResetPasswordOtpScreenContent> {
  @override
  void initState() {
    super.initState();

    context.read<OtpProvider>().resendOtpCounter();
  }

  @override
  void dispose() {
    super.dispose();
    OtpProvider otpProvider = sl();

    otpProvider.stopTimerIfActive();
    otpProvider.resetValues();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OtpProvider>(builder: (_, provider, __) {
      return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Theme.of(context).primaryColor,
                height: 240.h,
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const BackAerroButton(),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      "OTP Verification",
                      style: TextStyle(fontSize: 30.sp, color: Colors.white),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    const Text(
                      "We have sent OTP code here",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      "Enter the 4-digit SMS OTP:",
                      style: TextStyle(fontSize: 18.sp),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    CustomOtpFields(
                      // onChanged: (value) {},
                      // controller: context.read<OtpProvider>().resetPasswordOtpControler,
                      onChanged:
                          context.read<OtpProvider>().onRestPasswordOtpChange,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    provider.canResend
                        ? ValueListenableBuilder<bool>(
                            valueListenable:
                                context.read<OtpProvider>().otpLoading,
                            builder: (_, value, __) {
                              return AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child: value
                                    ? const Center(
                                        child: CircularProgressIndicator
                                            .adaptive(),
                                      )
                                    : TextButton(
                                        onPressed: () {
                                          OtpProvider otpProvider = sl();
                                          // if(otpProvider.otpResetType==OtpResetType.resetPassword){

                                          if (otpProvider.otpResetType ==
                                              OtpResetType.completeRide) {
                                            WalletProvider walletProvider =
                                                sl();
                                            walletProvider.sendCompleteRideOtp(
                                                walletProvider
                                                    .completeScheduleId,
                                                isResend: true);
                                          } else if (otpProvider.otpResetType ==
                                              OtpResetType.updateMobile) {
                                            AuthProvider authProvider = sl();
                                            authProvider
                                                .newNumberAvailbleCheck(isResent: true);
                                          } else {
                                            provider.resendResetPasswordOtp(
                                                context);
                                          }
                                          // }

                                          // AppState appState = GetIt.I.get<AppState>();
                                          // appState.currentAction = PageAction(
                                          //     state: PageState.addPage,
                                          //     page: PageConfigs
                                          //         .vehicleDetailsPageConfig);
                                        },
                                        child: const Text("Resend code")),
                              );
                            })
                        : Text(
                            "${provider.counter ~/ 60} : ${provider.counter % 60}",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
