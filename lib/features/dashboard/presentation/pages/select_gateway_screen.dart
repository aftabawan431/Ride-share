import 'package:flutter/material.dart';

class PaymentGatewayScreen extends StatelessWidget {
  const PaymentGatewayScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _PaymentGatewayScreenContent();
  }
}

class _PaymentGatewayScreenContent extends StatefulWidget {
  const _PaymentGatewayScreenContent({Key? key}) : super(key: key);

  @override
  State<_PaymentGatewayScreenContent> createState() => _PaymentGatewayScreenContentState();
}

class _PaymentGatewayScreenContentState extends State<_PaymentGatewayScreenContent> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
