// ignore_for_file: non_constant_identifier_names

import '../../../../dashboard/data/model/add_passenger_schedule_request_model.dart';

class GetDriversListResponseModel {
  GetDriversListResponseModel({
    required this.msg,
    required this.data,
  });
  late final String msg;
  late final Data data;


  GetDriversListResponseModel.fromJson(Map<String, dynamic> json){
    msg = json['msg'];
    data = Data.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['msg'] = msg;
    _data['data'] = data.toJson();
    return _data;
  }
}

class Data {
  Data({
    required this.schedule,
    required this.nearestDriver,
  });
  late final Schedule schedule;
  late final List<NearestDriver> nearestDriver;

  Data.fromJson(Map<String, dynamic> json){
    schedule = Schedule.fromJson(json['schedule']);
    nearestDriver = List.from(json['nearestDriver']).map((e)=>NearestDriver.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['schedule'] = schedule.toJson();
    _data['nearestDriver'] = nearestDriver.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Schedule {
  Schedule({
    required this.id,
    required this.startPoint,
    required this.endPoint,
    required this.userId,
    required this.date,
    required this.isScheduled,
    required this.bookedSeats,
    required this.gender,
    required this.encodedPolyline,
    required this.request,
    required this.rejected,
    required this.cancelled,
  });
  late final String id;
  late final StartPoint startPoint;
  late final EndPoint endPoint;
  late final UserId userId;
  late final String date;
  late final bool isScheduled;
  late final int bookedSeats;
  late final String gender;
  late final String encodedPolyline;
  late final List<String> request;
  late final List<dynamic> rejected;
  late final List<dynamic> cancelled;
  late final List<dynamic> driversRequest;

  Schedule.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    startPoint = StartPoint.fromJson(json['startPoint']);
    endPoint = EndPoint.fromJson(json['endPoint']);
    userId = UserId.fromJson(json['userId']);
    date = json['date'];
    isScheduled = json['isScheduled'];
    bookedSeats = json['bookedSeats'];
    gender = json['gender'];
    encodedPolyline = json['encodedPolyline'];
    request = List.castFrom<dynamic, String>(json['request']);
    rejected = List.castFrom<dynamic, dynamic>(json['rejected']);
    cancelled = List.castFrom<dynamic, dynamic>(json['cancelled']);
    driversRequest = List.castFrom<dynamic, dynamic>(json['driverRequests']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['startPoint'] = startPoint.toJson();
    _data['endPoint'] = endPoint.toJson();
    _data['userId'] = userId.toJson();
    _data['date'] = date;
    _data['isScheduled'] = isScheduled;
    _data['bookedSeats'] = bookedSeats;
    _data['gender'] = gender;
    _data['encodedPolyline'] = encodedPolyline;
    _data['request'] = request;
    _data['rejected'] = rejected;
    _data['cancelled'] = cancelled;
    _data['driversRequest'] = driversRequest;
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

  UserId.fromJson(Map<String, dynamic> json){
    totalRating = json['totalRating'];
    totalRatingCount = json['totalRatingCount'];
    id = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    mobile = json['mobile'];
    gender = json['gender'];
    profileImage = json['profileImage'];
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

class NearestDriver {
  NearestDriver({
    required this.id,
    required this.startPoint,
    required this.endPoint,
    required this.userId,
    required this.date,
    required this.isScheduled,
    required this.availableSeats,
    required this.vehicleId,
    required this.gender,
    required this.encodedPolyline,
    required this.request,
    required this.cancelled,
    required this.rejected,
    required this.accepted,
    required this.boundsNe,
    required this.boundsSw,
    required this.fare,
  });
  late final String id;
  late final StartPoint startPoint;
  late final EndPoint endPoint;
  late final UserId userId;
  late final String date;
  late final bool isScheduled;
  late final int availableSeats;
  late final VehicleId vehicleId;
  late final String gender;
  late final String encodedPolyline;
  late final List<String> request;
  late final List<dynamic> cancelled;
  late final List<dynamic> rejected;
  late final List<dynamic> accepted;
  late final BoundsNe boundsNe;
  late final BoundsSw boundsSw;
  late final int fare;

  NearestDriver.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    startPoint = StartPoint.fromJson(json['startPoint']);
    endPoint = EndPoint.fromJson(json['endPoint']);
    userId = UserId.fromJson(json['userId']);
    date = json['date'];
    isScheduled = json['isScheduled'];
    availableSeats = json['availableSeats'];
    vehicleId = VehicleId.fromJson(json['vehicleId']);
    gender = json['gender'];
    encodedPolyline = json['encodedPolyline'];
    request = List.castFrom<dynamic, String>(json['request']);
    cancelled = List.castFrom<dynamic, dynamic>(json['cancelled']);
    rejected = List.castFrom<dynamic, dynamic>(json['rejected']);
    accepted = List.castFrom<dynamic, dynamic>(json['accepted']);
    boundsNe = BoundsNe.fromJson(json['bounds_ne']);
    boundsSw = BoundsSw.fromJson(json['bounds_sw']);
    fare = (json['fare'] as num).toInt();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['startPoint'] = startPoint.toJson();
    _data['endPoint'] = endPoint.toJson();
    _data['userId'] = userId.toJson();
    _data['date'] = date;
    _data['isScheduled'] = isScheduled;
    _data['availableSeats'] = availableSeats;
    _data['vehicleId'] = vehicleId.toJson();
    _data['gender'] = gender;
    _data['encodedPolyline'] = encodedPolyline;
    _data['request'] = request;
    _data['cancelled'] = cancelled;
    _data['rejected'] = rejected;
    _data['accepted'] = accepted;
    _data['bounds_ne'] = boundsNe.toJson();
    _data['bounds_sw'] = boundsSw.toJson();
    _data['fare'] = fare;
    return _data;
  }
}

class VehicleId {
  VehicleId({
    required this.id,
    required this.model,
    required this.year,
    required this.registrationNumber,
    required this.minMileage,
    required this.maxMileage,
    required this.AC,
    required this.heater,
    required this.color,
    required this.seatingCapacity,
    required this.genderPreference,
  });
  late final String id;
  late final Model model;
  late final int year;
  late final String registrationNumber;
  late final int minMileage;
  late final int maxMileage;
  late final bool AC;
  late final bool heater;
  late final Color color;
  late final int seatingCapacity;
  late final String genderPreference;

  VehicleId.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    model = Model.fromJson(json['model']);
    year = json['year'];
    registrationNumber = json['registrationNumber'];
    minMileage = json['minMileage'];
    maxMileage = json['maxMileage']??0;
    AC = json['AC'];
    heater = json['heater'];
    color = Color.fromJson(json['color']);
    seatingCapacity = json['seatingCapacity'];
    genderPreference = json['genderPreference']??"";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['model'] = model.toJson();
    _data['year'] = year;
    _data['registrationNumber'] = registrationNumber;
    _data['minMileage'] = minMileage;
    _data['maxMileage'] = maxMileage;
    _data['AC'] = AC;
    _data['heater'] = heater;
    _data['color'] = color.toJson();
    _data['seatingCapacity'] = seatingCapacity;
    _data['genderPreference'] = genderPreference;
    return _data;
  }
}

class Model {
  Model({
    required this.id,
    required this.model,
  });
  late final String id;
  late final String model;

  Model.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    model = json['model'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['model'] = model;
    return _data;
  }
}

class Color {
  Color({
    required this.id,
    required this.color,
  });
  late final String id;
  late final String color;

  Color.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['color'] = color;
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

  BoundsNe.fromJson(Map<String, dynamic> json){
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

class BoundsSw {
  BoundsSw({
    required this.longitude,
    required this.latitude,
  });
  late final double longitude;
  late final double latitude;

  BoundsSw.fromJson(Map<String, dynamic> json){
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