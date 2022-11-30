import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/modals/no_params.dart';
import '../../../../../core/utils/globals/snake_bar.dart';
import '../../data/models/get_notifications_response_model.dart';
import '../../domain/usecases/getNotificationsUsecase.dart';

class SystemNotificationsProvider extends ChangeNotifier {
  SystemNotificationsProvider(this._getNotificationsUsecase);
  //usecases
  final GetNotificationsUsecase _getNotificationsUsecase;


  //properties
  GetNotificationsResponseModel? getNotificationsResponseModel;
  //value notifiers
  ValueNotifier<bool> getNotificationsLoading=ValueNotifier(false);

  //usecases calls

  Future<void> getNotifications() async {
    getNotificationsLoading.value = true;

    var params = NoParams();

    var requestEither = await _getNotificationsUsecase(params);

    if (requestEither.isLeft()) {
      handleError(requestEither);
      getNotificationsLoading.value = false;
    } else if (requestEither.isRight()) {
      requestEither.foldRight(null, (response, previous) async {
        getNotificationsLoading.value = false;
        getNotificationsResponseModel = response;
        notifyListeners();
      });
    }
  }



  //handle error
  void handleError(Either<Failure, dynamic> either) {
    either.fold((l) => ShowSnackBar.show(l.message), (r) => null);
  }



}
