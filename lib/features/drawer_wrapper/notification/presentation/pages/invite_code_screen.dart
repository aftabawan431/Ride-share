import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../core/router/app_state.dart';
import '../../../../../core/utils/constants/app_assets.dart';
import '../../../../../core/utils/globals/snake_bar.dart';
import '../../../../../core/widgets/custom/continue_button.dart';
import '../../../../../core/widgets/custom/custom_app_bar.dart';
import '../../../../../core/widgets/custom_column_appbar.dart';
import '../../../../authentication/auth_wrapper/presentation/providers/auth_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/utils/globals/globals.dart';

class InviteCodeScreen extends StatelessWidget {
  const InviteCodeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InviteCodeScreenContent();
  }
}

class InviteCodeScreenContent extends StatelessWidget {
  InviteCodeScreenContent({Key? key}) : super(key: key);
  AuthProvider authProvider = sl();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar:const CustomAppBar(
      //   title: 'Invite Friends',
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // CustomColumnAppBar(title: 'Profile Setting'),

              SizedBox(
                  height: 450.h,
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      SvgPicture.asset(
                        AppAssets.inviteFriendsBgSvg,
                        fit: BoxFit.cover,
                      ),
                      Align(
                          alignment: Alignment.topLeft,
                          child: _returnTopAppBar()),
                      Align(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 50.w, vertical: 50.h),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [


                              SvgPicture.asset(
                                AppAssets.inviteFriendsBucketSvg,
                                height: 220.h,
                                width: 140.w,
                              ),
                              Text(
                                "Invite Friends",
                                style: TextStyle(
                                    fontSize: 26.sp, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "To Get Free Points",
                                style: TextStyle(
                                    fontSize: 26.sp, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "When your friend sign up with this code, you'll both get extra points",
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  )),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Share Your Invite Code",
                      style:
                          TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          authProvider.currentUser!.inviteCode,
                          style: TextStyle(
                              fontSize: 24.sp, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                            height: 30.h,
                            child: IconButton(
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(
                                          text: authProvider
                                              .currentUser!.inviteCode))
                                      .then((_) {
                                    ShowSnackBar.show('Invite code copied');
                                  });
                                },
                                icon: const Icon(Icons.copy)))
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.black,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    ContinueButton(
                      text: 'Share',
                      onPressed: () async {
                        await FlutterShare.share(
                          title: 'Rahper',
                          text:
                              'This is invite code ${authProvider.currentUser!.inviteCode}',
                          linkUrl: 'https://flutter.dev/',
                          // chooserTitle: 'Example Chooser Title'
                        );
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget _returnTopAppBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
      child: Row(

        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              AppState appState = sl();
              appState.moveToBackScreen();
            },
            child: Icon(
              Icons.keyboard_arrow_left_sharp,
              color: Colors.white,
              size: 35.r,
            ),
          ),
          Expanded(child: Container()),


          Text(
            'Invite Friends',
            style: TextStyle(fontSize: 22.sp, color: Colors.white),
          ),
          Expanded(child: Container()),

        ],
      ),
    );
  }

}
