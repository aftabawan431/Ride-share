import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rideshare/core/widgets/custom_column_appbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DisplayReceiptScreen extends StatelessWidget {
  const DisplayReceiptScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _DisplayReceiptScreenContent();
  }
}

class _DisplayReceiptScreenContent extends StatelessWidget {
  const _DisplayReceiptScreenContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            CustomColumnAppBar(title: 'Receipt'),
            SizedBox(
              height: 100.h,
            ),
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 15.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 80.h,
                      ),
                      Text(
                        "Payment Total",
                        style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey.withOpacity(.8),
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Text(
                        "300.00 PKR",
                        style: TextStyle(
                            fontSize: 22.sp, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      _returnReceiptItem('Date', '12 May 2022'),
                      _returnReceiptItem('Status', 'Success'),
                      _returnReceiptItem('From', '12 May 2022'),
                      _returnReceiptItem('Mobile No', '03xx-xxxxxx'),
                      _returnReceiptItem('To', 'Waleed'),
                      _returnReceiptItem('Date', '12 May 2022'),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 6.h),
                        child: DottedLine(
                          dashColor: Colors.black26,
                        ),
                      ),
                      _returnReceiptItem('Fare', 'Rs. 300.00'),
                      _returnReceiptItem('Cash Paid', 'Rs. 300.00'),
                      SizedBox(
                        height: 20.h,
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Positioned(
                    left: 0,
                    right: 0,
                    top: -50.h,

                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        // border: Border.all(width: 1,color: Colors.white)
                      ),
                      child: CircleAvatar(
                        radius: 48.r,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 46.r,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Icon(Icons.check_outlined,size: 60.sp,color: Colors.white,),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _returnReceiptItem(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style:
                TextStyle(color: Colors.black54, fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
