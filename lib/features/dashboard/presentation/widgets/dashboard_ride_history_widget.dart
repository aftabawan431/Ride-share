import '../../../../core/utils/extension/extensions.dart';

import '../../data/model/add_passenger_schedule_request_model.dart';

class DashboardRideHistoryReponseModel {
  DashboardRideHistoryReponseModel({
    required this.msg,
    required this.data,
  });
  late final String msg;
  late final List<DashboardRideHistoryModel> data;

  DashboardRideHistoryReponseModel.fromJson(Map<String, dynamic> json){
    msg = json['msg'];
    data = List.from(json['data']).map((e)=>DashboardRideHistoryModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['msg'] = msg;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class DashboardRideHistoryModel {
  DashboardRideHistoryModel({
    required this.startPoint,
    required this.endPoint,
    required this.id,
    required this.userId,
    required this.startTime,
    required this.endTime,
    required this.date,
    required this.status
  });
  late final StartPoint startPoint;
  late final EndPoint endPoint;
  late final String id;
  late final UserId userId;
  late final String? startTime;
  late final String? endTime;
  late final String? date;
  late final String? status;

  DashboardRideHistoryModel.fromJson(Map<String, dynamic> json){
    startPoint = StartPoint.fromJson(json['startPoint']);
    endPoint = EndPoint.fromJson(json['endPoint']);
    id = json['_id'];
    userId = UserId.fromJson(json['userId']);
    startTime = json['startTime'];
    date = json['date'];
    status = json['status'];
    endTime = json['endTime'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['startPoint'] = startPoint.toJson();
    _data['endPoint'] = endPoint.toJson();
    _data['_id'] = id;
    _data['userId'] = userId.toJson();
    _data['startTime'] = startTime;
    _data['date'] = date;
    _data['status'] = status;
    _data['endTime'] = endTime;
    return _data;
  }
}


class UserId {
  UserId({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.totalRating,
    required this.totalRatingCount,
    required this.profileImage,
  });
  late final String id;
  late final String firstName;
  late final String lastName;
  late final int totalRating;
  late final int totalRatingCount;
  late final String profileImage;

  UserId.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    totalRating = json['totalRating'];
    totalRatingCount = json['totalRatingCount'];
    profileImage = json['profileImage'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['firstName'] = firstName;
    _data['lastName'] = lastName;
    _data['totalRating'] = totalRating;
    _data['totalRatingCount'] = totalRatingCount;
    _data['profileImage'] = profileImage;
    return _data;
  }
  String getFullName(){
    return ("${firstName} ${lastName}").toTitleCase();
  }
}