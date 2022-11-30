// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:logger/logger.dart';

import '../../../dashboard/data/model/add_passenger_schedule_request_model.dart';
import '../../../drawer_wrapper/schedules_driver/data/models/get_drivers_list_response_model.dart';

class ActivePassengerRideModel {
  ActivePassengerRideModel(
      {required this.status,
      required this.data,
      required this.count,
      required this.verifyPin});
  String status;
  String? verifyPin;
  int count;

  late final Data data;

  factory ActivePassengerRideModel.fromJson(Map<String, dynamic> json) {
    return ActivePassengerRideModel(
        status: json['status'],
        verifyPin: json['verifyPin'],
        count: json['count'] ?? 0,
        data: Data.fromJson(json['data']));
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['count'] = count;
    _data['pin'] = verifyPin;
    _data['data'] = data.toJson();
    return _data;
  }
}

class Data {
  Data({
    required this.schedule,
    required this.route,
    required this.msg,
  });
  late final Schedule schedule;
  late final Route route;
  late final String msg;

  Data.fromJson(Map<String, dynamic> json) {
    schedule = Schedule.fromJson(json['schedule']);
    route = Route.fromJson(json['route']);
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['schedule'] = schedule.toJson();
    _data['route'] = route.toJson();
    _data['msg'] = msg;
    return _data;
  }
}

class Schedule {
  Schedule(
      {required this.userId,
      required this.startPoint,
      required this.endPoint,
      required this.boundsNe,
      required this.boundsSw,
      required this.distance,
      required this.duration,
      required this.date,
      required this.gender,
      required this.seats,
      required this.polyline,
      required this.fare,
      required this.id});
  late final UserId userId;
  late final StartPoint startPoint;
  late final EndPoint endPoint;
  late final BoundsNe boundsNe;
  late final BoundsSw boundsSw;
  late final int distance;
  late final int duration;
  late final String date;
  late final String gender;
  late final String seats;
  late final int fare;
  late final String polyline;
  late final String id;

  Schedule.fromJson(Map<String, dynamic> json) {
    userId = UserId.fromJson(json['userId']);
    startPoint = StartPoint.fromJson(json['startPoint']);
    endPoint = EndPoint.fromJson(json['endPoint']);
    boundsNe = BoundsNe.fromJson(json['bounds_ne']);
    boundsSw = BoundsSw.fromJson(json['bounds_sw']);
    distance = json['distance'];
    fare = json['fare'] ?? 0;
    duration = json['duration'];
    date = json['date'];
    gender = json['gender'];
    seats = json['seats'].toString();
    polyline = json['polyline'];
    id = json['_id'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['userId'] = userId.toJson();
    _data['startPoint'] = startPoint.toJson();
    _data['endPoint'] = endPoint.toJson();
    _data['bounds_ne'] = boundsNe.toJson();
    _data['bounds_sw'] = boundsSw.toJson();
    _data['distance'] = distance;
    _data['duration'] = duration;
    _data['date'] = date;
    _data['fare'] = fare;
    _data['gender'] = gender;
    _data['seats'] = seats;
    _data['polyline'] = polyline;
    _data['id'] = id;
    return _data;
  }
}

class UserId {
  UserId({
    required this.totalRating,
    required this.totalRatingCount,
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.mobile,
    required this.gender,
    required this.profileImage,
  });
  late final int totalRating;
  late final int totalRatingCount;
  late final String id;
  late final String firstName;
  late final String lastName;
  late final int mobile;
  late final String gender;
  late final String profileImage;

  UserId.fromJson(Map<String, dynamic> json) {
    totalRating = json['totalRating'];
    totalRatingCount = json['totalRatingCount'];
    id = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    mobile = json['mobile'];
    gender = json['gender'];
    profileImage = json['profileImage'];
  }
  String getFullName() {
    return "${firstName} ${lastName}";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['totalRating'] = totalRating;
    _data['totalRatingCount'] = totalRatingCount;
    _data['_id'] = id;
    _data['firstName'] = firstName;
    _data['lastName'] = lastName;
    _data['mobile'] = mobile;
    _data['gender'] = gender;
    _data['profileImage'] = profileImage;
    return _data;
  }
}

class Route {
  Route(
      {required this.userId,
      required this.startPoint,
      required this.endPoint,
      required this.lastLocation,
      required this.boundsNe,
      required this.boundsSw,
      required this.distance,
      required this.duration,
      required this.date,
      required this.kmLeverage,
      required this.gender,
      required this.id});
  late final UserId userId;
  late final StartPoint startPoint;
  late final EndPoint endPoint;
  late final LastLocation lastLocation;
  late final BoundsNe boundsNe;
  late final BoundsSw boundsSw;
  late final int distance;
  late final int duration;
  late final String date;
  late final int kmLeverage;
  late final String gender;
  late final String id;

  Route.fromJson(Map<String, dynamic> json) {
    userId = UserId.fromJson(json['userId']);
    startPoint = StartPoint.fromJson(json['startPoint']);
    endPoint = EndPoint.fromJson(json['endPoint']);
    lastLocation = LastLocation.fromJson(json['lastLocation']);
    boundsNe = BoundsNe.fromJson(json['bounds_ne']);
    boundsSw = BoundsSw.fromJson(json['bounds_sw']);
    distance = json['distance'];
    duration = json['duration'];
    date = json['date'];
    kmLeverage = json['kmLeverage'];
    gender = json['gender'];
    id = json['_id'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['userId'] = userId.toJson();
    _data['startPoint'] = startPoint.toJson();
    _data['endPoint'] = endPoint.toJson();
    _data['lastLocation'] = lastLocation.toJson();
    _data['bounds_ne'] = boundsNe.toJson();
    _data['bounds_sw'] = boundsSw.toJson();
    _data['distance'] = distance;
    _data['duration'] = duration;
    _data['date'] = date;
    _data['kmLeverage'] = kmLeverage;
    _data['gender'] = gender;
    _data['_id'] = id;
    return _data;
  }
}

class LastLocation {
  LastLocation({
    required this.latitude,
    required this.longitude,
  });
  late final double latitude;
  late final double longitude;

  LastLocation.fromJson(Map<String, dynamic> json) {
    latitude = double.parse(json['latitude'].toString());
    longitude = double.parse(json['longitude'].toString());
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['latitude'] = latitude;
    _data['longitude'] = longitude;
    return _data;
  }
}
