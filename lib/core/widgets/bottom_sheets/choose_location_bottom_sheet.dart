import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../features/dashboard/presentation/widgets/horizontal_line.dart';
import '../../../features/drawer_wrapper/schedules_driver/presentation/pages/choose_location_from_map_screen.dart';
import '../../router/app_state.dart';
import '../../router/models/page_action.dart';
import '../../router/models/page_config.dart';
import '../../router/places_provider.dart';
import '../../utils/constants/app_assets.dart';
import '../../utils/enums/page_state_enum.dart';
import '../../utils/globals/globals.dart';
import '../custom/custom_form_field.dart';

class ChooseLocationBottomSheet {
  final BuildContext context;
  Icon icon;
  bool isDashboardWhereTo;
  LocationType locationType;

  PlacesProvider provider = sl();
  String title;
  ChooseLocationBottomSheet(
      {required this.context,
      required this.title,
      required this.icon,
        required this.locationType,

      this.isDashboardWhereTo = false});

  Future show() async {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
      builder: (BuildContext bottomSheetContext) {
        return ChangeNotifierProvider.value(
          value: provider,
          child: Builder(builder: (context) {
            return Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: SafeArea(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.r),
                          topRight: Radius.circular(15.r)),
                    ),
                    padding: const EdgeInsets.only(
                        top: 10, left: 10, right: 10, bottom: 10),
                    child: Consumer<PlacesProvider>(builder: (_, snapshot, __) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10.h,
                            width: double.infinity,
                          ),
                          const Center(child:  HorizontalLine()),
                          SizedBox(
                            height: 20.h,
                          ),
                          Text(
                            title,
                            style: TextStyle(fontSize: 20.sp),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Row(
                            children: [
                              icon,
                              SizedBox(
                                width: 10.w,
                              ),
                              Expanded(
                                child: CustomTextFormField(
                                  hintText: 'Enter Location',
                                  textInputAction: TextInputAction.done,
                                  labelText: '',
                                  onChanged: (value) {
                                    if (value.length > 3) {
                                      context
                                          .read<PlacesProvider>()
                                          .getPlaces(value);
                                    }
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              GestureDetector(
                                  onTap: () {

                                    AppState appState = sl();
                                    appState.currentAction = PageAction(
                                        state: PageState.addWidget,
                                        page: PageConfigs
                                            .chooseLocationFromMapPageConfig,
                                        widget: ChooseLocationFromMapScreen(
                                          isStartPoint: title == 'Where from?',
                                          isDashboardWhereTo:
                                              isDashboardWhereTo,
                                        ));

                                    Navigator.of(context).pop();


                                  },
                                  child: SvgPicture.asset(
                                    AppAssets.mapSvg,
                                    height: 35.sp,
                                    width: 35.sp,
                                  ))
                            ],
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          SizedBox(
                              height: 300.h,
                              child: ListView.separated(
                                  separatorBuilder: (context, index) =>
                                      const Divider(height: 1, color: Colors.black12),
                                  itemCount:
                                      snapshot.placePredictionList.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pop(snapshot
                                            .placePredictionList[index]);
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        color: Colors.white,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.w, vertical: 10.h),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.location_on,
                                              color:
                                                  Theme.of(context).errorColor,
                                            ),
                                            SizedBox(
                                              width: 10.w,
                                            ),
                                            Expanded(
                                                child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  snapshot
                                                      .placePredictionList[
                                                          index]
                                                      .main_text,
                                                  style:
                                                      TextStyle(fontSize: 16.h),
                                                ),
                                                Text(
                                                  snapshot
                                                      .placePredictionList[
                                                          index]
                                                      .secondary_text,
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black54),
                                                )
                                              ],
                                            ))
                                          ],
                                        ),
                                      ),
                                    );
                                  })),
                        ],
                      );
                    }),
                  ),
                ));
          }),
        );
      },
    ).then((value) {
      if (value != null) {
        return value;
      }
    });
  }
}
