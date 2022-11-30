import '../../../dashboard/data/model/add_passenger_schedule_request_model.dart';

class ActiveDriverRideModel {
  ActiveDriverRideModel({
    required this.id,
    required this.routeId,
    required this.passengers,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
  late final String id;
  late final RouteId routeId;
  late final List<Passengers> passengers;
  late final String status;
  late final String createdAt;
  late final String updatedAt;

  ActiveDriverRideModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    routeId = RouteId.fromJson(json['routeId']);
    passengers = List.from(json['passengers'])
        .map((e) => Passengers.fromJson(e))
        .toList();
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['routeId'] = routeId.toJson();
    _data['passengers'] = passengers.map((e) => e.toJson()).toList();
    _data['status'] = status;
    _data['createdAt'] = createdAt;
    _data['updatedAt'] = updatedAt;
    return _data;
  }
}

class RouteId {
  RouteId({
    required this.startPoint,
    required this.endPoint,
    required this.boundsSw,
    required this.boundsNe,
    required this.id,
    required this.encodedPolyline,
  });
  late final StartPoint startPoint;
  late final EndPoint endPoint;
  late final BoundsSw boundsSw;
  late final BoundsNe boundsNe;
  late final String id;
  late final String encodedPolyline;

  RouteId.fromJson(Map<String, dynamic> json) {
    startPoint = StartPoint.fromJson(json['startPoint']);
    endPoint = EndPoint.fromJson(json['endPoint']);
    boundsSw = BoundsSw.fromJson(json['bounds_sw']);
    boundsNe = BoundsNe.fromJson(json['bounds_ne']);
    id = json['_id'];
    encodedPolyline = json['encodedPolyline'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['startPoint'] = startPoint.toJson();
    _data['endPoint'] = endPoint.toJson();
    _data['bounds_sw'] = boundsSw.toJson();
    _data['bounds_ne'] = boundsNe.toJson();
    _data['_id'] = id;
    _data['encodedPolyline'] = encodedPolyline;
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

class Passengers {
  Passengers(
      {required this.passenger,
      required this.status,
      required this.fare,
      required this.id,
      required this.sortDistance,
      required this.count,
      required this.verifyPin
      });
  late final Passenger passenger;
  String status;
  late final double fare;
  late final String? verifyPin;
  late final int sortDistance;
  late final String id;
  int count;

  factory Passengers.fromJson(Map<String, dynamic> json) {
    return Passengers(
        passenger: Passenger.fromJson(json['passenger']),
        status: json['status'],
        verifyPin: json['verifyPin'],
        count: json['count']??0,
        fare: (json['fare'] as num).toDouble(),
        sortDistance: (json['sortDistance'] as num).toInt(),
        id: json['_id']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['passenger'] = passenger.toJson();
    _data['status'] = status;
    _data['count'] = count;
    _data['verifyPin'] = verifyPin;
    _data['fare'] = fare;
    _data['sortDistance'] = sortDistance;
    _data['_id'] = id;
    return _data;
  }
}

class Passenger {
  Passenger(
      {required this.startPoint,
      required this.endPoint,
      required this.boundsSw,
      required this.boundsNe,
      required this.id,
      required this.userId,
      required this.bookedSeats,
      required this.encodedPolyline,
      required this.distance});
  late final StartPoint startPoint;
  late final EndPoint endPoint;
  late final BoundsSw boundsSw;
  late final BoundsNe boundsNe;
  late final String id;
  late final UserId userId;
  late final int bookedSeats;
  late final int distance;
  late final String encodedPolyline;

  Passenger.fromJson(Map<String, dynamic> json) {
    startPoint = StartPoint.fromJson(json['startPoint']);
    endPoint = EndPoint.fromJson(json['endPoint']);
    boundsSw = BoundsSw.fromJson(json['bounds_sw']);
    boundsNe = BoundsNe.fromJson(json['bounds_ne']);
    id = json['_id'];
    userId = UserId.fromJson(json['userId']);
    bookedSeats = json['bookedSeats'];
    distance = json['distance'];
    encodedPolyline = json['encodedPolyline'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['startPoint'] = startPoint.toJson();
    _data['endPoint'] = endPoint.toJson();
    _data['bounds_sw'] = boundsSw.toJson();
    _data['bounds_ne'] = boundsNe.toJson();
    _data['_id'] = id;
    _data['userId'] = userId.toJson();
    _data['bookedSeats'] = bookedSeats;
    _data['distance'] = distance;
    _data['encodedPolyline'] = encodedPolyline;
    return _data;
  }
}

class UserId {
  UserId(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.mobile,
      required this.profileImage,
      required this.totalRating,
      required this.totalRatingCount});
  late final String id;
  late final String firstName;
  late final String lastName;
  late final String profileImage;
  late final int mobile;
  late final int totalRating;
  late final int totalRatingCount;

  UserId.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    mobile = json['mobile'];
    profileImage = json['profileImage'];
    totalRating = json['totalRating'];
    totalRatingCount = json['totalRatingCount'];
  }
  String getFullName() {
    return "$firstName $lastName";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['firstName'] = firstName;
    _data['lastName'] = lastName;
    _data['mobile'] = mobile;
    _data['profileImage'] = profileImage;
    _data['totalRatingCount'] = totalRatingCount;
    _data['totalRating'] = totalRating;
    return _data;
  }
}
