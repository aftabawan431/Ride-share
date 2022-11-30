import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/constants/app_assets.dart';
import '../../../authentication/auth_wrapper/presentation/providers/auth_provider.dart';
import '../../data/models/get_user_vehicles_response_model.dart';
import '../providers/vechicle_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/globals/globals.dart';

// ignore: must_be_immutable
class VehicleWidget extends StatelessWidget {
  VehicleWidget({Key? key, required this.userVehicle}) : super(key: key);
  UserVehicle userVehicle;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, provider, ch) {
      return Card(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(userVehicle.model.make.make),
                  Expanded(child: Container()),
                  Text(
                    userVehicle.registrationNumber,
                    style:
                        TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                      onPressed: () async {
                        if (await confirm(navigatorKeyGlobal.currentContext!,
                            content: const Text(
                                "Are you sure you want to delete this vehicle?"))) {
                          VehicleProvider vehicleProvider = sl();
                          vehicleProvider.deleteVehicle(id: userVehicle.id);
                        }
                      },
                      icon: const Icon(Icons.delete))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Model/Year "),
                      Text("${userVehicle.model.model}/${userVehicle.year}"),
                    ],
                  ),
                  Expanded(child: Container()),
                  Column(
                    children: [
                      SvgPicture.asset(AppAssets.carSvg),
                      Checkbox(
                          value: provider.currentUser!.selectedVehicle ==
                              userVehicle.id,
                          onChanged: (value) {
                            if (userVehicle.id !=
                                provider.currentUser!.selectedVehicle) {
                              context
                                  .read<AuthProvider>()
                                  .updateSelectedVehicle(id: userVehicle.id);
                            }
                          })
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
