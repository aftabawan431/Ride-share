import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../../../../core/widgets/back_aerro_button.dart';
import '../../../../../core/widgets/custom/custom_form_field.dart';
import '../providers/auth_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../../../core/utils/constants/app_assets.dart';
import '../../../../../core/utils/globals/globals.dart';
import '../../../../../core/utils/validators/form_validator.dart';
import '../../../../../core/widgets/custom/continue_button.dart';

/// This screen will be used to find account on a phone number for resetting password or changing phone
class FindAccountScreen extends StatelessWidget {
  final AuthProvider authProvider = sl();
  FindAccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: authProvider, child: FindAccountScreenContent());
  }
}

class FindAccountScreenContent extends StatefulWidget {
  FindAccountScreenContent({Key? key}) : super(key: key);

  @override
  State<FindAccountScreenContent> createState() =>
      _FindAccountScreenContentState();
}

class _FindAccountScreenContentState extends State<FindAccountScreenContent> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  AuthProvider authProvider = sl();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<AuthProvider>().clearFindAccountController();
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
                padding: EdgeInsets.all(70.r),
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
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Text(
                            authProvider.isFindAccount
                                ? 'Find account'
                                : 'Mobile number',
                            style: Theme.of(context).textTheme.headline4,
                          ),
                          CustomTextFormField(
                            hintText: '0300-0000000',
                            labelText: 'Mobile Number',
                            prefixIconPath: AppAssets.pakistanPng,
                            controller: context
                                .read<AuthProvider>()
                                .findAccountController,
                            validator: FormValidators.validatePhone,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              MaskTextInputFormatter(
                                mask: "####-#######",
                                filter: {"#": RegExp(r'^\d+$')},
                              ),
                              FilteringTextInputFormatter.deny(
                                  RegExp(regexToRemoveEmoji))
                            ],
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          ContinueButton(
                              loadingNotifier:
                                  context.read<AuthProvider>().isFindAccount
                                      ? context
                                          .read<AuthProvider>()
                                          .findAccountLoading
                                      : context
                                          .read<AuthProvider>()
                                          .newNumberAvailbleCheckLoading,
                              text: 'Next',
                              onPressed: _nextTap),
                          SizedBox(
                            height: 10.h,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _nextTap() {
    if (_formKey.currentState!.validate()) {
      if (context.read<AuthProvider>().isFindAccount) {
        context.read<AuthProvider>().findAccount();
      } else {
        context.read<AuthProvider>().newNumberAvailbleCheck();
      }
    }
  }
}
