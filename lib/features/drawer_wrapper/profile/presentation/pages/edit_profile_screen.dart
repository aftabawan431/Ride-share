import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rideshare/core/router/app_state.dart';
import 'package:flutter_rideshare/core/router/models/page_action.dart';
import 'package:flutter_rideshare/core/router/models/page_config.dart';
import 'package:flutter_rideshare/core/utils/constants/app_assets.dart';
import 'package:flutter_rideshare/core/utils/enums/otp_reset_enum.dart';
import 'package:flutter_rideshare/core/utils/enums/page_state_enum.dart';
import 'package:flutter_rideshare/core/widgets/custom_column_appbar.dart';
import 'package:flutter_rideshare/features/authentication/auth_wrapper/presentation/providers/otp_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

import '../../../../../core/utils/constants/app_url.dart';
import '../../../../../core/utils/globals/globals.dart';
import '../../../../../core/utils/globals/snake_bar.dart';
import '../../../../../core/utils/validators/form_validator.dart';
import '../../../../../core/widgets/back_aerro_button.dart';
import '../../../../../core/widgets/bottom_sheets/choose_image_bottom_sheet.dart';
import '../../../../../core/widgets/bottom_sheets/custom_datetime_picker.dart';
import '../../../../../core/widgets/custom/continue_button.dart';
import '../../../../../core/widgets/custom/custom_dropdown_field.dart';
import '../../../../../core/widgets/custom/custom_form_field.dart';
import '../../../../authentication/auth_wrapper/presentation/providers/auth_provider.dart';

// ignore: must_be_immutable
class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({Key? key}) : super(key: key);
  AuthProvider authProvider = sl();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [ChangeNotifierProvider.value(value: authProvider)],
        child: const EditProfileScreenContent());
  }
}

class EditProfileScreenContent extends StatefulWidget {
  const EditProfileScreenContent({Key? key}) : super(key: key);

  @override
  State<EditProfileScreenContent> createState() =>
      _EditProfileScreenContentState();
}

