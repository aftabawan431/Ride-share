import 'package:flutter/material.dart';
import '../../../../core/utils/globals/globals.dart';
import '../providers/splash_provider.dart';
import 'package:provider/provider.dart';

import '../widgets/splash_screen_content.dart';

// ignore: must_be_immutable
class SplashScreen extends StatelessWidget {
   SplashScreen({Key? key}) : super(key: key);
  final SplashProvider _splashProvider=sl();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: _splashProvider,
        child: const SplashScreenContent());
  }
}

