import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_rideshare/core/utils/extension/extensions.dart';
import 'package:flutter_rideshare/core/utils/theme/app_theme.dart';
import 'package:flutter_rideshare/core/widgets/custom/custom_form_field.dart';
import 'package:flutter_rideshare/features/vehicles/data/models/get_vehicle_initials_response.dart';
import 'package:flutter_rideshare/features/vehicles/presentation/providers/vechicle_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../../../core/utils/globals/globals.dart';

class ChooseVehicleTypeBottomSheet {
  final BuildContext context;

  ChooseVehicleTypeBottomSheet({
    required this.context,
  });

  final VehicleProvider vehicleProvider = sl();

  Future show() async {
    ValueNotifier<List<VehicleTypes>> vehicleTypesNotifier =
        ValueNotifier(vehicleProvider.getVehicleInitialsResponse!.vehicleTypes);
    //sorting
    vehicleTypesNotifier.value
        .sort((a, b) => a.type.toLowerCase().compareTo(b.type.toLowerCase()));

    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
      builder: (BuildContext bottomSheetContext) {
        return Builder(builder: (context) {
          return Container(
              color: Colors.white,
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: SafeArea(
                child: Container(
                  height: 450.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.r),
                        topRight: Radius.circular(15.r)),
                  ),
                  padding: EdgeInsets.only(
                      top: 15.h, left: 10, right: 10, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Vehicle Types",
                        style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.appTheme.primaryColor),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      CustomTextFormField(
                        hintText: 'Search',
                        labelText: '',
                        onChanged: (value) {
                          vehicleTypesNotifier.value = vehicleProvider
                              .getVehicleInitialsResponse!.vehicleTypes
                              .where((element) => element.type
                                  .toLowerCase()
                                  .contains(value.toLowerCase()))
                              .toList();
                          vehicleTypesNotifier.value.sort((a, b) => a.type
                              .toLowerCase()
                              .compareTo(b.type.toLowerCase()));
                        },
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Expanded(
                        child: ValueListenableBuilder<List<VehicleTypes>>(
                            valueListenable: vehicleTypesNotifier,
                            builder: (_, vehicleTypes, __) {
                              return vehicleTypes.isEmpty
                                  ? Center(
                                      child: Text("No data"),
                                    )
                                  : ListView.separated(
                                      separatorBuilder: (context, index) =>
                                          Divider(
                                        height: 4.h,
                                        color: Colors.black26,
                                      ),
                                      itemCount: vehicleTypes.length,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                            onTap: () {
                                              VehicleProvider vehicleProvider =
                                                  sl();
                                              vehicleProvider
                                                      .vehicleTypeController
                                                      .text =
                                                  vehicleTypes[index]
                                                      .type
                                                      .toTitleCase();
                                              vehicleProvider.selectedType =
                                                  vehicleTypes[index].type;

                                              vehicleProvider
                                                  .setSelectedModel(null);
                                              vehicleProvider
                                                  .vehicleModelController
                                                  .clear();
                                              vehicleProvider
                                                      .getModelsResponseModel =
                                                  null;

                                              vehicleProvider.getModels();
                                              Navigator.of(context).pop();
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 4.h),
                                              child: Text(
                                                vehicleTypes[index]
                                                    .type
                                                    .toTitleCase(),
                                                style: TextStyle(
                                                    fontSize: 18.sp,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ));
                                      },
                                    );
                            }),
                      ),
                    ],
                  ),
                ),
              ));
        });
      },
    ).then((value) {
      if (value != null) {
        return value;
      }
    });
  }
}
