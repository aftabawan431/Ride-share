import '../../../../dashboard/data/model/add_passenger_schedule_request_model.dart';
import 'get_drivers_list_response_model.dart';

class GetRequestedPassengerResponseModel {
  GetRequestedPassengerResponseModel({required this.msg, required this.data,
  required this.matchedPassengers});
  late final String msg;
  late final Data data;
  late final List<RequestedPassengerRequest> matchedPassengers;


  GetRequestedPassengerResponseModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    data = Data.fromJson(json['data'],

    );
    matchedPassengers = List.from(json['matchedPassengers'])
        .map((e) => RequestedPassengerRequest.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['msg'] = msg;
    _data['data'] = data.toJson();
    _data['matchedPassengers'] =
        matchedPassengers.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Data {
  Data(
      {required this.startPoint,
      required this.endPoint,
      required this.boundsSw,
      required this.boundsNe,
      required this.id,
      required this.userId,
      required this.date,
      required this.isScheduled,
      required this.availableSeats,
      required this.distance,
      required this.duration,
      required this.kmLeverage,
      required this.request,
      required this.cancelled,
      required this.rejected,
      required this.accepted,
      required this.vehicleId,
      required this.gender,
      required this.encodedPolyline,
      required this.createdAt,
      required this.updatedAt,
      required this.initialSeats,
      required this.myRequests,
      required this.status});
  late final StartPoint startPoint;
  late final EndPoint endPoint;
  late final BoundsSw boundsSw;
  late final BoundsNe boundsNe;
  late final String id;
  late final String userId;
  late final String date;
  late final bool isScheduled;
  late final int availableSeats;
  late final int distance;
  late final int duration;
  late final int kmLeverage;
  late final String status;
  late final List<RequestedPassengerRequest> request;
  late final List<dynamic> cancelled;
  late final List<dynamic> rejected;
  late final List<dynamic> accepted;
  late final List<dynamic> myRequests;
  late final String vehicleId;
  late final String gender;
  late final String encodedPolyline;
  late final String createdAt;
  late final String updatedAt;
  late final int initialSeats;

  Data.fromJson(Map<String, dynamic> json) {
    startPoint = StartPoint.fromJson(json['startPoint']);
    endPoint = EndPoint.fromJson(json['endPoint']);
    boundsSw = BoundsSw.fromJson(json['bounds_sw']);
    boundsNe = BoundsNe.fromJson(json['bounds_ne']);
    id = json['_id'];
    userId = json['userId'];
    date = json['date'];
    status = json['status'];
    isScheduled = json['isScheduled'];
    availableSeats = json['availableSeats'];
    distance = json['distance'];
    duration = json['duration'];
    kmLeverage = json['kmLeverage'];
    request = List.from(json['request'])
        .map((e) => RequestedPassengerRequest.fromJson(e))
        .toList();

    cancelled = List.castFrom<dynamic, dynamic>(json['cancelled']);
    rejected = List.castFrom<dynamic, dynamic>(json['rejected']);
    accepted = List.castFrom<dynamic, dynamic>(json['accepted']);
    myRequests = List.castFrom<dynamic, dynamic>(json['myRequests']);
    vehicleId = json['vehicleId'];
    gender = json['gender'];
    encodedPolyline = json['encodedPolyline'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    initialSeats = json['initialSeats'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['startPoint'] = startPoint.toJson();
    _data['endPoint'] = endPoint.toJson();
    _data['bounds_sw'] = boundsSw.toJson();
    _data['bounds_ne'] = boundsNe.toJson();
    _data['_id'] = id;
    _data['userId'] = userId;
    _data['date'] = date;
    _data['isScheduled'] = isScheduled;
    _data['availableSeats'] = availableSeats;
    _data['distance'] = distance;
    _data['duration'] = duration;
    _data['status'] = status;
    _data['kmLeverage'] = kmLeverage;
    _data['request'] = request.map((e) => e.toJson()).toList();

    _data['cancelled'] = cancelled;
    _data['rejected'] = rejected;
    _data['accepted'] = accepted;
    _data['myRequests'] = myRequests;
    _data['vehicleId'] = vehicleId;
    _data['gender'] = gender;
    _data['encodedPolyline'] = encodedPolyline;
    _data['createdAt'] = createdAt;
    _data['updatedAt'] = updatedAt;
    _data['initialSeats'] = initialSeats;
    return _data;
  }
}


class RequestedPassengerRequest {
  RequestedPassengerRequest({
    required this.startPoint,
    required this.endPoint,
    required this.boundsSw,
    required this.boundsNe,
    required this.id,
    required this.userId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.distance,
    required this.duration,
    required this.bookedSeats,
    required this.gender,
    required this.encodedPolyline,
    required this.createdAt,
    required this.updatedAt,
    required this.status,

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
  late final int distance;
  late final int duration;
  late final int fare;
  late final int bookedSeats;
  late final String gender;
  late final String encodedPolyline;
  late final String createdAt;
  late final String updatedAt;
  late final String status;

  RequestedPassengerRequest.fromJson(Map<String, dynamic> json) {
    startPoint = StartPoint.fromJson(json['startPoint']);
    endPoint = EndPoint.fromJson(json['endPoint']);
    boundsSw = BoundsSw.fromJson(json['bounds_sw']);
    boundsNe = BoundsNe.fromJson(json['bounds_ne']);
    id = json['_id'];
    userId = UserId.fromJson(json['userId']);
    date = json['date'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    distance = json['distance'];
    duration = json['duration'];
    fare = (json['fare'] as num).toInt();
    bookedSeats = json['bookedSeats'];
    gender = json['gender'];
    encodedPolyline = json['encodedPolyline'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    status = json['status'];
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
    _data['startTime'] = startTime;
    _data['endTime'] = endTime;
    _data['distance'] = distance;
    _data['duration'] = duration;
    _data['fare'] = fare;
    _data['bookedSeats'] = bookedSeats;
    _data['gender'] = gender;
    _data['encodedPolyline'] = encodedPolyline;
    _data['createdAt'] = createdAt;
    _data['updatedAt'] = updatedAt;
    _data['status'] = status;
    return _data;
  }
}


class UserId {
  UserId(
      {required this.totalRating,
      required this.totalRatingCount,
      required this.id,
      required this.firstName,
      required this.lastName,
      required this.profileImage,
      required this.gender});
  late final int totalRating;
  late final int totalRatingCount;
  late final String id;
  late final String firstName;
  late final String lastName;
  late final String gender;
  late final String profileImage;

  UserId.fromJson(Map<String, dynamic> json) {
    totalRating = json['totalRating'];
    totalRatingCount = json['totalRatingCount'];
    id = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    profileImage = json['profileImage'];
    gender = json['gender'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['totalRating'] = totalRating;
    _data['totalRatingCount'] = totalRatingCount;
    _data['_id'] = id;
    _data['firstName'] = firstName;
    _data['lastName'] = lastName;
    _data['profileImage'] = profileImage;
    _data['gender'] = gender;
    return _data;
  }
}
