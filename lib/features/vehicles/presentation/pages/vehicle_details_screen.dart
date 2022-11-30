import 'package:flutter/material.dart';
import 'package:flutter_rideshare/features/vehicles/presentation/widgets/bottom_sheets/choose_city_bottom_sheet.dart';
import '../../../../core/utils/globals/globals.dart';
import '../../../../core/utils/globals/snake_bar.dart';
import '../../../../core/utils/validators/form_validator.dart';
import '../../../../core/widgets/bottom_sheets/custom_year_picker.dart';
import '../providers/vechicle_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../../core/router/app_state.dart';
import '../../../../core/utils/constants/app_assets.dart';
import '../../../../core/widgets/custom/continue_button.dart';
import '../../../../core/widgets/custom/custom_dropdown_field.dart';
import '../../../../core/widgets/custom/custom_form_field.dart';
import '../widgets/bottom_sheets/choose_provice_bottom_sheet.dart';
import '../widgets/bottom_sheets/choose_vehicle_bottom_sheet.dart';
import '../widgets/bottom_sheets/choose_vehicle_maker_bottom_sheet.dart';
import '../widgets/bottom_sheets/choose_vehicle_model_bottom_sheet.dart';

// ignore: must_be_immutable
class VehicleDetailsScreen extends StatelessWidget {
  VehicleDetailsScreen({Key? key}) : super(key: key);
  VehicleProvider vehicleProvider = sl();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [ChangeNotifierProvider.value(value: vehicleProvider)],
        child: const VechicleDetailsScreenContent());
  }
}

class VechicleDetailsScreenContent extends StatefulWidget {
  const VechicleDetailsScreenContent({Key? key}) : super(key: key);

  @override
  State<VechicleDetailsScreenContent> createState() =>
      _VechicleDetailsScreenContentState();
}

