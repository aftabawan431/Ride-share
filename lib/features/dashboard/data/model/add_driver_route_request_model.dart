


// ignore_for_file: non_constant_identifier_names

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'add_passenger_schedule_request_model.dart';

class AddPassengerScheduleRequestModel {
  AddPassengerScheduleRequestModel({
    required this.userId,
    required this.startPoint,
    required this.endPoint,
    required this.date,
    required this.time,
    required this.isScheduled,
    required this.availableSeats,
    required this.vehicleId,
    required this.gender,
    required this.polyline,
    required this.bounds_ne,
    required this.bounds_sw,
    required this.distance,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.activeCorporateCode,
    required this.corporateCode,

  });
  late final String userId;
  late final StartPoint startPoint;
  late final EndPoint endPoint;
  late final String date;
  late final String time;
  late final bool isScheduled;
  late final String availableSeats;
  late final String vehicleId;
  late final String gender;
  late final String polyline;
  late final LatLng bounds_sw;
  late final LatLng bounds_ne;
  late final String startTime;
  late final String endTime;
  late final String distance;
  late final bool activeCorporateCode;
  late final int duration;
  late final String corporateCode;



  AddPassengerScheduleRequestModel.fromJson(Map<String, dynamic> json){
    userId = json['userId'];
    startPoint = StartPoint.fromJson(json['startPoint']);
    endPoint = EndPoint.fromJson(json['endPoint']);
    date = json['date'];
    time = json['time'];
    isScheduled = json['isScheduled'];
    availableSeats = json['availableSeats'];
    vehicleId = json['vehicleId'];
    gender = json['gender'];
    polyline = json['polyline'];
    bounds_ne = json['bounds_ne'];
    bounds_sw = json['bounds_sw'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    activeCorporateCode = json['activeCorporateCode'];
    distance = json['distance'];
    duration = json['duration'];
    corporateCode = json['corporateCode'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['userId'] = userId;
    _data['startPoint'] = startPoint.toJson();
    _data['endPoint'] = endPoint.toJson();
    _data['date'] = date;
    _data['time'] = time;
    _data['activeCorporateCode'] = activeCorporateCode;
    _data['isScheduled'] = isScheduled;
    _data['availableSeats'] = availableSeats;
    _data['vehicleId'] = vehicleId;
    _data['gender'] = gender;
    _data['bounds_sw'] = bounds_sw.toJson();
    _data['bounds_ne'] = bounds_ne.toJson();
    _data['polyline'] = polyline;
    _data['startTime'] = startTime;
    _data['endTime'] = endTime;
    _data['distance'] = distance;
    _data['duration'] = duration;
    _data['corporateCode'] = corporateCode;
    return _data;
  }
}



