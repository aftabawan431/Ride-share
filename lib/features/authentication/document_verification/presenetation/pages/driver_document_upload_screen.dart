import 'package:flutter/material.dart';
import '../../../../../core/utils/globals/snake_bar.dart';
import '../../../../../core/widgets/custom/continue_button.dart';
import '../../../../../core/widgets/custom_column_appbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../core/utils/globals/globals.dart';
import '../../../../dashboard/presentation/providers/driver_dashboard_provider.dart';
import '../../../../splash_screen/presentation/providers/splash_provider.dart';
import '../../../auth_wrapper/presentation/providers/auth_provider.dart';

class DriverDocuementUploadScreen extends StatelessWidget {
  DriverDocuementUploadScreen({Key? key}) : super(key: key);
  final AuthProvider authProvider = sl();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: authProvider, child: const DriverDocumentUploadScreenContent());
  }
}

class DriverDocumentUploadScreenContent extends StatefulWidget {
  const DriverDocumentUploadScreenContent({Key? key}) : super(key: key);

  @override
  State<DriverDocumentUploadScreenContent> createState() =>
      _DriverDocumentUploadScreenContentState();
}

class _DriverDocumentUploadScreenContentState
    extends State<DriverDocumentUploadScreenContent> {
  ValueNotifier<bool> valueNotifier = ValueNotifier(false);
  @override
  void initState() {
    super.initState();


    context.read<AuthProvider>().clearDocumentUploadFiles();
  }

  @override
  void dispose() {
    super.dispose();
    onBackPress = null;
  }

  SplashProvider splashProvider = sl();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const CustomColumnAppBar(

                title: 'Identity Verification',
                showBackButton: true,
              ),
              Consumer<AuthProvider>(builder: (context, provider, ch) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 18.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        "Please upload your identity card images",
                        style: TextStyle(
                          fontSize: 18.sp,
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),

                      GestureDetector(
                        onTap: () {
                          provider.chooseDocumentVerificationImage(true);
                        },
                        child: Container(
                          height: 150.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                width: 1,
                                color: Theme.of(context).canvasColor,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  spreadRadius: 1,
                                  blurRadius: 1,
                                )
                              ]),
                          child: provider.frontSideImage != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(9),
                                  child: Image.file(
                                    provider.frontSideImage!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Icon(
                                  Icons.image,
                                  size: 80.sp,
                                  color: Colors.grey.withOpacity(.8),
                                ),
                        ),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      const Text("Front-side"),
                      SizedBox(
                        height: 20.h,
                      ),
                      GestureDetector(
                        onTap: () {
                          provider.chooseDocumentVerificationImage(false);
                        },
                        child: Container(
                          height: 150.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                width: 1,
                                color: Theme.of(context).canvasColor,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  spreadRadius: 1,
                                  blurRadius: 1,
                                )
                              ]),
                          child: provider.backSideImage != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(9),
                                  child: Image.file(
                                    provider.backSideImage!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Icon(
                                  Icons.image,
                                  size: 80.sp,
                                  color: Colors.grey.withOpacity(.8),
                                ),
                        ),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      const Text("Back-side"),
                      SizedBox(
                        height: 20.h,
                      ),
                      ContinueButton(
                          loadingNotifier: context
                              .read<AuthProvider>()
                              .uploadVerificationDocumentLoading,
                          text: 'Upload',
                          onPressed: () {
                            if (provider.frontSideImage == null) {
                              ShowSnackBar.show(
                                  'Please select Front-Side Picture');
                              return;
                            } else if (provider.backSideImage == null) {
                              ShowSnackBar.show(
                                  'Please select Back-Side Picture');
                              return;
                            }
                            provider.driverDocumentUpload();
                          }),
                      SizedBox(
                        height: 10.h,
                      ),
                      ContinueButton(
                          loadingNotifier: valueNotifier,
                          text: 'Switch to Passenger',
                          onPressed: () {
                            DashboardProvider driverProvider = sl();
                            driverProvider.switchRole();
                          }),
                      SizedBox(
                        height: 10.h,
                      ),
                    ],
                  ),
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
