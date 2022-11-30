import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rideshare/core/utils/validators/form_validator.dart';
import 'package:flutter_rideshare/core/widgets/bottom_sheets/custom_datetime_picker.dart';
import 'package:flutter_rideshare/core/widgets/custom/continue_button.dart';
import 'package:flutter_rideshare/core/widgets/custom/custom_dropdown_field.dart';
import 'package:flutter_rideshare/core/widgets/custom/custom_form_field.dart';
import 'package:flutter_rideshare/core/widgets/custom_column_appbar.dart';
import 'package:flutter_rideshare/features/wallet/presentation/manager/wallet_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/globals/globals.dart';
import '../../../authentication/auth_wrapper/presentation/providers/auth_provider.dart';

class CreateZindigiAccountScreen extends StatelessWidget {
  CreateZindigiAccountScreen({Key? key}) : super(key: key);
  final WalletProvider walletProvider = sl();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: walletProvider, child: const CreateZindigiAccountScreenContent());
  }
}

class CreateZindigiAccountScreenContent extends StatefulWidget {
  const CreateZindigiAccountScreenContent({Key? key}) : super(key: key);

  @override
  State<CreateZindigiAccountScreenContent> createState() =>
      _CreateZindigiAccountScreenContentState();
}

class _CreateZindigiAccountScreenContentState
    extends State<CreateZindigiAccountScreenContent> {
  TextEditingController cnicController = TextEditingController();
  TextEditingController cnicIssueDateController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  String? selectedMobileNetwork;

  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    context.read<WalletProvider>().getSimProviders();
    AuthProvider authProvider = sl();
    cnicController.text = authProvider.currentUser!.cnic.toString();
    mobileNumberController.text = authProvider.currentUser!.mobile.toString();
  }

  @override
  void dispose() {
    super.dispose();
    cnicController.dispose();
    mobileNumberController.dispose();
    cnicIssueDateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ValueListenableBuilder<bool>(
            valueListenable:
                context.read<WalletProvider>().getSimProvidersLoading,
            builder: (_, loading, __) {
              return loading
                  ? const Center(
                      child:  CircularProgressIndicator(),
                    )
                  : Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const CustomColumnAppBar(title: 'Zindigi Account'),
                          SizedBox(
                            height: 30.h,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.w),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomTextFormField(
                                    readOnly: true,
                                    controller: cnicController,
                                    hintText: 'Enter CNIC',
                                    labelText: 'CNIC'),
                                CustomTextFormField(
                                  readOnly: true,
                                  controller: cnicIssueDateController,
                                  hintText: 'Select',
                                  labelText: 'Issue Date',
                                  validator: FormValidators.validateIssuance,
                                  onTap: () async {
                                    CustomDatetimePIcker customDatePicker =
                                        CustomDatetimePIcker(
                                            context: context,
                                            mode: CupertinoDatePickerMode.date,
                                            maxDate: DateTime.now(),
                                            initialDate: DateTime.now()
                                                .subtract(
                                                    const Duration(minutes: 30)));
                                    final response =
                                        await customDatePicker.show();
                                    if (response != null) {
                                      cnicIssueDateController.text =
                                          DateFormat('yyyy-MM-dd')
                                              .format(response);
                                    }
                                  },
                                ),
                                CustomTextFormField(
                                    readOnly: true,
                                    controller: mobileNumberController,
                                    hintText: 'Select',
                                    labelText: 'Mobile Number'),
                                CustomDropDown(
                                  hintText: 'Select',
                                  labelText: 'Mobile Network',
                                  validator: FormValidators.validateNetwork,
                                  items: context
                                      .read<WalletProvider>()
                                      .getSimProvidersResponseModel!
                                      .data
                                      .map((e) => e.value)
                                      .toList(),
                                  onChanged: (value) {
                                    Logger().v(value);
                                    selectedMobileNetwork = value;
                                  },
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                ContinueButton(
                                    loadingNotifier: context
                                        .read<WalletProvider>()
                                        .accountLoading,
                                    text: 'Create',
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        context
                                            .read<WalletProvider>()
                                            .createZindigiAccount(
                                                cnicIssuanceDate:
                                                    cnicIssueDateController
                                                        .text,
                                                mobileNetwork:
                                                    selectedMobileNetwork!);
                                      }
                                    })
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
            }),
      ),
    );
  }
}