class _VechicleDetailsScreenContentState
    extends State<VechicleDetailsScreenContent> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    context.read<VehicleProvider>().getInitials();
    context.read<VehicleProvider>().clearFields();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<bool>(
          valueListenable: context.read<VehicleProvider>().getInitialLoading,
          builder: (_, loading, __) {
            if (loading) {
              return const Center(child: CircularProgressIndicator.adaptive());
            } else {
              return SafeArea(
                child: Stack(
                  fit: StackFit.expand,
                  alignment: Alignment.topCenter,
                  children: [
                    Positioned(
                      height: 250.h,
                      top: 0,
                      right: 0,
                      left: 0,
                      child: Container(
                        width: double.infinity,
                        color: Theme.of(context).primaryColor,
                        padding: EdgeInsets.all(70.r),
                        child: SvgPicture.asset(AppAssets.logoSvg,color: Colors.white,),
                      ),
                    ),
                    Positioned(
                      top: 20,
                      left: 20,
                      child: GestureDetector(
                        onTap: () {
                          AppState appState = sl();
                          appState.moveToBackScreen();
                        },
                        child: Icon(
                          Icons.keyboard_arrow_left_sharp,
                          color: Colors.white,
                          size: 40.r,
                        ),
                      ),
                    ),
                    DraggableScrollableSheet(
                        initialChildSize: .75,
                        builder: (BuildContext context,
                            ScrollController scrollController) {
                          return Container(
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(horizontal: 20.w),
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10)),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black12,
                                      spreadRadius: 2,
                                      blurRadius: 2)
                                ]),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.w, vertical: 20.h),
                              child: Consumer<VehicleProvider>(
                                  builder: (context, provider, ch) {
                                return Form(
                                  key: _formKey,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Text(
                                          'Vehicle Details',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4,
                                        ),
                                        SizedBox(
                                          height: 20.h,
                                        ),
                                        CustomTextFormField(
                                          readOnly: true,
                                          hintText: 'Select',
                                          labelText: 'Vehicle Type',
                                          validator: FormValidators
                                              .validateVehicleType,
                                          controller:
                                              provider.vehicleTypeController,
                                          onTap: () {
                                            ChooseVehicleTypeBottomSheet
                                                bottomSheet =
                                                ChooseVehicleTypeBottomSheet(
                                                    context: context);
                                            bottomSheet.show();
                                          },
                                        ),

                                        // CustomDropDown(
                                        //
                                        //   // validator: FormValidators.customValidator,
                                        //   value: provider.selectedType,
                                        //   validator: (value) {
                                        //     if (value == null) {
                                        //       return 'Please choose vehicle type';
                                        //     }
                                        //     return null;
                                        //   },
                                        //   items: provider
                                        //       .getVehicleInitialsResponse!
                                        //       .vehicleTypes
                                        //       .map((e) => e.type)
                                        //       .toList(),
                                        //   onChanged: (value) {
                                        //     provider.selectedType = value;
                                        //     if (provider.selectedMaker !=
                                        //         null) {
                                        //       provider.setSelectedModel(null);
                                        //       provider.getModels();
                                        //     }
                                        //   },
                                        // ),

                                        CustomTextFormField(
                                          readOnly: true,
                                          hintText: 'Select',
                                          labelText: 'Maker',
                                          validator: FormValidators
                                              .validateVehicleMaker,
                                          controller:
                                              provider.vehicleMakerController,
                                          onTap: () {
                                            ChooseVehicleMakerBottomSheet
                                                bottomSheet =
                                                ChooseVehicleMakerBottomSheet(
                                                    context: context);
                                            bottomSheet.show();
                                          },
                                        ),
                                        CustomTextFormField(
                                          readOnly: true,
                                          hintText: 'Select',
                                          labelText: 'Model',
                                          validator: FormValidators
                                              .validateVehicleModel,
                                          controller:
                                              provider.vehicleModelController,
                                          onTap: () {
                                            if (provider
                                                    .getModelsResponseModel ==
                                                null) {
                                              return;
                                            }

                                            ChooseVehicleModelBottomSheet
                                                bottomSheet =
                                                ChooseVehicleModelBottomSheet(
                                                    context: context);
                                            bottomSheet.show();
                                          },
                                        ),
                                        //
                                        // CustomDropDown(
                                        //   hintText: 'Select',
                                        //   labelText: 'Maker',
                                        //   items: provider
                                        //       .getVehicleInitialsResponse!
                                        //       .vehicleMakes
                                        //       .map((e) => e.make)
                                        //       .toList(),
                                        //   validator: (value) {
                                        //     if (value == null) {
                                        //       return 'Please choose vehicle maker';
                                        //     }
                                        //     return null;
                                        //   },
                                        //   onChanged: (value) {
                                        //     if (provider.selectedType == null) {
                                        //       return ShowSnackBar.show(
                                        //           'Please choose vehicle type');
                                        //     }
                                        //     provider.setSelectedModel(null);
                                        //     provider.selectedMaker = value;
                                        //     provider.getModels();
                                        //   },
                                        // ),
                                        // CustomDropDown(
                                        //   hintText: 'Select',
                                        //   labelText: 'Model',
                                        //   value: provider.selectedModel,
                                        //   validator: (value) {
                                        //     if (value == null) {
                                        //       return 'Please choose vehicle model';
                                        //     }
                                        //     return null;
                                        //   },
                                        //   items:
                                        //       provider.getModelsResponseModel ==
                                        //               null
                                        //           ? []
                                        //           : provider
                                        //               .getModelsResponseModel!
                                        //               .data
                                        //               .map((e) => e.model)
                                        //               .toList(),
                                        //   onChanged: (value) {
                                        //     provider.setSelectedModel(value);
                                        //   },
                                        // ),
                                        CustomTextFormField(
                                          hintText: 'Enter',
                                          labelText:
                                              'Vehicle Registration No.',
                                          validator:
                                              FormValidators.registrationNumber,
                                          focusNode:
                                              provider.registerNoFocusNode,
                                          controller: provider.registerNo,
                                          maxLength: 10,
                                          maxLengthEnforced: true,
                                          textInputAction: TextInputAction.next,
                                          onFieldSubmitted: (value) {
                                            FocusScope.of(context).requestFocus(
                                                provider.yearFocusNode);
                                          },
                                        ),
                                        CustomTextFormField(
                                          hintText: 'Enter',
                                          readOnly: true,
                                          labelText: 'Year',
                                          focusNode: provider.yearFocusNode,
                                          maxLength: 4,
                                          maxLengthEnforced: true,
                                          keyboardType: TextInputType.number,
                                          textInputAction: TextInputAction.next,
                                          onFieldSubmitted: (value) {
                                            FocusScope.of(context).requestFocus(
                                                provider.minMilageFocusNode);
                                          },
                                          onTap: () async {
                                            final bottomsheet =
                                                CustomYearPicker(
                                                    context: context,
                                                    firstDate:
                                                        DateTime(1975, 1, 1),
                                                    lastDate: DateTime.now());
                                            final result =
                                                await bottomsheet.show();
                                            if (result != null) {
                                              provider.yearController.text =
                                                  (result as DateTime)
                                                      .year
                                                      .toString();
                                            }
                                          },
                                          validator:
                                              FormValidators.yearValidator,
                                          controller: provider.yearController,
                                        ),

                                        // CustomTextFormField(
                                        //   hintText: 'Enter',
                                        //   labelText:
                                        //       'Min Milage.',
                                        //   keyboardType: TextInputType.number,
                                        //   validator: FormValidators.customValue,
                                        //   controller: provider.minMilageController,
                                        //   focusNode: provider.minMilageFocusNode,
                                        //   textInputAction: TextInputAction.next,
                                        //   onFieldSubmitted: (value){
                                        //     FocusScope.of(context).requestFocus(provider.maxMilageFocusNode);
                                        //   },
                                        // ),

                                        CustomTextFormField(
                                          hintText: 'Enter',
                                          validator: FormValidators.avgMileage,
                                          labelText: 'Avg Mileage',
                                          keyboardType: TextInputType.number,
                                          maxLength: 2,
                                          maxLengthEnforced: true,
                                          focusNode:
                                              provider.minMilageFocusNode,
                                          textInputAction: TextInputAction.next,
                                          onFieldSubmitted: (value) {
                                            FocusScope.of(context).requestFocus(
                                                provider.colorFocusNode);
                                          },
                                          controller:
                                              provider.minMilageController,
                                        ),

                                        CustomDropDown(
                                          hintText: 'Select',
                                          labelText: 'Color',
                                          items: const [],
                                          validator: (value) {
                                            if (value == null) {
                                              return 'Please choose a color';
                                            }
                                            return null;
                                          },
                                          focusNode: provider.colorFocusNode,
                                          colors: provider
                                              .getVehicleInitialsResponse!
                                              .vehicleColors,
                                          isColor: true,
                                          onChanged: (value) {
                                            provider.selectedColorId = value;
                                          },
                                        ),
                                        CustomDropDown(
                                          hintText: 'Select',
                                          labelText: 'Sitting Capacity',
                                          validator: (value) {
                                            if (value == null) {
                                              return 'Please choose sitting capacity';
                                            }
                                            return null;
                                          },
                                          items: provider.capacity,
                                          onChanged: (value) {
                                            provider.selectedCapacity = value;
                                          },
                                        ),
                                        CustomTextFormField(
                                          readOnly: true,
                                          hintText: 'Select',
                                          labelText: 'Province',
                                          validator:
                                              FormValidators.validateProvince,
                                          controller:
                                              provider.provinceController,
                                          onTap: () {
                                            ChooseVehicleProvinceBottomSheet
                                                bottomSheet =
                                                ChooseVehicleProvinceBottomSheet(
                                                    context: context);
                                            bottomSheet.show();
                                          },
                                        ),
                                        CustomTextFormField(
                                          readOnly: true,
                                          hintText: 'Select',
                                          labelText: 'City',
                                          validator:
                                              FormValidators.validateCity,
                                          controller:
                                              provider.vehicleCityController,
                                          onTap: () {
                                            if (provider
                                                    .getModelsResponseModel ==
                                                null) {
                                              return null;
                                            }
                                            ChooseVehicleCityBottomSheet
                                                bottomSheet =
                                                ChooseVehicleCityBottomSheet(
                                                    context: context);
                                            bottomSheet.show();
                                          },
                                        ),
                                        // CustomDropDown(
                                        //   value: provider.selectedCity,
                                        //   hintText: 'Select',
                                        //   labelText: 'City',
                                        //   validator: (value) {
                                        //     if (value == null) {
                                        //       return 'Please choose a city';
                                        //     }
                                        //     return null;
                                        //   },
                                        //   items:
                                        //       provider.getCityResponseModel ==
                                        //               null
                                        //           ? []
                                        //           : provider
                                        //               .getCityResponseModel!
                                        //               .data
                                        //               .map((e) => e.city)
                                        //               .toList(),
                                        //   onChanged: (value) {
                                        //     provider.setSelectedCity(value);
                                        //   },
                                        // ),

                                        // CustomDropDown(
                                        //   hintText: 'Select',
                                        //   labelText: 'Provice',
                                        //   items: provider
                                        //       .getVehicleInitialsResponse!
                                        //       .provinces
                                        //       .map((e) => e.name)
                                        //       .toList(),
                                        //   onChanged: (value) {},
                                        // ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 3),
                                          child: Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Text(
                                              "Other Options",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w700),
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Checkbox(
                                                value: provider.heaterAc,
                                                onChanged: (value) {
                                                  provider
                                                      .setHeaterAcValue(value!);
                                                }),
                                            Text("AC/Heater")
                                          ],
                                        ),
                                        // Row(
                                        //   children: [
                                        //     Radio(
                                        //         value: 'ac',
                                        //         groupValue:
                                        //             provider.otherPreferece,
                                        //         onChanged:
                                        //             provider.setPreference),
                                        //     const Text('AC'),
                                        //     Expanded(child: Container()),
                                        //     Radio(
                                        //         value: 'heater',
                                        //         groupValue:
                                        //             provider.otherPreferece,
                                        //         onChanged:
                                        //             provider.setPreference),
                                        //     const Text('Heater'),
                                        //   ],
                                        // ),
                                        SizedBox(
                                          height: 10.h,
                                        ),

                                        ContinueButton(
                                            loadingNotifier:
                                                provider.addVehicleLoading,
                                            text: 'Submit',
                                            onPressed: () {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                provider.addVehicle();
                                              }
                                            }),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ),
                          );
                        }),
                  ],
                ),
              );
            }
          }),
    );
  }
}
