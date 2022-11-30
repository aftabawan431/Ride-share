import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../utils/globals/globals.dart';

import '../modals/place_prediction.dart';

class PlacesProvider extends ChangeNotifier {
  List<PlacePridictions> placePredictionList = [];

  Dio dio;
  PlacesProvider(this.dio);

  getPlaces(String value) async {
    if (value.length > 1) {
      String autoCompleteUrl =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$value&key=$mapKey&sessiontoken=1234567890&components=country:pk';
      Logger().v(autoCompleteUrl);
      final result = await dio.get(autoCompleteUrl);
      placePredictionList.clear();
      placePredictionList = result.data['predictions']
          .map<PlacePridictions>((item) => PlacePridictions.fromJson(item))
          .toList();
      notifyListeners();
    }
  }
}
