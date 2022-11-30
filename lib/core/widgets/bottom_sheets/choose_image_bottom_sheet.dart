import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

import '../../utils/files/file_utils.dart';

class ChooseImageBottomSheet {
  final BuildContext context;

  ChooseImageBottomSheet({
    required this.context,
  });

  Future show() async {
  
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
      builder: (BuildContext bottomSheetContext) {
        return Builder(builder: (context) {
          return Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.r)),
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  left: 20.w,
                  right: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [

                  ListTile(
                    onTap: () async{
                     try{
                       final file=await FileUtil.getImage(ImageSource.camera);
                     if(file!=null){
                       Navigator.of(context).pop(file);
                     }
                     }catch(e){
                       Logger().v(e);
                       // ShowSnackBar.show(e.toString());


                     }


                    },
                    leading: const Icon(Icons.camera_alt),
                    title: const Text("Camera"),
                  ),
                  ListTile(
                    onTap: () async{
                      try{
                        final file=await FileUtil.getImage(ImageSource.gallery);
                          Navigator.of(context).pop(file);

                        
                      }catch(e){
                        Logger().v(e);
                        // ShowSnackBar.show(e.toString());

                      }
                    },
                    leading: const Icon(Icons.folder),
                    title: const Text("Gallery"),
                  ),
                ],
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
