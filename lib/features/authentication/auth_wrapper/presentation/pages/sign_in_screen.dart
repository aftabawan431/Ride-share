import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rideshare/features/authentication/auth_wrapper/presentation/providers/otp_provider.dart';
import 'package:logger/logger.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../../../../core/utils/constants/app_assets.dart';
import '../../../../../core/utils/enums/otp_reset_enum.dart';
import '../../../../../core/utils/globals/globals.dart';
import '../../../../../core/utils/validators/form_validator.dart';
import '../../../../../core/widgets/custom/continue_button.dart';
import '../../../../../core/widgets/custom/custom_form_field.dart';
import '../providers/auth_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../../../../../core/router/app_state.dart';
import '../../../../../core/router/models/page_action.dart';
import '../../../../../core/router/models/page_config.dart';
import '../../../../../core/utils/enums/page_state_enum.dart';
import '../../../../../core/widgets/back_aerro_button.dart';

// ignore: must_be_immutable
class SigninScreen extends StatelessWidget {
  SigninScreen({Key? key}) : super(key: key);

  final AuthProvider _authProvider = sl();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider.value(value: _authProvider),
    ], child: const SigninScreenContent());
  }
}

class SigninScreenContent extends StatefulWidget {
  const SigninScreenContent({Key? key}) : super(key: key);

  @override
  State<SigninScreenContent> createState() => _SigninScreenContentState();
}

class _SigninScreenContentState extends State<SigninScreenContent> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    context.read<AuthProvider>().resetSigninFields();
    context.read<AuthProvider>().loginLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.topCenter,
          children: [
            Positioned(
              height: 250.h,
              top: 0,
              right: 0,
              left: 0,
              child: Container(
                width: double.infinity,
                color: Theme.of(context).primaryColor,
                padding: EdgeInsets.all(90.r),
                child: SvgPicture.asset(AppAssets.logoSvg,color: Colors.white,),
              ),
            ),
            Positioned(top: 20.h, left: 20.w, child: const BackAerroButton()),
            Positioned(
              top: 250.h - 50.h,
              left: 0,
              right: 0,
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black12, spreadRadius: 2, blurRadius: 2)
                    ]),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                  child: _returnForm(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //widgets
  Widget _returnForm() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'Sign In',
              style: Theme.of(context).textTheme.headline4,
            ),
            CustomTextFormField(
              hintText: '0300-0000000',
              labelText: 'Mobile Number',
              prefixIconPath: AppAssets.pakistanPng,
              controller: context.read<AuthProvider>().loginPhoneController,
              focusNode: context.read<AuthProvider>().loginMobileFocusNode,
              onFieldSubmitted: (value) => FocusScope.of(context).requestFocus(
                  context.read<AuthProvider>().loginPasswordFocusNode),
              validator: FormValidators.validatePhone,
              textInputAction: TextInputAction.next,
              onChanged: (value) {},
              keyboardType: TextInputType.number,
              inputFormatters: [
                MaskTextInputFormatter(
                  mask: "####-#######",
                  filter: {"#": RegExp(r'^\d+$')},
                ),
                FilteringTextInputFormatter.deny(RegExp(regexToRemoveEmoji))
              ],
            ),
            CustomTextFormField(
              hintText: 'Enter Password',
              labelText: 'Password',
              maxLines: 1,
              isPassword: true,
              maxLength: 20,
              maxLengthEnforced: true,
              validator: FormValidators.validateLoginPassword,
              controller: context.read<AuthProvider>().loginPasswordController,
              focusNode: context.read<AuthProvider>().loginPasswordFocusNode,
              textInputAction: TextInputAction.done,
            ),
            SizedBox(
              height: 10.h,
            ),
            ContinueButton(
                loadingNotifier: context.read<AuthProvider>().loginLoading,
                text: 'Sign In',
                onPressed: _signinTap),
            SizedBox(
              height: 10.h,
            ),
            TextButton(
                onPressed: _forgotPasswordTap,
                child: const Text("Forgot password?"))
          ],
        ),
      ),
    );
  }

  //functions

  _signinTap() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      context.read<AuthProvider>().loginUser();
    }
  }

  _forgotPasswordTap() {
    AuthProvider authProvider = sl();
    authProvider.isFindAccount = true;
    authProvider.fromProfileScreen = false;
    OtpProvider otpProvider = sl();
    otpProvider.otpResetType = OtpResetType.findAccount;
    AppState appState = GetIt.I.get<AppState>();
    appState.goToNext(PageConfigs.findAccountScreenPageConfig);

  }
}
