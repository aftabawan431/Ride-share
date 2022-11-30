import 'dart:convert';

import '../../../../core/modals/no_params.dart';
import '../../../authentication/auth_wrapper/data/models/login_response_modal.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/constants/app_messages.dart';

abstract class SplashLocalDatasource{

Future<User> getUser(NoParams noParams);
}


class SplashLocalDataSourceImp implements SplashLocalDatasource{
  final FlutterSecureStorage secureStorage;
  SplashLocalDataSourceImp(this.secureStorage);


  @override
  Future<User> getUser(
      NoParams params) async {
    try {
      final user=await secureStorage.read(key: 'user');
      if(user!=null){
        final res=User.fromJson(jsonDecode(user));

        return res;
      }
      throw const SomethingWentWrong(AppMessages.somethingWentWrong);
    } catch (e) {
      throw SomethingWentWrong(e.toString());
    }
  }
}