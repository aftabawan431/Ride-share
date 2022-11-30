import 'package:flutter_easyloading/flutter_easyloading.dart';

class Loading{
   static Future show({String message='Loading'}){
   return  EasyLoading.show(status: message);
  }

  static dismiss(){
    EasyLoading.dismiss();
  }

}