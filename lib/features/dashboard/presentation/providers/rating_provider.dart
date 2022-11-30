import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import '../../../../core/router/app_state.dart';
import '../../data/model/add_rating_request_model.dart';
import '../../domain/usecase/add_rating_usecase.dart';
import 'driver_dashboard_provider.dart';
import '../../../drawer_wrapper/history/presentation/providers/history_provider.dart';
import 'package:logger/logger.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/globals/globals.dart';
import '../../../../core/utils/globals/loading.dart';
import '../../../../core/utils/globals/snake_bar.dart';
import '../../../authentication/auth_wrapper/presentation/providers/auth_provider.dart';

class RatingProvider extends ChangeNotifier {
  RatingProvider(this.addRatingUsecase);

  //properties

  TextEditingController textController = TextEditingController();

  //usecases

  AddRatingUsecase addRatingUsecase;

  //properties
  String? routeId;
  String? scheduleId;
  String? ratingTo;
  String? fullName;
  String? profileImage;
  String? historyId;
  bool popTwice=true;



  //value listener
  ValueNotifier<bool> addRatingLoading = ValueNotifier(false);

  Future<void> addRating(double rating) async {
    addRatingLoading.value = true;
    AuthProvider _authProvider = sl();

    final params = AddRatingRequestModel(
        ratingBy: _authProvider.currentUser!.id,
        ratingTo: ratingTo!,
        routeId: routeId!,
        text: textController.text,
        isDriver: _authProvider.currentUser!.selectedUserType=='1',
        rating: rating,
        scheduleId: scheduleId!,
      historyId: historyId

    );
    Logger().v(params.toJson());

    var loginEither = await addRatingUsecase(params);

    if (loginEither.isLeft()) {
      Loading.dismiss();
      handleError(loginEither);
      addRatingLoading.value = false;
    } else if (loginEither.isRight()) {
      loginEither.foldRight(null, (response, previous) async {
        addRatingLoading.value=false;
        if(_authProvider.currentUser!.selectedUserType=='1'){
          HistoryProvider historyProvider=sl();

          historyProvider.getDriverHistory(recall: true);
        }else{
          HistoryProvider historyProvider=sl();
          historyProvider.getHistory(recall: true);
        }

        textController.clear();
        ShowSnackBar.show('Ride rated successfully!');
        AppState appState=sl();


        appState.moveToBackScreen();
        if(popTwice){

          Timer(const Duration(milliseconds: 500), () {
            DashboardProvider dashboardProvider=sl();
            dashboardProvider.dashboardScaffoldKey.currentState!.closeDrawer();
            appState.moveToBackScreen();
          });
        }

        popTwice=true;



      });
    }
  }

  // Error Handling
  void handleError(Either<Failure, dynamic> either) {
    either.fold((l) => ShowSnackBar.show(l.message), (r) => null);
  }
}
