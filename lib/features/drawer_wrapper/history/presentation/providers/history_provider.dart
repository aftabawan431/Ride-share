import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import '../../domain/usecases/get_driver_history_response_model.dart';
import '../../model/get_driver_history_response_model.dart';
import '../../model/get_history_request_model.dart';
import '../../model/get_history_response_model.dart';
import '../../../schedules_driver/domain/repository/drawer_wrapper_repository.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/utils/globals/globals.dart';
import '../../../../../core/utils/globals/snake_bar.dart';
import '../../../../authentication/auth_wrapper/presentation/providers/auth_provider.dart';
import '../../domain/usecases/get_history_usecase.dart';

class HistoryProvider extends ChangeNotifier {
  DrawerWrapperRepository repository;
  GetHistoryUsecase getHistoryUsecase;
  GetDriverHistoryUsecase getDriverHistoryUsecase;

  HistoryProvider(
      this.repository, this.getHistoryUsecase, this.getDriverHistoryUsecase);

  //properties
  GetHistoryResponseModel? getHistoryResponseModel;
  GetDriverHistoryResponseModel? getDriverHistoryResponseModel;
  bool readMoreHistoryLoading = false;
  bool showReadMoreHistory = false;
  int radMoreHistoryPageNumber = 0;

  //value notifiers
  ValueNotifier<bool> getHistoryLoading = ValueNotifier(false);

  Future<void> getHistory(
      {bool recall = false, bool isFirstTime = true}) async {
    if (isFirstTime) {
      getHistoryLoading.value = true;
      showReadMoreHistory = true;
      radMoreHistoryPageNumber = 0;
    } else {
      readMoreHistoryLoading = true;
      notifyListeners();
    }

    AuthProvider authProvider = sl();

    var params = GetHistoryRequestModel(
        userId: authProvider.currentUser!.id,
        isDriver: authProvider.currentUser!.selectedUserType == '1',
    page: radMoreHistoryPageNumber
    );

    var loginEither = await getHistoryUsecase(params);

    if (loginEither.isLeft()) {
      handleError(loginEither);
      getHistoryLoading.value = false;
    } else if (loginEither.isRight()) {
      loginEither.foldRight(null, (response, previous) async {
        getHistoryLoading.value = false;
        radMoreHistoryPageNumber = radMoreHistoryPageNumber + 1;
        if (!isFirstTime) {
          if (response.data.isEmpty || response.data.length < 5) {
            showReadMoreHistory = false;
          }
          readMoreHistoryLoading = false;
          getHistoryResponseModel!.data.addAll(response.data);
        } else {

          if (response.data.length < 5) {
            showReadMoreHistory = false;
          }
          getHistoryLoading.value = false;
          getHistoryResponseModel = response;
        }

        notifyListeners();
      });
    }
  }

  Future<void> getDriverHistory(
      {bool recall = false, bool isFirstTime = true}) async {
    AuthProvider authProvider = sl();
    if (isFirstTime) {
      getHistoryLoading.value = true;
      showReadMoreHistory = true;
      radMoreHistoryPageNumber = 0;
    } else {
      readMoreHistoryLoading = true;
      notifyListeners();
    }

    var params = GetHistoryRequestModel(
        userId: authProvider.currentUser!.id,
        isDriver: authProvider.currentUser!.selectedUserType == '1',
    page: radMoreHistoryPageNumber
    );

    var loginEither = await getDriverHistoryUsecase(params);

    if (loginEither.isLeft()) {
      handleError(loginEither);
      getHistoryLoading.value = false;
    } else if (loginEither.isRight()) {
      loginEither.foldRight(null, (response, previous) async {
        getHistoryLoading.value = false;
        radMoreHistoryPageNumber = radMoreHistoryPageNumber + 1;
        if (!isFirstTime) {
          if (response.data.isEmpty || response.data.length < 5) {
            showReadMoreHistory = false;
          }
          readMoreHistoryLoading = false;
          getDriverHistoryResponseModel!.data.addAll(response.data);
        } else {
          if (response.data.length < 5) {
            showReadMoreHistory = false;
          }
          getHistoryLoading.value = false;
          getDriverHistoryResponseModel = response;
        }

        notifyListeners();
      });
    }
  }

  //error handlers

  void handleError(Either<Failure, dynamic> either) {
    either.fold((l) => ShowSnackBar.show(l.message), (r) => null);
  }
}
