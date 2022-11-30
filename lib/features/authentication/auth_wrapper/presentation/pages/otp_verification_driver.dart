import 'package:flutter/material.dart';
import '../../../../../core/utils/globals/globals.dart';
import '../../../../../core/widgets/back_aerro_button.dart';
import '../providers/auth_provider.dart';
import '../providers/otp_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../core/widgets/custom/custom_otp_fields.dart';

class DriverOtpVerification extends StatelessWidget {
  DriverOtpVerification({Key? key}) : super(key: key);
  final OtpProvider _otpProvider = sl();
  final AuthProvider _authProvider = sl();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider.value(value: _otpProvider),
      ChangeNotifierProvider.value(value: _authProvider),
    ], child: const DriverOtpVerificationContent());
  }
}

class DriverOtpVerificationContent extends StatefulWidget {
  const DriverOtpVerificationContent({Key? key}) : super(key: key);

  @override
  State<DriverOtpVerificationContent> createState() =>
      _DriverOtpVerificationContentState();
}

class _DriverOtpVerificationContentState
    extends State<DriverOtpVerificationContent> {
  @override
  void initState() {
    super.initState();

    context.read<OtpProvider>().resendOtpCounter();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    onBackPress = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer2<OtpProvider, AuthProvider>(
          builder: (_, provider, authProvider, __) {
        return SingleChildScrollView(
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
                      "We have sent OTP to you",
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
                    if (provider.byDefaultSmsOtp == false)
                      Column(
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
                            verified: provider.phoneVerified,

                            readOnly: provider.phoneVerified,
                            onChanged: (value) {
                              if (value.length == 4) {
                                provider.validatePhoneOtp(value);
                              }
                            },
                            // controller: context.read<OtpProvider>().mobileOtpController,
                            // errorStream:
                            //     context.read<OtpProvider>().phoneOtpErrorStream,
                            // onCompleted:
                            //     context.read<OtpProvider>().onPhoneOtpCompleted,
                          ),
                        ],
                      ),
                    if (provider.byDefaultEmailOtp == false)
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 20.h,
                          ),
                          Text(
                            "Enter the 4-digit Email OTP:",
                            style: TextStyle(fontSize: 18.sp),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          CustomOtpFields(
                            readOnly: provider.emailVerified,
                            verified: provider.emailVerified,
                            onChanged: provider.onChanged,
                            // controller: context.read<OtpProvider>().emailOtpController,
                            // errorStream:
                            //     context.read<OtpProvider>().emailOtpErrorStream,
                            // onCompleted:
                            //     context.read<OtpProvider>().onEmailOtpCompleted,
                          ),
                        ],
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
                                          provider.resendOtp(context);

                                          // AppState appState = GetIt.I.get<AppState>();
                                          // appState.currentAction = PageAction(
                                          //     state: PageState.addPage,
                                          //     page: PageConfigs
                                          //         .vehicleDetailsPageConfig);
                                        },
                                        child: const Text("Resend code")),
                              );
                            })
                        : Center(
                            child: Text(
                              "${provider.counter ~/ 60} : ${provider.counter % 60}",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),


                    // if (provider.emailVerified && provider.phoneVerified)
                    //   ContinueButton(
                    //       text: 'Continue',
                    //       onPressed: () async {
                    //         context.read<OtpProvider>().storeAndGoToNext();
                    //       }),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
