import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum CustomTextButtonColor { red, grey, green }

class CustomTextButton extends StatelessWidget {
  CustomTextButton(
      {Key? key,
      this.color = CustomTextButtonColor.green,
      required this.onPressed,
      required this.title})
      : super(key: key);
  CustomTextButtonColor color;
  Function() onPressed;
  String title;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        child: Text(
          title,
          style: TextStyle(
              color: color == CustomTextButtonColor.green
                  ? null
                  : color == CustomTextButtonColor.grey
                      ? Colors.grey.withOpacity(.9)
                      : Colors.red.withOpacity(.9)),
        ));
  }
}
