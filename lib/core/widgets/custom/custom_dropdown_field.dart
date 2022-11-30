import 'package:flutter/material.dart';
import '../../utils/extension/extensions.dart';
import '../../../features/vehicles/data/models/get_vehicle_initials_response.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CustomDropDown extends StatelessWidget {
  const CustomDropDown({
    required this.hintText,
    required this.labelText,
    required this.items,
    this.onChanged,
    this.value,
    this.validator,
    this.onTap,
    this.loadingNotifier,
    this.contentPadding,
    this.prefixIconPath,
    this.suffixIconPath,
    this.suffixIconOnTap,
    this.isColor=false,
    this.colors,
    this.focusNode,
    Key? key,

  }) : super(key: key);
  final bool isColor;
  final String hintText;
  final String labelText;
  final String? value;
  final List<String> items;
  final Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final ValueNotifier<bool>? loadingNotifier;
  final Function()? onTap;
  final EdgeInsets? contentPadding;
  final String? prefixIconPath;
  final FocusNode? focusNode;
  final String? suffixIconPath;
  final Function()? suffixIconOnTap;
  final List<VehicleColors>? colors;

  @override
  Widget build(BuildContext context) {
    if (loadingNotifier == null) {
      if(isColor==true){
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (labelText.isNotEmpty)
              Padding(
                padding:const EdgeInsets.symmetric(vertical: 3),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    labelText,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            DropdownButtonFormField<String>(

              menuMaxHeight: .7.sh,
              dropdownColor: const Color(0xFFF2F2F4),
              isExpanded: true,
              isDense: true,
              focusNode: focusNode,


              items: colors!.map((VehicleColors item) {

                return DropdownMenuItem<String>(
                  value: item.id,

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 20.r,
                        width: 20.r,

                        decoration: BoxDecoration(
                          boxShadow:const [
                            BoxShadow(
                              color: Colors.black12,
                              spreadRadius: 1.5,
                              blurRadius: 1.5
                            )
                          ],
                          borderRadius: BorderRadius.circular(100),
                          color: Color.fromRGBO(item.code.rgba[0], item.code.rgba[1], item.code.rgba[2], item.code.rgba[3].toDouble())
                        ),
                      ),
                      Text(item.color.toTitleCase()),
                    ],
                  ),
                );
              }).toList(),
              value: value,
              icon: Icon(Icons.expand_more_rounded,
                  color: Theme.of(context).canvasColor),
              onChanged: onChanged,
              validator: validator,


              decoration: InputDecoration(

                hintText: hintText,
                // labelText: labelText,
                border:
                const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(width: 1,color: Colors.grey.withOpacity(.8))),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(width: 1,color: Colors.grey.withOpacity(.8))),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(width: 1,color: Colors.grey.withOpacity(.8))),
                focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(width: 1,color: Colors.grey.withOpacity(.8))),

                contentPadding:const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                suffixIcon: suffixIconPath == null
                    ? null
                    : GestureDetector(
                  onTap: suffixIconOnTap,
                  child: Transform.translate(
                    offset: Offset(0, -1.h),
                    child: Padding(
                      padding: EdgeInsets.only(right: 16.w),
                      child: SvgPicture.asset(suffixIconPath!),
                    ),
                  ),
                ),
                prefixIcon: prefixIconPath == null
                    ? null
                    : Transform.translate(
                  offset: Offset(0, -1.h),
                  child: Padding(
                    padding: EdgeInsets.only(left: 16.w, right: 10.w),
                    child: SvgPicture.asset(prefixIconPath!),
                  ),
                ),
                prefixIconConstraints:
                BoxConstraints(minWidth: 24.w, minHeight: 24.w),
                suffixIconConstraints:
                BoxConstraints(minWidth: 24.w, minHeight: 24.w),
              ),
            ),
          ],
        );
      }
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (labelText.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  labelText,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          DropdownButtonFormField<String>(
            dropdownColor: const Color(0xFFF2F2F4),
            isExpanded: true,
            menuMaxHeight: .7.sh,
            focusNode: focusNode,
            isDense: true,
            items: items.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value.toTitleCase()),
              );
            }).toList(),
            value: value,
            icon: Icon(Icons.expand_more_rounded,
                color: Theme.of(context).canvasColor),
            onChanged: onChanged,
            validator: validator,


            decoration: InputDecoration(
              hintText: hintText,
              // labelText: labelText,
              border:
              const OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(width: 1,color: Colors.grey.withOpacity(.8))),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(width: 1,color: Colors.grey.withOpacity(.8))),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(width: 1,color: Colors.grey.withOpacity(.8))),
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(width: 1,color: Colors.grey.withOpacity(.8))),

              contentPadding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
              suffixIcon: suffixIconPath == null
                  ? null
                  : GestureDetector(
                      onTap: suffixIconOnTap,
                      child: Transform.translate(
                        offset: Offset(0, -1.h),
                        child: Padding(
                          padding: EdgeInsets.only(right: 16.w),
                          child: SvgPicture.asset(suffixIconPath!),
                        ),
                      ),
                    ),
              prefixIcon: prefixIconPath == null
                  ? null
                  : Transform.translate(
                      offset: Offset(0, -1.h),
                      child: Padding(
                        padding: EdgeInsets.only(left: 16.w, right: 10.w),
                        child: SvgPicture.asset(prefixIconPath!),
                      ),
                    ),
              prefixIconConstraints:
                  BoxConstraints(minWidth: 24.w, minHeight: 24.w),
              suffixIconConstraints:
                  BoxConstraints(minWidth: 24.w, minHeight: 24.w),
            ),
          ),
        ],
      );
    } else {
      return ValueListenableBuilder<bool>(
        valueListenable: loadingNotifier!,
        builder: (context, isLoading, child) {
          if (isLoading) {
            return DropdownButtonFormField<CircularProgressIndicator>(
              dropdownColor: const Color(0xFFF2F2F4),
              isExpanded: true,
              isDense: true,
              onTap: onTap,
              items: [
                DropdownMenuItem<CircularProgressIndicator>(
                  value: const CircularProgressIndicator(),
                  enabled: false,
                  child: SizedBox(
                    height: 75.h,
                    child: Center(
                      child: CircularProgressIndicator.adaptive(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                ),
              ],
              onChanged: (value) {},
              icon: Icon(Icons.expand_more_rounded,
                  color: Theme.of(context).canvasColor),
              decoration: InputDecoration(
                hintText: hintText,
                labelText: labelText,
                contentPadding: contentPadding,
                suffixIcon: suffixIconPath == null
                    ? null
                    : GestureDetector(
                        onTap: suffixIconOnTap,
                        child: Transform.translate(
                          offset: Offset(0, -1.h),
                          child: Padding(
                            padding: EdgeInsets.only(right: 16.w),
                            child: SvgPicture.asset(suffixIconPath!),
                          ),
                        ),
                      ),
                prefixIcon: prefixIconPath == null
                    ? null
                    : Transform.translate(
                        offset: Offset(0, -1.h),
                        child: Padding(
                          padding: EdgeInsets.only(left: 16.w, right: 10.w),
                          child: SvgPicture.asset(prefixIconPath!),
                        ),
                      ),
                prefixIconConstraints:
                    BoxConstraints(minWidth: 24.w, minHeight: 24.w),
                suffixIconConstraints:
                    BoxConstraints(minWidth: 24.w, minHeight: 24.w),
              ),
            );
          } else {
            return DropdownButtonFormField<String>(
              dropdownColor: const Color(0xFFF2F2F4),
              isExpanded: true,
              isDense: true,
              value: value,
              onTap: onTap,
              items: items.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value.toTitleCase()),
                );
              }).toList(),
              icon: Icon(Icons.expand_more_rounded,
                  color: Theme.of(context).canvasColor),
              onChanged: onChanged,
              validator: validator,
              decoration: InputDecoration(
                hintText: hintText,
                labelText: labelText,
                contentPadding: contentPadding,
                suffixIcon: suffixIconPath == null
                    ? null
                    : GestureDetector(
                        onTap: suffixIconOnTap,
                        child: Transform.translate(
                          offset: Offset(0, -1.h),
                          child: Padding(
                            padding: EdgeInsets.only(right: 16.w),
                            child: SvgPicture.asset(suffixIconPath!),
                          ),
                        ),
                      ),
                prefixIcon: prefixIconPath == null
                    ? null
                    : Transform.translate(
                        offset: Offset(0, -1.h),
                        child: Padding(
                          padding: EdgeInsets.only(left: 16.w, right: 10.w),
                          child: SvgPicture.asset(prefixIconPath!),
                        ),
                      ),
                prefixIconConstraints:
                    BoxConstraints(minWidth: 24.w, minHeight: 24.w),
                suffixIconConstraints:
                    BoxConstraints(minWidth: 24.w, minHeight: 24.w),
              ),
            );
          }
        },
      );
    }
  }
}
