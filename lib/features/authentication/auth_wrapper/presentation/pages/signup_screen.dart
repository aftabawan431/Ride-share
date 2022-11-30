import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/utils/constants/app_assets.dart';
import '../../../../../core/utils/globals/globals.dart';
import '../../../../../core/utils/validators/form_validator.dart';
import '../../../../../core/widgets/back_aerro_button.dart';
import '../../../../../core/widgets/custom/continue_button.dart';
import '../../../../../core/widgets/custom/custom_form_field.dart';
import '../providers/auth_provider.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({Key? key}) : super(key: key);
  final AuthProvider _authProvider = sl();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider.value(value: _authProvider),
    ], child: const SignupScreenContent());
  }
}

class SignupScreenContent extends StatefulWidget {
  const SignupScreenContent({Key? key}) : super(key: key);

  @override
  State<SignupScreenContent> createState() => _SignupScreenContentState();
}

class _SignupScreenContentState extends State<SignupScreenContent> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<AuthProvider>().resetSignUpFields();
    context.read<AuthProvider>().registerLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<AuthProvider>();
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
            DraggableScrollableSheet(
                initialChildSize: .75,
                maxChildSize: .9,
                builder:
                    (BuildContext context, ScrollController scrollController) {
                  return Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 20.w),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12,
                              spreadRadius: 2,
                              blurRadius: 2)
                        ]),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 20.h),
                      child: Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Text(
                                'Sign Up',
                                style: Theme.of(context).textTheme.headline4,
                              ),
                              CustomTextFormField(
                                hintText: 'Enter first name',
                                labelText: 'First Name',
                                maxLength: 20,
                                inputFormatters: [
                                  FilteringTextInputFormatter.deny(
                                      RegExp(regexToRemoveEmoji))
                                ],
                                maxLengthEnforced: true,
                                controller:
                                    provider.registerFirstNameController,
                                validator: FormValidators.validateName,
                                focusNode: provider.registerFirstNameFocusNode,
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (value) {
                                  FocusScope.of(context).requestFocus(
                                      provider.registerLastNameFocusNode);
                                },
                              ),
                              CustomTextFormField(
                                hintText: 'Enter last name',
                                labelText: 'Last Name',
                                inputFormatters: [
                                  FilteringTextInputFormatter.deny(
                                      RegExp(regexToRemoveEmoji))
                                ],
                                maxLength: 20,
                                maxLengthEnforced: true,
                                controller: context
                                    .read<AuthProvider>()
                                    .registerLastNameController,
                                validator: FormValidators.validateName,
                                focusNode: provider.registerLastNameFocusNode,
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (value) {
                                  FocusScope.of(context).requestFocus(
                                      provider.registerPhoneFocusNode);
                                },
                              ),

                              CustomTextFormField(
                                hintText: '0300-0000000',
                                labelText: 'Mobile Number',
                                prefixIconPath: AppAssets.pakistanPng,
                                controller: provider.registerPhoneController,
                                focusNode: provider.registerPhoneFocusNode,
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (value) {
                                  FocusScope.of(context).requestFocus(
                                      provider.registerEmailFocusNode);
                                },
                                validator: FormValidators.validatePhone,
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

                              CustomTextFormField(
                                hintText: 'Enter Email',
                                labelText: 'Email',
                                maxLength: 40,
                                maxLengthEnforced: true,
                                controller: context
                                    .read<AuthProvider>()
                                    .registerEmailController,
                                focusNode: context
                                    .read<AuthProvider>()
                                    .registerEmailFocusNode,
                                validator: FormValidators.validateEmail,
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (value) {
                                  FocusScope.of(context).requestFocus(
                                      provider.registerCnicFocusNode);
                                },
                              ),
                              CustomTextFormField(
                                hintText: 'Enter CNIC',
                                labelText: 'CNIC',
                                maxLengthEnforced: true,
                                maxLength: 13,
                                keyboardType: TextInputType.number,
                                controller: context
                                    .read<AuthProvider>()
                                    .registerCnicController,
                                focusNode: context
                                    .read<AuthProvider>()
                                    .registerCnicFocusNode,
                                onFieldSubmitted: (value) =>
                                    FocusScope.of(context).requestFocus(context
                                        .read<AuthProvider>()
                                        .registerPasswordFocusNode),
                                validator: FormValidators.validateCnic,
                                textInputAction: TextInputAction.next,
                              ),
                              // CustomDropDown(
                              //   hintText: 'Select',
                              //   labelText: 'Gender',
                              //   validator: (value) {
                              //     if (value == null) {
                              //       return "Please choose a gender";
                              //     }
                              //     return null;
                              //   },
                              //   items: const ['Male', "Female"],
                              //   value:
                              //       context.read<AuthProvider>().registerGender,
                              //   onChanged: (value) {
                              //     context.read<AuthProvider>().registerGender =
                              //         value!;
                              //   },
                              // ),
                              CustomTextFormField(
                                obscureText: true,
                                maxLines: 1,
                                minLines: 1,
                                maxLength: 20,
                                maxLengthEnforced: true,
                                hintText: 'Enter Password',
                                labelText: 'Password',
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (value) =>
                                    FocusScope.of(context).requestFocus(context
                                        .read<AuthProvider>()
                                        .registerConfirmPasswordFocusNode),
                                isPassword: true,
                                focusNode: context
                                    .read<AuthProvider>()
                                    .registerPasswordFocusNode,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: FormValidators.validateLoginPassword,
                                controller: context
                                    .read<AuthProvider>()
                                    .registerPasswordController,
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              CustomTextFormField(
                                obscureText: true,
                                maxLines: 1,
                                minLines: 1,
                                maxLength: 20,
                                focusNode: context
                                    .read<AuthProvider>()
                                    .registerConfirmPasswordFocusNode,
                                maxLengthEnforced: true,
                                hintText: 'Enter Password',
                                labelText: 'Confirm Password',
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (value) =>
                                    FocusScope.of(context).requestFocus(context
                                        .read<AuthProvider>()
                                        .registerInviteCodeFocusNode),
                                isPassword: true,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Confirm password is empty';
                                  }
                                  if (value !=
                                      context
                                          .read<AuthProvider>()
                                          .registerPasswordController
                                          .text) {
                                    return "Password doesn't match";
                                  }
                                  return null;
                                },
                                controller: context
                                    .read<AuthProvider>()
                                    .registerConfirmPasswordController,
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              CustomTextFormField(
                                maxLines: 1,
                                minLines: 1,
                                maxLength: 11,
                                maxLengthEnforced: true,
                                hintText: 'CTAK-',
                                labelText: 'Enter Invite Code',
                                textInputAction: TextInputAction.done,
                                focusNode: context
                                    .read<AuthProvider>()
                                    .registerInviteCodeFocusNode,
                                onFieldSubmitted: (value) =>
                                    FocusScope.of(context).requestFocus(context
                                        .read<AuthProvider>()
                                        .corporateCodeFocusNode),
                                isPassword: false,
                                inputFormatters: [
                                  MaskTextInputFormatter(
                                    mask: "CTAK-######",
                                    filter: {"#": RegExp(r'\w')},
                                  ),
                                  FilteringTextInputFormatter.deny(
                                      RegExp(regexToRemoveEmoji))
                                ],
                                controller: context
                                    .read<AuthProvider>()
                                    .registerInviteCodeController,
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              CustomTextFormField(
                                maxLines: 1,
                                minLines: 1,
                                maxLength: 11,
                                maxLengthEnforced: true,
                                hintText: 'xxxx-xxxxxx',
                                labelText: 'Enter Corporate Code',
                                textInputAction: TextInputAction.done,
                                focusNode: context
                                    .read<AuthProvider>()
                                    .corporateCodeFocusNode,
                                validator: FormValidators.validateCorporateCode,
                                isPassword: false,
                                inputFormatters: [
                                  MaskTextInputFormatter(
                                    mask: "####-#######",
                                    filter: {
                                      "#": RegExp(r'\w'),
                                      // "#": RegExp(r'[a-zA-Z]'),
                                    },
                                  ),
                                  FilteringTextInputFormatter.deny(
                                      RegExp(regexToRemoveEmoji))
                                ],
                                controller: context
                                    .read<AuthProvider>()
                                    .corporateCodeController,
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              ContinueButton(
                                  loadingNotifier: context
                                      .read<AuthProvider>()
                                      .registerLoading,
                                  text: 'Sign Up',
                                  onPressed: _signupTap),
                              SizedBox(
                                height: 10.h,
                              ),
                              _bottomTermsPolicyWidget()
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }

  //methods
  _signupTap() {
    if (_formKey.currentState!.validate()) {
      if (!context.read<AuthProvider>().validateRegisterOthers()) {
        FocusScope.of(context).unfocus();
        context.read<AuthProvider>().registerUser();
      }
    }
  }

  //widgets
  Widget _bottomTermsPolicyWidget() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5.h),
        child: Wrap(
          children: [
            Text(
              "By clicking start, you agree to our ",
              style: TextStyle(fontSize: 10.sp),
            ),
            GestureDetector(
              onTap: () async {
                const url = "https://www.ctairkib.com/Term&conditions";
                final uri = Uri.parse(url);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri);
                } else {}
              },
              child: Text(
                "Terms and Conditions",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10.sp),
              ),
            ),
            Text(
              " , ",
              style: TextStyle(fontSize: 10.sp),
            ),
            GestureDetector(
              onTap: () async {
                const url = "https://www.ctairkib.com/Privacy&Policy";
                final uri = Uri.parse(url);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri);
                } else {}
              },
              child: Text(
                "Privacy Policy",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
