import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rideshare/core/utils/extension/extensions.dart';
import 'package:flutter_rideshare/core/utils/theme/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField(
      {required this.hintText,
      required this.labelText,
      this.obscureText = false,
      this.readOnly = false,
      this.controller,
      this.keyboardType,
      this.inputFormatters,
      this.focusNode,
      this.onFieldSubmitted,
      this.onChanged,
      this.validator,
      this.maxLines,
      this.enabled,
      this.contentPadding,
      this.prefixIconPath,
      this.suffixIconPath,
      this.suffixIconOnTap,
      this.onTap,
      this.suffix,
      this.prefix,
      this.networkPrefix = false,
      this.interactiveSelection = true,
      this.maxLength,
      this.minLength,
      this.maxLengthEnforced,
      this.minLines,
      this.textInputAction,
      Key? key,
      this.isPassword = false,
      this.autovalidateMode})
      : super(key: key);

  final String hintText;
  final String labelText;
  final bool obscureText;
  final bool readOnly;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final TextEditingController? controller;
  final Function(String)? onFieldSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final int? minLength;
  final bool? maxLengthEnforced;
  final bool? enabled;
  final EdgeInsets? contentPadding;
  final String? prefixIconPath;
  final String? suffixIconPath;
  final Function()? suffixIconOnTap;
  final Function()? onTap;
  final Widget? prefix;
  final Widget? suffix;
  final bool networkPrefix;
  final bool interactiveSelection;
  final TextInputAction? textInputAction;
  final AutovalidateMode? autovalidateMode;
  bool isPassword;
  ValueNotifier<bool> obscurePasswod = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (labelText.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                labelText,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ValueListenableBuilder<bool>(
            valueListenable: obscurePasswod,
            builder: (_, obscure, __) {
              return TextFormField(
                autovalidateMode: autovalidateMode,
                enableInteractiveSelection: interactiveSelection,
                readOnly: readOnly,
                enabled: enabled,
                obscureText: isPassword ? obscure : false,
                obscuringCharacter: '●',
                controller: controller,
                keyboardType: keyboardType,
                inputFormatters: inputFormatters,
                focusNode: focusNode,
                onFieldSubmitted: onFieldSubmitted,
                onChanged: onChanged,
                cursorHeight: 20,
                maxLines: maxLines,
                minLines: minLines,
                textInputAction: textInputAction,
                maxLength: maxLength,
                maxLengthEnforcement: maxLengthEnforced == true
                    ? MaxLengthEnforcement.enforced
                    : MaxLengthEnforcement.none,
                onTap: onTap,
                style: GoogleFonts.openSans(
                  color: const Color(0xFF000812),
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.25,
                ),
                decoration: InputDecoration(
                  counterText: "",
                  filled: false,
                  fillColor: Theme.of(context).scaffoldBackgroundColor,
                  hintText: hintText,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                          width: 1, color: Colors.grey.withOpacity(.8))),
                  focusedBorder: OutlineInputBorder(

                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                          width: 1, color: AppTheme.appTheme.primaryColor)),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                          width: 1, color: Colors.redAccent)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                          width: 1, color: Colors.grey.withOpacity(.8))),
                  focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                          width: 1, color:Colors.redAccent)),
                  suffixIcon: suffixIconPath == null
                      ? null
                      : GestureDetector(
                          onTap: suffixIconOnTap,
                          child: Transform.translate(
                            offset: Offset(0, -1.h),
                            child: Padding(
                              padding: EdgeInsets.only(right: 16.w),
                              child: SvgPicture.asset(suffixIconPath!,color: AppTheme.appTheme.primaryColor,),
                            ),
                          ),
                        ),
                  prefixIcon: prefixIconPath == null
                      ? null
                      : prefixIconPath!.ext == 'svg'
                          ? SvgPicture.asset(
                              prefixIconPath!,
                              height: 30.sp,
                              width: 30.sp,
                            )
                          : Image.asset(
                              prefixIconPath!,
                              height: 40.sp,
                              width: 40.sp,
                            ),
                  prefixIconConstraints:
                      BoxConstraints(minWidth: 24.w, minHeight: 24.w),
                  suffixIconConstraints:
                      BoxConstraints(minWidth: 24.w, minHeight: 24.w),
                  suffix:suffix!=null?suffix: isPassword
                      ? GestureDetector(
                          onTap: () {
                            obscurePasswod.value = !obscurePasswod.value;
                          },
                          child: Icon(
                            obscure ? Icons.visibility : Icons.visibility_off,
                          ),
                        )
                      : null,
                  prefix: prefix,
                ),
                validator: validator,
              );
            }),
      ],
    );
  }
}
