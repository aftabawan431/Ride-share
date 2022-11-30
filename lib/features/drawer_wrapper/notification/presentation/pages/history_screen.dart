// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// import '../../../history/presentation/widgets/history_widget.dart';
// class HistoryScreen extends StatelessWidget {
//   const HistoryScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return HistoryScreenContent();
//   }
// }
//
// class HistoryScreenContent extends StatelessWidget {
//   const HistoryScreenContent({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Theme.of(context).primaryColor,
//       child: Scaffold(
//         body: SafeArea(
//           child: Stack(
//             children: [
//               Positioned(
//                   left: 0,
//                   right: 0,
//                   top: 0,
//                   height: 230.h,
//                   child: Container(
//                     padding:
//                     EdgeInsets.symmetric(horizontal: 18.w, vertical: 20.h),
//                     color: Theme.of(context).primaryColor,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Icon(
//                           Icons.keyboard_arrow_left_sharp,
//                           color: Colors.white,
//                           size: 40.r,
//                         ),
//                         Row(
//                           children: [
//                             Text(
//                               "History",
//                               style: TextStyle(
//                                   fontSize: 30.sp, color: Colors.white),
//                             ),
//                           ],
//                         ),
//                         SizedBox(
//                           height: 10.h,
//                         ),
//                       ],
//                     ),
//                   )),
//               Positioned(
//                 top: 230.h - 100.h,
//                 left: 0,
//                 right: 0,
//                 bottom: 10,
//                 child: Container(
//                   margin: EdgeInsets.symmetric(horizontal: 18.w),
//                   child: SingleChildScrollView(
//                     child: Column(
//                       children: [
//                         // HistoryWidget()
//
//
//                       ],
//                     ),
//                   ),
//                 ),
//               )
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
