import 'package:flutter/material.dart';
import 'package:flutter_rideshare/core/utils/constants/app_url.dart';
import 'package:flutter_rideshare/core/widgets/custom/custom_form_field.dart';
import 'package:flutter_rideshare/core/widgets/modals/confirm_ride_modal.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../../../../../core/router/app_state.dart';
import '../../../../../core/router/models/page_action.dart';
import '../../../../../core/router/models/page_config.dart';
import '../../../../../core/router/pages.dart';
import '../../../../../core/utils/constants/app_assets.dart';
import '../../../../../core/utils/enums/button_type.dart';
import '../../../../../core/utils/enums/page_state_enum.dart';
import '../../../../../core/utils/enums/user_type.dart';
import '../../../../../core/utils/globals/globals.dart';
import '../../../../../core/widgets/custom/continue_button.dart';
import '../../../../../core/widgets/modals/confirmation_dialog.dart';
import '../../../auth_wrapper/presentation/providers/auth_provider.dart';

class SelectUserScreen extends StatelessWidget {
  const SelectUserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SelectUserScreenContent();
  }
}

class SelectUserScreenContent extends StatelessWidget {
  const SelectUserScreenContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 380.h,
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SvgPicture.asset(AppAssets.illustrationImg1Svg)),
            ),
            Expanded(
                child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Hi, let's Ride together and save fuel",
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    "Choose one of the following options and we can get started really quick.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Theme.of(context).canvasColor),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  ContinueButton(
                    text: 'Sign Up as $USER_TITLE',
                    icon: AppAssets.vectorSvg,
                    onPressed: _signupDriverTap,
                    buttonType: ButtonType.Bordered,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  ContinueButton(
                    text: 'Sign Up as Passenger',
                    icon: AppAssets.signUpPassengerSvg,
                    onPressed: _signupPassengerTap,
                    buttonType: ButtonType.Bordered,
                  ),
                  ContinueButton(
                    text: 'Sign In',
                    onPressed: _signInTap,
                    buttonType: ButtonType.Text,
                  ),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }

  _signupPassengerTap() async {
    AuthProvider authProvider = sl();
    authProvider.userType = UserType.passenger;
    goToNext(PageConfigs.signupPageConfig);
  }

  _signupDriverTap() async {
    AuthProvider authProvider = sl();
    authProvider.userType = UserType.driver;
    goToNext(PageConfigs.signupPageConfig);
  }

  _signInTap() async {
    AppState appState = sl();
    await appState.goToNext(PageConfigs.signinPageConfig, wait: true);
  }

  goToNext(PageConfiguration pageConfigs) {
    AppState appState = GetIt.I.get<AppState>();
    appState.currentAction = PageAction(
      state: PageState.addPage,
      page: pageConfigs,
    );
  }

  void showIpChangeDialog() {
    var controller=TextEditingController();
    controller.text=AppUrl.baseUrl;
    showDialog(
        context: navigatorKeyGlobal.currentContext!,
        builder: (context) => Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTextFormField(hintText: 'Ip', labelText: 'Ip',controller: controller,),
                ContinueButton(text: 'Save', onPressed: (){
                  AppUrl.baseUrl=controller.text;
                  AppUrl.fileBaseUrl=controller.text;
                  Navigator.of(context).pop();

        })
                ],
              ),
            ));
  }
}
