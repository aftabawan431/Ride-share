import 'package:flutter/material.dart';
import '../../../../../core/utils/constants/app_assets.dart';
import '../../../../../core/utils/globals/globals.dart';
import '../../../../../core/widgets/back_aerro_button.dart';
import '../../../../../core/widgets/custom/continue_button.dart';
import '../../../../../core/widgets/custom/custom_form_field.dart';
import '../providers/auth_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';


class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({Key? key}) : super(key: key);

  final AuthProvider _authProvider = sl();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider.value(value: _authProvider),
    ], child: ResetPasswordScreenContent());
  }
}

class ResetPasswordScreenContent extends StatefulWidget {
  ResetPasswordScreenContent({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreenContent> createState() => _ResetPasswordScreenContentState();
}

class _ResetPasswordScreenContentState extends State<ResetPasswordScreenContent> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(mounted){
      context.read<AuthProvider>().resetResetPasswordController();
    }
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
                            'Reset password',
                            style: Theme.of(context).textTheme.headline4,
                          ),

                          CustomTextFormField(
                            hintText: 'Enter Password',
                            labelText: 'Password',
                            maxLines: 1,
                            isPassword: true,
                            validator: (value){
                              if(value!.isEmpty){
                                return 'Please enter password';
                              }
                              if(value.length<8){
                                return 'Password must have atleast 8 characters';
                              }
                              return null;
                            },
                            controller: context
                                .read<AuthProvider>()
                                .resetPasswordController,
                            focusNode: context
                                .read<AuthProvider>()
                                .resetPasswordFocusNode,
                            onChanged: (value){
                              if(value.length>8){
                                _formKey.currentState!.validate();
                              }
                            },
                            onFieldSubmitted: (value){
                              FocusScope.of(context).requestFocus(context
                                  .read<AuthProvider>()
                                  .resetConfirmPasswordFocusNode);
                            },

                            textInputAction: TextInputAction.next,
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          CustomTextFormField(
                            hintText: 'Enter Password',
                            labelText: 'Confirm Password',
                            maxLines: 1,
                            isPassword: true,
                            onChanged: (value){
                              _formKey.currentState!.validate();
                            },
                            validator: (value){
                              if(value!.isEmpty){
                                return 'Please enter password';
                              }

                              if(value.length<8){
                                return 'Password must have atleast 8 characters';
                              }
                              if(value!=context
                                  .read<AuthProvider>()
                                  .resetPasswordController.text){
                                return "Password doesn't match";
                              }
                              return null;
                            },
                            controller: context
                                .read<AuthProvider>()
                                .resetConfirmPasswordController,
                            focusNode: context
                                .read<AuthProvider>()
                                .resetConfirmPasswordFocusNode,
                            textInputAction: TextInputAction.done,
                          ),

                          SizedBox(
                            height: 10.h,
                          ),
                          ContinueButton(
                              loadingNotifier:
                              context.read<AuthProvider>().resetPasswordLoading,
                              text: 'Reset',
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<AuthProvider>().resetPassword();
                                  FocusScope.of(context).unfocus();
                                }



                              }),
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
}
