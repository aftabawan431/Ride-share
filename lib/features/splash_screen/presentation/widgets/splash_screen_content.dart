
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/utils/constants/app_assets.dart';
import '../providers/splash_provider.dart';
import 'package:provider/provider.dart';


class SplashScreenContent extends StatefulWidget {
  const SplashScreenContent({Key? key}) : super(key: key);

  @override
  State<SplashScreenContent> createState() => _SplashScreenContentState();
}

class _SplashScreenContentState extends State<SplashScreenContent> {
  @override
  void initState() {
    super.initState();
    context.read<SplashProvider>().getCurrentUser();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SizedBox(
          height: double.infinity,
          width: double.infinity,

          child:Container(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: Center(child: SvgPicture.asset(AppAssets.logoSvg,color: Colors.white,),),
          )),
    );
  }
}
