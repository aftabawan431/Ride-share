import 'add_passenger_schedule_request_model.dart';

class GetDashboardDataResponseModel {
  GetDashboardDataResponseModel({
    required this.msg,
    required this.data,
  });
  late final String msg;
  late final Data data;

  GetDashboardDataResponseModel.fromJson(Map<String, dynamic> json) {
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
  Data(
      {required this.ads,
      required this.upcoming,
      required this.active,
      required this.totalRides,
      required this.completedRides,
      required this.cancelledRides,
      required this.upcomingRides,
      required this.appVersion});
  late final List<Ads> ads;
  late final List<Upcoming> upcoming;
  late final List<Upcoming> active;
  late final int totalRides;
  late final int completedRides;
  late final int cancelledRides;
  late final int upcomingRides;
  late final AppVersionModel? appVersion;

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
        ads: List.from(json['ads']).map((e) => Ads.fromJson(e)).toList(),
        upcoming: List.from(json['upcoming'])
            .map((e) => Upcoming.fromJson(e))
            .toList(),
        active: List.from(json['active'])
            .map((e) => Upcoming.fromJson(e))
            .toList(),
        totalRides: json['totalRides'],
        completedRides: json['completedRides'],
        cancelledRides: json['cancelledRides'],
        upcomingRides: json['upcomingRides'],
        appVersion: json['appVersion'] == null
            ? null
            : AppVersionModel.fromJson(json['appVersion']));
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['ads'] = ads.map((e) => e.toJson()).toList();
    _data['upcoming'] = upcoming.map((e) => e.toJson()).toList();
    _data['active'] = active.map((e) => e.toJson()).toList();
    _data['totalRides'] = totalRides;
    _data['completedRides'] = completedRides;
    _data['cancelledRides'] = cancelledRides;
    _data['upcomingRides'] = upcomingRides;
    _data['appVersion'] = appVersion!.toJson();
    return _data;
  }
}

class Ads {
  Ads({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.buttonText,
    required this.redirectUrl,
    required this.createdAt,
    required this.updatedAt,
  });
  late final String id;
  late final String title;
  late final String imageUrl;
  late final String buttonText;
  late final String redirectUrl;
  late final String createdAt;
  late final String updatedAt;

  Ads.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    title = json['title'];
    imageUrl = json['imageUrl'];
    buttonText = json['buttonText'];
    redirectUrl = json['redirectUrl'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['title'] = title;
    _data['imageUrl'] = imageUrl;
    _data['buttonText'] = buttonText;
    _data['redirectUrl'] = redirectUrl;
    _data['createdAt'] = createdAt;
    _data['updatedAt'] = updatedAt;
    return _data;
  }
}

class Upcoming {
  Upcoming(
      {required this.startPoint,
      required this.endPoint,
      required this.id,
      required this.date,
      required this.fare,
      this.routeId});
  late final StartPoint startPoint;
  late final EndPoint endPoint;
  late final String id;
  late final String date;
  String? routeId;
  int? fare;

  factory Upcoming.fromJson(Map<String, dynamic> json) {
    return Upcoming(
      startPoint: StartPoint.fromJson(json['startPoint']),
      endPoint: EndPoint.fromJson(json['endPoint']),
      id: json['_id'],
      date: json['date'],
      fare: json['fare'],
      routeId:json['accepted']!=null? json['accepted']['_id']:null,
    );
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['startPoint'] = startPoint.toJson();
    _data['endPoint'] = endPoint.toJson();
    _data['_id'] = id;
    _data['date'] = date;
    _data['fare'] = fare;
    return _data;
  }
}

class AppVersionModel {
  AppVersionModel({
    required this.id,
    required this.androidVersion,
    required this.forceUpdate,
    required this.createdAt,
    required this.updatedAt,
  });
  late final String id;
  late final String androidVersion;
  late final String iosVersion;
  late final bool forceUpdate;
  late final String createdAt;
  late final String updatedAt;

  AppVersionModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    androidVersion = json['androidVersion'];
    iosVersion = json['iosVersion'];
    forceUpdate = json['forceUpdate'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['androidVersion'] = androidVersion;
    _data['iosVersion'] = iosVersion;
    _data['forceUpdate'] = forceUpdate;
    _data['createdAt'] = createdAt;
    _data['updatedAt'] = updatedAt;
    return _data;
  }
}
