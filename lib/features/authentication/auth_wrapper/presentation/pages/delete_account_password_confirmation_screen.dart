import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../core/utils/globals/globals.dart';
import '../../../../../core/utils/validators/form_validator.dart';
import '../../../../../core/widgets/custom/continue_button.dart';
import '../../../../../core/widgets/custom/custom_form_field.dart';
import '../../../../../core/widgets/custom_column_appbar.dart';
import '../providers/auth_provider.dart';

// ignore: must_be_immutable
class DeleteAccountPasswordConfirmationScreen extends StatelessWidget {
   DeleteAccountPasswordConfirmationScreen({Key? key}) : super(key: key);
  AuthProvider authProvider=sl();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: authProvider,
        child: _DeleteAccountPasswordConfirmationScreenContent());
  }
}

class _DeleteAccountPasswordConfirmationScreenContent extends StatelessWidget {
  final _passwordController=TextEditingController();
  final GlobalKey<FormState> _formKey=GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CustomColumnAppBar(title: 'Delete Account'),
            SizedBox(

              height: 20.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomTextFormField(
                      validator: FormValidators.validateLoginPassword,
                        hintText: 'Enter Password', labelText: 'Password',isPassword: true,maxLines: 1,
                    controller: _passwordController,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    ContinueButton(
                        loadingNotifier: context.read<AuthProvider>().deleteAccountLoading ,
                        text: 'Submit', onPressed: () {
                      if(_formKey.currentState!.validate()){
                        context.read<AuthProvider>().deleteAccount(_passwordController.text);

                      }
                    })
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
