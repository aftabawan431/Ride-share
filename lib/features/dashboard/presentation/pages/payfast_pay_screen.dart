import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_rideshare/core/modals/pay_past_post_request_model.dart';
import 'package:flutter_rideshare/core/utils/services/payfast_payment_services.dart';
import 'package:flutter_rideshare/core/widgets/custom_column_appbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PayFastPayScreen extends StatelessWidget {
  const PayFastPayScreen({Key? key,required this.requestModel}) : super(key: key);

 final PayFastPostRequestModel requestModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
          child: Column(
            children: [
              const CustomColumnAppBar(title: 'Payment'),
              Expanded(child: InAppWebView(
                initialUrlRequest: URLRequest(
                    url: Uri.parse(PayfastPaymentService.redirectionUrl),
                    method: 'POST',
                    body: Uint8List.fromList(utf8.encode("firstname=Foo&lastname=Bar")),
                    headers: {
                      'Content-Type': 'application/x-www-form-urlencoded'
                    }
                ),
                onWebViewCreated: (controller) {


                },
                onLoadStart: (controller,uri){

                },
              ))
            ],
          )),
    );
  }
}


