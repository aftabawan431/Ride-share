import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rideshare/core/utils/enums/otp_reset_enum.dart';
import 'package:flutter_rideshare/core/widgets/custom_column_appbar.dart';
import '../../../../../core/utils/extension/extensions.dart';
import '../../../../authentication/auth_wrapper/presentation/providers/auth_provider.dart';
import '../../../../authentication/auth_wrapper/presentation/providers/otp_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../../../../../core/router/app_state.dart';
import '../../../../../core/router/models/page_action.dart';
import '../../../../../core/router/models/page_config.dart';
import '../../../../../core/utils/enums/page_state_enum.dart';
import '../../../../../core/utils/globals/globals.dart';
import '../../../../../core/widgets/back_aerro_button.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);
  AuthProvider _authProvider = sl();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [ChangeNotifierProvider.value(value: _authProvider)],
        child: ProfileScreenContent());
  }
}

class ProfileScreenContent extends StatelessWidget {
  ProfileScreenContent({Key? key}) : super(key: key);
  final OtpProvider otpProvider = sl();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomColumnAppBar(
              title: 'Profile',
              actionIcon: Icons.edit,
              actionOnTap: () {
                AppState appState = GetIt.I.get<AppState>();
                appState.currentAction = PageAction(
                    state: PageState.addPage,
                    page: PageConfigs.editProfilePageConfig);
              },
              showActionButton: true,
            ),
            Consumer<AuthProvider>(builder: (_, provider, __) {
              return Container(
                decoration: const BoxDecoration(color: Colors.white),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _profileItemWidget('Name',
                        "${provider.currentUser!.firstName.toTitleCase()} ${provider.currentUser!.lastName.toTitleCase()}"),
                    _profileItemWidget('Email', provider.currentUser!.email),
                    if(provider.currentUser!.cnic>0)
                    _profileItemWidget('CNIC', provider.currentUser!.cnic.toString()),
                    _profileItemWidget(
                        'Mobile', provider.currentUser!.mobile.toString(),isMobile: true),
                    _profileItemWidget(
                        'Gender', provider.currentUser!.gender.toTitleCase()),
                    _profileItemWidget(
                        'Date of Birth', provider.currentUser!.dob),
                    _profileItemWidget('Password', "Update",
                        isPasswordReset: true),
                    Center(
                      child: TextButton(
                        onPressed: () async {
                          if (await confirm(navigatorKeyGlobal.currentContext!,
                              content: const Text(
                                  "Are you sure you want to delete your account? You won't be able to undo this."))) {
                            AppState appState = sl();
                            appState.goToNext(PageConfigs
                                .deleteAccountConfirmationPasswordScreenPageConfig);
                          }
                        },
                        child: const Text(
                          "Delete Account",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    )
                  ],
                ),
              );
            })
          ],
        ),
      ),
    );
  }

  Widget _profileItemWidget(String title, String value,
      {bool isPasswordReset = false,bool isMobile=false}) {
    return GestureDetector(
      onTap: () async {
        if (isPasswordReset) {
          AppState appState = GetIt.I.get<AppState>();

          AuthProvider authProvider = sl();
          authProvider.fromProfileScreen = true;
          OtpProvider otpProvider = sl();

          otpProvider.canResend = false;
          await authProvider.findAccount();
          otpProvider.otpResetType=OtpResetType.resetPassword;

          appState.currentAction = PageAction(
            state: PageState.addPage,
            page: PageConfigs.resetPasswordOtpScreenPageConfig,
          );
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        decoration: const BoxDecoration(
            border:
                Border(bottom: BorderSide(color: Colors.black26, width: 1))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16.sp),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    value,
                    style: TextStyle(color: Colors.black26, fontSize: 16.sp),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  if (isPasswordReset)
                    const Icon(
                      Icons.keyboard_arrow_right_outlined,
                      color: Colors.black26,
                    )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
