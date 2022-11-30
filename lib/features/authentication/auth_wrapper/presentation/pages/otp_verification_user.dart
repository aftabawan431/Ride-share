import 'package:flutter/material.dart';
import '../../../../../core/utils/globals/globals.dart';
import '../../../../../core/widgets/back_aerro_button.dart';
import '../providers/otp_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../core/widgets/custom/custom_otp_fields.dart';

class UserOtpVerification extends StatelessWidget {
  UserOtpVerification({Key? key}) : super(key: key);

  final OtpProvider _otpProvider = sl();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider.value(value: _otpProvider),
    ], child: const UserOtpVerificationContent());
  }
}

class UserOtpVerificationContent extends StatefulWidget {
  const UserOtpVerificationContent({Key? key}) : super(key: key);

  @override
  State<UserOtpVerificationContent> createState() =>
      _UserOtpVerificationContentState();
}

class _UserOtpVerificationContentState
    extends State<UserOtpVerificationContent> {
  @override
  void initState() {
    super.initState();

    context.read<OtpProvider>().resendOtpCounter();
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
                      "We have sent OTP code",
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
                      readOnly: provider.phoneVerified,
                      onChanged: (value) {},
                      // controller: context.read<OtpProvider>().mobileOtpController,
                      // errorStream:
                      //     context.read<OtpProvider>().phoneOtpErrorStream,
                      onCompleted:
                          context.read<OtpProvider>().onPhoneOtpCompleted,
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
                    // if (provider.phoneVerified)
                    //   ContinueButton(
                    //       text: 'Continue',
                    //       onPressed: () async {
                    //         context.read<OtpProvider>().storeAndGoToNext();
                    //       })
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
