import '../../../dashboard/data/model/add_passenger_schedule_request_model.dart';

class GetHistoryResponseModel {
  GetHistoryResponseModel({
    required this.msg,
    required this.data,
  });
  late final String msg;
  late final List<Data> data;

  GetHistoryResponseModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    data = List.from(json['data']).map((e) => Data.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['msg'] = msg;
    _data['data'] = data.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Data {
  Data({
    required this.id,
    required this.userId,
    required this.routeId,
    required this.scheduleId,
    required this.isDriver,
    required this.isRated,
    required this.createdAt,
    required this.updatedAt,
  });
  late final String id;
  late final String userId;
  late final RouteId routeId;
  late final ScheduleId scheduleId;
  late final bool isDriver;
  late final bool isRated;
  late final String createdAt;
  late final String updatedAt;

  Data.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    userId = json['userId'];
    routeId = RouteId.fromJson(json['routeId']);
    scheduleId = ScheduleId.fromJson(json['scheduleId']);
    isDriver = json['isDriver'];
    isRated = json['isRated'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['userId'] = userId;
    _data['routeId'] = routeId.toJson();
    _data['scheduleId'] = scheduleId.toJson();
    _data['isDriver'] = isDriver;
    _data['isRated'] = isRated;
    _data['createdAt'] = createdAt;
    _data['updatedAt'] = updatedAt;
    return _data;
  }
}

class RouteId {
  RouteId(
      {required this.startPoint,
      required this.endPoint,
      required this.boundsSw,
      required this.boundsNe,
      required this.id,
      required this.userId,
      required this.date,
      required this.isScheduled,
      required this.gender,
      required this.encodedPolyline,
      required this.createdAt,
      required this.updatedAt,
      required this.distance,
      required this.duration});
  late final StartPoint startPoint;
  late final EndPoint endPoint;
  late final BoundsSw boundsSw;
  late final BoundsNe boundsNe;
  late final String id;
  late final UserId userId;
  late final String date;
  late final bool isScheduled;
  late final String gender;
  late final String encodedPolyline;
  late final String createdAt;
  late final String updatedAt;
  late final int distance;
  late final int duration;

  RouteId.fromJson(Map<String, dynamic> json) {
    startPoint = StartPoint.fromJson(json['startPoint']);
    endPoint = EndPoint.fromJson(json['endPoint']);
    boundsSw = BoundsSw.fromJson(json['bounds_sw']);
    boundsNe = BoundsNe.fromJson(json['bounds_ne']);
    id = json['_id'];
    userId = UserId.fromJson(json['userId']);
    date = json['date'];
    isScheduled = json['isScheduled'];
    gender = json['gender'];
    encodedPolyline = json['encodedPolyline'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    distance = json['distance'];
    duration = json['duration'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['startPoint'] = startPoint.toJson();
    _data['endPoint'] = endPoint.toJson();
    _data['bounds_sw'] = boundsSw.toJson();
    _data['bounds_ne'] = boundsNe.toJson();
    _data['_id'] = id;
    _data['userId'] = userId.toJson();
    _data['date'] = date;
    _data['isScheduled'] = isScheduled;
    _data['gender'] = gender;
    _data['encodedPolyline'] = encodedPolyline;
    _data['createdAt'] = createdAt;
    _data['duration'] = duration;
    _data['distance'] = distance;
    _data['updatedAt'] = updatedAt;
    return _data;
  }
}

class BoundsSw {
  BoundsSw({
    required this.longitude,
    required this.latitude,
  });
  late final double longitude;
  late final double latitude;

  BoundsSw.fromJson(Map<String, dynamic> json) {
    longitude = json['longitude'];
    latitude = json['latitude'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['longitude'] = longitude;
    _data['latitude'] = latitude;
    return _data;
  }
}

class BoundsNe {
  BoundsNe({
    required this.longitude,
    required this.latitude,
  });
  late final double longitude;
  late final double latitude;

  BoundsNe.fromJson(Map<String, dynamic> json) {
    longitude = json['longitude'];
    latitude = json['latitude'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['longitude'] = longitude;
    _data['latitude'] = latitude;
    return _data;
  }
}

class UserId {
  UserId({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.totalRating,
    required this.totalRatingCount,
    required this.profileImage,
  });
  late final String id;
  late final String firstName;
  late final String lastName;
  late final String gender;
  late final int totalRating;
  late final int totalRatingCount;
  late final String profileImage;

  UserId.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    gender = json['gender'];
    totalRating = json['totalRating'];
    totalRatingCount = json['totalRatingCount'];
    profileImage = json['profileImage'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['firstName'] = firstName;
    _data['lastName'] = lastName;
    _data['gender'] = gender;
    _data['totalRating'] = totalRating;
    _data['totalRatingCount'] = totalRatingCount;
    _data['profileImage'] = profileImage;
    return _data;
  }
}

class ScheduleId {
  ScheduleId({
    required this.startPoint,
    required this.endPoint,
    required this.boundsSw,
    required this.boundsNe,
    required this.id,
    required this.userId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.isScheduled,
    required this.distance,
    required this.duration,
    required this.bookedSeats,
    required this.gender,
    required this.encodedPolyline,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.fare
  });
  late final StartPoint startPoint;
  late final EndPoint endPoint;
  late final BoundsSw boundsSw;
  late final BoundsNe boundsNe;
  late final String id;
  late final UserId userId;
  late final String date;
  late final String startTime;
  late final String endTime;
  late final bool isScheduled;
  late final int distance;
  late final int duration;
  late final String fare;
  late final int bookedSeats;
  late final String gender;
  late final String encodedPolyline;
  late final String status;
  late final String createdAt;
  late final String updatedAt;

  ScheduleId.fromJson(Map<String, dynamic> json) {
    startPoint = StartPoint.fromJson(json['startPoint']);
    endPoint = EndPoint.fromJson(json['endPoint']);
    boundsSw = BoundsSw.fromJson(json['bounds_sw']);
    boundsNe = BoundsNe.fromJson(json['bounds_ne']);
    id = json['_id'];
    userId = UserId.fromJson(json['userId']);
    date = json['date'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    fare = json['fare'].toString();
    isScheduled = json['isScheduled'];
    distance = json['distance'];
    duration = json['duration'];
    bookedSeats = json['bookedSeats'];
    gender = json['gender'];
    encodedPolyline = json['encodedPolyline'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['startPoint'] = startPoint.toJson();
    _data['endPoint'] = endPoint.toJson();
    _data['bounds_sw'] = boundsSw.toJson();
    _data['bounds_ne'] = boundsNe.toJson();
    _data['_id'] = id;
    _data['userId'] = userId.toJson();
    _data['date'] = date;
    _data['fare'] = fare;
    _data['startTime'] = startTime;
    _data['endTime'] = endTime;
    _data['isScheduled'] = isScheduled;
    _data['distance'] = distance;
    _data['duration'] = duration;
    _data['bookedSeats'] = bookedSeats;
    _data['gender'] = gender;
    _data['encodedPolyline'] = encodedPolyline;
    _data['status'] = status;
    _data['createdAt'] = createdAt;
    _data['updatedAt'] = updatedAt;
    return _data;
  }
}
