import 'package:flutter/material.dart';
import '../../utils/enums/button_type.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

//ignore: must_be_immutable
class ContinueButton extends StatelessWidget {
  ContinueButton(
      {Key? key,
      required this.text,
      required this.onPressed,
      this.loadingNotifier,
      this.isEnabledNotifier,
      this.backgroundColor,
      this.icon,
      this.iconData,
        this.fontSize,

      this.buttonType = ButtonType.Filled})
      : super(key: key);

  final String text;
  final VoidCallback? onPressed;
  final ValueNotifier<bool>? loadingNotifier;
  final Color? backgroundColor;
  final String? icon;
  double? fontSize;
  ValueNotifier<bool>? isEnabledNotifier;
  ButtonType buttonType;
  IconData? iconData;
  @override
  Widget build(BuildContext context) {
    if (loadingNotifier == null) {
      if (buttonType == ButtonType.Filled) {
        return SizedBox(
          height: 50.h,
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // <-- Radius
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (iconData != null)
                  Padding(
                    padding: EdgeInsets.only(right: 5.w),
                    child: Icon(iconData),
                  ),
                if (icon != null)
                  Padding(
                    padding: EdgeInsets.only(right: 5.w),
                    child: Image.asset(icon!),
                  ),
                Text(
                  text,
                  style: Theme.of(context)
                      .textTheme
                      .button
                      ?.copyWith(fontSize:fontSize?? 18.sp),
                ),
              ],
            ),
            onPressed: onPressed,
          ),
        );
      } else if (buttonType == ButtonType.Bordered) {
        return OutlinedButton(
          onPressed: onPressed,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 5.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (iconData != null)
                  Padding(
                    padding: EdgeInsets.only(right: 5.w),
                    child: Icon(
                      iconData,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                if (icon != null)
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: SvgPicture.asset(icon!)),
                Text(
                  text,
                  style: TextStyle(
                      fontSize: 18.sp, color: Theme.of(context).primaryColor),
                ),
              ],
            ),
          ),
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      } else {
        return TextButton(
            onPressed: onPressed,
            child: Text(
              text,
              style: TextStyle(
                  color: Theme.of(context).errorColor,
                  fontWeight: FontWeight.bold),
            ));
      }
    }

    isEnabledNotifier ??= ValueNotifier(true);
    if (buttonType == ButtonType.Filled) {
      return ValueListenableBuilder<bool>(
        valueListenable: isEnabledNotifier!,
        builder: (context, isEnabled, child) {
          return ValueListenableBuilder<bool>(
            valueListenable: loadingNotifier!,
            builder: (context, isLoading, child) {
              return SizedBox(
                height: 50.h,
                child: ElevatedButton(
                  child: (isLoading)
                      ? CircularProgressIndicator.adaptive(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).scaffoldBackgroundColor),
                        )
                      : Text(
                          text,
                          style: Theme.of(context)
                              .textTheme
                              .button
                              ?.copyWith(fontSize: 18.sp),
                        ),
                  onPressed: shouldButtonBeEnabled(isEnabled, isLoading)
                      ? onPressed
                      : null,
                ),
              );
            },
          );
        },
      );
    } else if (buttonType == ButtonType.Bordered) {
      return ValueListenableBuilder<bool>(
        valueListenable: isEnabledNotifier!,
        builder: (context, isEnabled, child) {
          return ValueListenableBuilder<bool>(
            valueListenable: loadingNotifier!,
            builder: (context, isLoading, child) {
              return OutlinedButton(
                onPressed: shouldButtonBeEnabled(isEnabled, isLoading)
                    ? onPressed
                    : null,
                child: (isLoading)
                    ? CircularProgressIndicator.adaptive(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).scaffoldBackgroundColor),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (icon != null)
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.w),
                                child: SvgPicture.asset(icon!)),
                          Text(
                            text,
                            style: TextStyle(
                                fontSize: 18.sp,
                                color: Theme.of(context).primaryColor),
                          ),
                        ],
                      ),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
          );
        },
      );
    } else {
      return ValueListenableBuilder<bool>(
        valueListenable: isEnabledNotifier!,
        builder: (context, isEnabled, child) {
          return ValueListenableBuilder<bool>(
            valueListenable: loadingNotifier!,
            builder: (context, isLoading, child) {
              return TextButton(
                  onPressed: shouldButtonBeEnabled(isEnabled, isLoading)
                      ? onPressed
                      : null,
                  child: (isLoading)
                      ? CircularProgressIndicator.adaptive(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).scaffoldBackgroundColor),
                        )
                      : Text(
                          text,
                          style: TextStyle(
                              color: Theme.of(context).errorColor,
                              decoration: TextDecoration.underline),
                        ));
            },
          );
        },
      );
    }
  }

  bool shouldButtonBeEnabled(bool isEnabled, bool isLoading) =>
      isEnabled && !isLoading;
}
