import '../../../../dashboard/data/model/add_passenger_schedule_request_model.dart';

class GetPassengerSchdulesResponseModel {
  GetPassengerSchdulesResponseModel({
    required this.data,
  });
  late final List<Data> data;

  GetPassengerSchdulesResponseModel.fromJson(Map<String, dynamic> json){
    data = List.from(json['data']).map((e)=>Data.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
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
    required this.isScheduled,
    required this.bookedSeats,
    required this.gender,
    required this.encodedPolyline,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.accepted,
    required this.duration,
    required this.distance,
    required this.startTime,
    required this.endTime,

  });
  late final StartPoint startPoint;
  late final EndPoint endPoint;
  late final String id;
  late final UserId userId;
  late final String date;
  late final String startTime;
  late final String endTime;
  late final bool isScheduled;
  late final int bookedSeats;
  late final String gender;
  late final String encodedPolyline;
  late final String createdAt;
  late final String updatedAt;
  late final String status;
  late final String? accepted;
  late final int distance;
  late final int duration;

  Data.fromJson(Map<String, dynamic> json){
    startPoint = StartPoint.fromJson(json['startPoint']);
    endPoint = EndPoint.fromJson(json['endPoint']);
    id = json['_id'];
    userId = UserId.fromJson(json['userId']);
    date = json['date'];
    isScheduled = json['isScheduled'];
    bookedSeats = json['bookedSeats'];
    gender = json['gender'];
    encodedPolyline = json['encodedPolyline'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    status = json['status'];
    accepted = json['accepted'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    distance = json['distance']??0;
    duration = json['duration']??0;

  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['startPoint'] = startPoint.toJson();
    _data['endPoint'] = endPoint.toJson();
    _data['_id'] = id;
    _data['userId'] = userId.toJson();
    _data['date'] = date;
    _data['isScheduled'] = isScheduled;
    _data['bookedSeats'] = bookedSeats;
    _data['gender'] = gender;
    _data['encodedPolyline'] = encodedPolyline;
    _data['createdAt'] = createdAt;
    _data['updatedAt'] = updatedAt;
    _data['status'] = status;
    _data['accepted'] = accepted;
    _data['duration'] = duration;
    _data['startTime'] = startTime;
    _data['endTime'] = endTime;
    _data['distance'] = distance;
    _data['distance'] = distance;
    return _data;
  }
}



class UserId {
  UserId({
    required this.totalRating,
    required this.totalRatingCount,
    required this.id,
    required this.firstName,
    required this.profileImage,
    required this.lastName,
  });
  late final int totalRating;
  late final int totalRatingCount;
  late final String id;
  late final String profileImage;
  late final String firstName;
  late final String lastName;

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


