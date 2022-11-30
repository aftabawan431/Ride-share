


// ignore_for_file: non_constant_identifier_names

import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddDriverRouteRequestModel {
  AddDriverRouteRequestModel({
    required this.userId,
    required this.startPoint,
    required this.endPoint,
    required this.date,
    required this.isScheduled,
    required this.availableSeats,
    required this.vehicleId,
    required this.gender,
    required this.polyline,
    required this.bounds_ne,
    required this.bounds_sw,
    required this.distance,
    required this.kmLeverage,
    required this.duration,
  required this.activeCorporateCode,
  required this.corporateCode,

  });
  late final String userId;
  late final StartPoint startPoint;
  late final EndPoint endPoint;
  late final String date;
  late final bool isScheduled;
  late final String availableSeats;
  late final String vehicleId;
  late final String gender;
  late final String polyline;
  late final LatLng bounds_sw;
  late final LatLng bounds_ne;
  late final int kmLeverage;
  late final int distance;
  late final int duration;
  late final bool activeCorporateCode;
  late final String corporateCode;


  AddDriverRouteRequestModel.fromJson(Map<String, dynamic> json){
    userId = json['userId'];
    startPoint = StartPoint.fromJson(json['startPoint']);
    endPoint = EndPoint.fromJson(json['endPoint']);
    date = json['date'];
    isScheduled = json['isScheduled'];
    availableSeats = json['availableSeats'];
    vehicleId = json['vehicleId'];
    gender = json['gender'];
    polyline = json['polyline'];
    bounds_ne = json['bounds_ne'];
    bounds_sw = json['bounds_sw'];
    kmLeverage = json['kmLeverage'];
    distance = json['distance'];
    duration=json['duration'];
    corporateCode=json['corporateCode'];
activeCorporateCode=json['activeCorporateCode'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['userId'] = userId;
    _data['startPoint'] = startPoint.toJson();
    _data['endPoint'] = endPoint.toJson();
    _data['date'] = date;
    _data['isScheduled'] = isScheduled;
    _data['availableSeats'] = availableSeats;
    _data['vehicleId'] = vehicleId;
    _data['gender'] = gender;
    _data['bounds_sw'] = bounds_sw.toJson();
    _data['bounds_ne'] = bounds_ne.toJson();
    _data['polyline'] = polyline;
    _data['kmLeverage'] = kmLeverage;
    _data['distance'] = distance;
    _data['duration'] = duration;
    _data['corporateCode'] = corporateCode;
    _data['activeCorporateCode'] = activeCorporateCode;
    return _data;
  }
}

class StartPoint {
  StartPoint({
    required this.longitude,
    required this.latitude,
    required this.placeName
  });
  late final String longitude;
  late final String latitude;
  late final String placeName;

  StartPoint.fromJson(Map<String, dynamic> json){
    longitude = json['longitude'].toString();
    latitude = json['latitude'].toString();
    placeName = json['placeName'].toString();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['longitude'] = longitude;
    _data['latitude'] = latitude;
    _data['placeName'] = placeName;
    return _data;
  }
}

class EndPoint {
  EndPoint({
    required this.longitude,
    required this.latitude,
    required this.placeName

  });
  late final String longitude;
  late final String latitude;
  late final String placeName;


  EndPoint.fromJson(Map<String, dynamic> json){
    longitude = json['longitude'].toString();
    latitude = json['latitude'].toString();
    placeName = json['placeName'].toString();

  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['longitude'] = longitude;
    _data['latitude'] = latitude;
    _data['placeName'] = placeName;

    return _data;
  }
}