class _EditProfileScreenContentState extends State<EditProfileScreenContent> {
  final GlobalKey<FormState> key = GlobalKey();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<AuthProvider>().setEditValues();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const CustomColumnAppBar(title: 'Profile Setting'),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Consumer<AuthProvider>(builder: (context, provider, ch) {
                  return Form(
                    key: key,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 20.h,
                        ),

                        ValueListenableBuilder<bool>(
                            valueListenable: provider.updateProfileImageLoading,
                            builder: (_, profileImageloading, __) {
                              return GestureDetector(
                                onTap: () async {
                                  ChooseImageBottomSheet bottomSheet =
                                      ChooseImageBottomSheet(context: context);
                                  final image = await bottomSheet.show();
                                  if (image != null) {
                                    provider.updateProfileImage(image);
                                  }
                                },
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    provider.currentUser!.profileImage.isEmpty
                                        ? CircleAvatar(
                                            radius: 50.r,
                                          )
                                        : CircleAvatar(
                                            radius: 50.r,
                                            backgroundImage: NetworkImage(
                                                AppUrl.fileBaseUrl +
                                                    provider.currentUser!
                                                        .profileImage),
                                          ),
                                    if (profileImageloading)
                                      const Center(
                                        child: CircularProgressIndicator
                                            .adaptive(),
                                      )
                                  ],
                                ),
                              );
                            }),
                        SizedBox(
                          height: 10.h,
                        ),
                        GestureDetector(
                          onTap: () async {
                            // var status = await Permission.storage.status;
                            // Logger().v(status);
                            // if(status.isDenied){
                            //   await Permission.storage.request();
                            // }

                            // if(provider.updateProfileImageLoading.value){
                            //   return;
                            // }
                            ChooseImageBottomSheet bottomSheet =
                                ChooseImageBottomSheet(context: context);
                            final image = await bottomSheet.show();
                            if (image != null) {
                              provider.updateProfileImage(image);
                            }
                          },
                          child: Text(
                            "Upload Photo",
                            style: TextStyle(
                                fontSize: 12.sp, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        CustomTextFormField(
                          hintText: 'Enter Name',
                          labelText: 'First Name',
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(
                                RegExp(regexToRemoveEmoji))
                          ],
                          validator: FormValidators.validateName,
                          controller: context
                              .read<AuthProvider>()
                              .registerFirstNameController,
                          focusNode: context
                              .read<AuthProvider>()
                              .updateFirstNameFocusNode,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (value) => FocusScope.of(context)
                              .requestFocus(context
                                  .read<AuthProvider>()
                                  .updateLastNameFocusNode),
                        ),
                        CustomTextFormField(
                          hintText: 'Enter Name',
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(
                                RegExp(regexToRemoveEmoji))
                          ],
                          labelText: 'Last Name',
                          validator: FormValidators.validateName,
                          textInputAction: TextInputAction.next,
                          focusNode: context
                              .read<AuthProvider>()
                              .updateLastNameFocusNode,
                          controller: context
                              .read<AuthProvider>()
                              .registerLastNameController,
                          onFieldSubmitted: (value) => FocusScope.of(context)
                              .requestFocus(context
                                  .read<AuthProvider>()
                                  .udpateDOBFocusNode),
                        ),

                        CustomTextFormField(
                          hintText: 'Select',
                          labelText: 'Date of Birth',
                          validator: FormValidators.birthdayValidator,
                          controller:
                              context.read<AuthProvider>().dobController,
                          focusNode:
                              context.read<AuthProvider>().udpateDOBFocusNode,
                          textInputAction: TextInputAction.done,
                          readOnly: true,
                          suffix: const Icon(
                            Icons.calendar_today_outlined,
                            color: Colors.black26,
                          ),
                          onTap: () async {
                            final bottomSheet = CustomDatetimePIcker(
                                context: context,
                                initialDate: DateTime.now()
                                    .subtract(const Duration(days: 6573)),
                                mode: CupertinoDatePickerMode.date,
                                maxDate: DateTime.now()
                                    .subtract(const Duration(days: 6573))
                                    .add(const Duration(hours: 2)));
                            final result = await bottomSheet.show();
                            if (result != null) {
                              context.read<AuthProvider>().dobController.text =
                                  DateFormat('dd-MM-yyyy').format(result);
                            }
                          },
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
                              .updateCorporateCodeFocusNode,
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
                              .updateCorporateCodeController,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),

                        // Container(
                        //   padding: EdgeInsets.symmetric(
                        //       horizontal: 10.w, vertical: 0.h),
                        //   decoration: BoxDecoration(
                        //       border: Border.all(
                        //           width: 1, color: Colors.grey.withOpacity(.8)),
                        //       borderRadius: BorderRadius.circular(5.r)),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       Text(
                        //         "Use corporate code",
                        //         style: Theme.of(context)
                        //             .textTheme
                        //             .bodyText2
                        //             ?.copyWith(fontWeight: FontWeight.w800),
                        //       ),
                        //       Checkbox(
                        //           value: provider.corporateCodeStatus,
                        //           onChanged: (value) {
                        //             provider.corporateCodeStatus = value!;
                        //             provider.callNotifi();
                        //           })
                        //     ],
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: 10.h,
                        // ),
                        CustomTextFormField(
                          hintText: '',
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(
                                RegExp(regexToRemoveEmoji))
                          ],

                          labelText: 'Mobile',
                          // contentPadding: EdgeInsets.,
                          // validator: FormValidators.validateName,
                          textInputAction: TextInputAction.next,
                          enabled: true,
                          readOnly: true,
                          // focusNode: context.read<AuthProvider>().updateLastNameFocusNode,

                          controller:
                              context.read<AuthProvider>().profileMobileNumber,
                          onFieldSubmitted: (value) => FocusScope.of(context)
                              .requestFocus(context
                                  .read<AuthProvider>()
                                  .udpateDOBFocusNode),
                          // suffix:SizedBox(
                          //   height: 30.sp,
                          //   child: IconButton(
                          //       onPressed: () {
                          //         AuthProvider authProvider = sl();
                          //         authProvider.isFindAccount = false;
                          //         authProvider.isFindAccount = false;
                          //         OtpProvider otpProvider = sl();
                          //         otpProvider.otpResetType =
                          //             OtpResetType.updateMobile;
                          //         AppState appState = sl();
                          //         appState.goToNext(PageConfigs
                          //             .findAccountScreenPageConfig);
                          //       },
                          //       icon: Icon(
                          //         Icons.edit_outlined,
                          //         color: Theme.of(context).primaryColor,
                          //       )),
                          // ) ,

                          suffixIconOnTap: () async {
                            print('hello');
                            AuthProvider authProvider = sl();
                            authProvider.isFindAccount = false;
                            authProvider.isFindAccount = false;
                            OtpProvider otpProvider = sl();
                            otpProvider.otpResetType =
                                OtpResetType.updateMobile;
                            AppState appState = sl();
                            appState.goToNext(
                                PageConfigs.findAccountScreenPageConfig);
                          },
                          suffixIconPath: AppAssets.editBlankSvg,
                        ),

                        // const CustomTextFormField(
                        //     hintText: '+9211111111', labelText: 'Phone Number'),
                        SizedBox(
                          height: 20.h,
                        ),
                        ContinueButton(
                            loadingNotifier: provider.updateProfileLoading,
                            text: 'Update',
                            onPressed: () {

                              FocusScope.of(context).unfocus();

                              if (key.currentState!.validate()) {
                                if (provider.isDataChanged()) {

                                  provider.updateProfile();
                                  // ShowSnackBar.show('Data changed');
                                } else {
                                  ShowSnackBar.show(
                                      'Please update something first!');
                                }
                              }
                            }),
                        SizedBox(
                          height: 20.h,
                        ),
                      ],
                    ),
                  );
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
