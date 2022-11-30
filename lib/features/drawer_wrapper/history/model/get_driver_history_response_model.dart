class GetDriverHistoryResponseModel {
  GetDriverHistoryResponseModel({
    required this.msg,
    required this.data,
  });
  late final String msg;
  late final List<DriverHistoryModel> data;

  GetDriverHistoryResponseModel.fromJson(Map<String, dynamic> json){
    msg = json['msg'];
    data = List.from(json['data']).map((e)=>DriverHistoryModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['msg'] = msg;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class DriverHistoryModel {
  DriverHistoryModel({
    required this.id,
    required this.startPoint,
    required this.endPoint,
    required this.date,
    required this.history,
  });
  late final String id;
  late final StartPoint startPoint;
  late final EndPoint endPoint;
  late final String date;
  late final List<DriverHistoryPassengerModel> history;

  DriverHistoryModel.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    startPoint = StartPoint.fromJson(json['startPoint']);
    endPoint = EndPoint.fromJson(json['endPoint']);
    date = json['date'];
    history = List.from(json['history']).map((e)=>DriverHistoryPassengerModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['startPoint'] = startPoint.toJson();
    _data['endPoint'] = endPoint.toJson();
    _data['date'] = date;
    _data['history'] = history.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class StartPoint {
  StartPoint({
    required this.longitude,
    required this.latitude,
    required this.placeName,
  });
  late final double longitude;
  late final double latitude;
  late final String placeName;

  StartPoint.fromJson(Map<String, dynamic> json){
    longitude = json['longitude'];
    latitude = json['latitude'];
    placeName = json['placeName'];
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
    required this.placeName,
  });
  late final double longitude;
  late final double latitude;
  late final String placeName;

  EndPoint.fromJson(Map<String, dynamic> json){
    longitude = json['longitude'];
    latitude = json['latitude'];
    placeName = json['placeName'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['longitude'] = longitude;
    _data['latitude'] = latitude;
    _data['placeName'] = placeName;
    return _data;
  }
}

class DriverHistoryPassengerModel {
  DriverHistoryPassengerModel({
    required this.id,
    required this.scheduleId,
    required this.routeId,
    required this.isRated,
  });
  late final String id;
  late final ScheduleId scheduleId;
  late final String routeId;
  late final bool isRated;

  DriverHistoryPassengerModel.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    scheduleId = ScheduleId.fromJson(json['scheduleId']);
    routeId = json['routeId'];
    isRated = json['isRated'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['scheduleId'] = scheduleId.toJson();
    _data['routeId'] = routeId;
    _data['isRated'] = isRated;
    return _data;
  }
}

class ScheduleId {
  ScheduleId({
    required this.startPoint,
    required this.endPoint,
    required this.id,
    required this.userId,
    required this.distance,
    required this.duration,
    required this.bookedSeats,
    required this.fare,

  });
  late final StartPoint startPoint;
  late final EndPoint endPoint;
  late final String id;
  late final UserId userId;
  late final int distance;
  late final int duration;
  late final int bookedSeats;
  late final int fare;


  ScheduleId.fromJson(Map<String, dynamic> json){
    startPoint = StartPoint.fromJson(json['startPoint']);
    endPoint = EndPoint.fromJson(json['endPoint']);
    id = json['_id'];
    userId = UserId.fromJson(json['userId']);
    distance = json['distance'];
    duration = json['duration'];
    bookedSeats = json['bookedSeats'];
    fare = json['fare'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['startPoint'] = startPoint.toJson();
    _data['endPoint'] = endPoint.toJson();
    _data['_id'] = id;
    _data['userId'] = userId.toJson();
    _data['distance'] = distance;
    _data['duration'] = duration;
    _data['bookedSeats'] = bookedSeats;
    _data['fare'] = fare;
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

  UserId.fromJson(Map<String, dynamic> json){
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
  String getFullname(){
    return "${firstName} ${lastName}";
  }
}