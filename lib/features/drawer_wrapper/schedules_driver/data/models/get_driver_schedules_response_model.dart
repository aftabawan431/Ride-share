

import '../../../../dashboard/data/model/add_passenger_schedule_request_model.dart';

class GetDriverSchedulesResponseModel {
  GetDriverSchedulesResponseModel({
    required this.msg,
    required this.data,
  });
  late final String msg;
  late final List<Data> data;

  GetDriverSchedulesResponseModel.fromJson(Map<String, dynamic> json){
    msg = json['msg'];
    data = List.from(json['data']).map((e)=>Data.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['msg'] = msg;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Data {
  Data({
    required this.startPoint,
    required this.endPoint,
    required this.id,
    required this.userId,
    required this.date,
    required this.availableSeats,
    required this.gender,
    required this.status,
    required this.distance,
    required this.duration,
    required this.initialSeats,
    required this.stutus,
    required this.kmLeverage
  });
  late final StartPoint startPoint;
  late final EndPoint endPoint;
  late final String id;
  late final UserId userId;
  late final String date;
  late final int availableSeats;
  late final String gender;
  late final int distance;
  late final int duration;
  late final int initialSeats;
  late final String stutus;
  late final int kmLeverage;
  String status;

 factory Data.fromJson(Map<String, dynamic> json){
   return Data(startPoint: StartPoint.fromJson(json['startPoint']),
       endPoint: EndPoint.fromJson(json['endPoint']),
       id: json['_id'], userId: UserId.fromJson(json['userId']),
       date: json['date'],
       availableSeats: json['availableSeats'],
       gender: json['gender'],

       duration: json['duration'],
       distance: json['distance'],
       stutus: json['status'],
       initialSeats: json['initialSeats'],
       kmLeverage: json['kmLeverage'],
       status: json['status']);

  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['startPoint'] = startPoint.toJson();
    _data['endPoint'] = endPoint.toJson();
    _data['_id'] = id;
    _data['userId'] = userId.toJson();
    _data['date'] = date;
    _data['availableSeats'] = availableSeats;
    _data['gender'] = gender;

    _data['duration'] = duration;
    _data['status'] = status;
    _data['distance'] = distance;
    _data['initialSeats'] = initialSeats;
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
    required this.profileImage
  });
  late final int totalRating;
  late final int totalRatingCount;
  late final String id;
  late final String firstName;
  late final String lastName;
  late final String profileImage;

  UserId.fromJson(Map<String, dynamic> json){
    totalRating = json['totalRating'];
    totalRatingCount = json['totalRatingCount'];
    id = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    profileImage = json['profileImage'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['totalRating'] = totalRating;
    _data['totalRatingCount'] = totalRatingCount;
    _data['_id'] = id;
    _data['firstName'] = firstName;
    _data['lastName'] = lastName;
    _data['profileImage'] = profileImage;
    return _data;
  }
}