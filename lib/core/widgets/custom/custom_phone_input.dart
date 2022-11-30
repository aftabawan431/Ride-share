// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// import 'package:logger/logger.dart';
//
// class CustomPhoneInput extends StatelessWidget {
//   CustomPhoneInput({Key? key, this.phoneNumber, this.onChanged,this.validator,this.focusNode,this.onFieldSubmitted,this.textInputAction,this.controller})
//       : super(key: key);
//
//   final FocusNode? focusNode;
//   TextInputAction? textInputAction;
//
//
//   final Function(String)? onFieldSubmitted;
//   final TextEditingController? controller;
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(top: 15.h),
//       child: IntlPhoneField(
//         autovalidateMode:AutovalidateMode.disabled,
//
//         validator: (value){
//           Logger().v(value);
//         },
//         controller: controller,
//         focusNode: focusNode,
//         onSubmitted: onFieldSubmitted,
//         textInputAction: textInputAction,
//
//         decoration: InputDecoration(
//           // labelText: 'Phone Number',
//           hintText: "Mobile Number",
//           counterText: "",
//           focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(5),
//               borderSide:
//                   BorderSide(width: 1, color: Colors.grey.withOpacity(.8))),
//           errorBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(5),
//               borderSide:
//                   BorderSide(width: 1, color: Colors.grey.withOpacity(.8))),
//           enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(5),
//               borderSide:
//                   BorderSide(width: 1, color: Colors.grey.withOpacity(.8))),
//           focusedErrorBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(5),
//               borderSide:
//                   BorderSide(width: 1, color: Colors.grey.withOpacity(.8))),
//         ),
//         initialCountryCode: 'PK',
//         onChanged:onChanged,
//       ),
//     );
//   }
// }
