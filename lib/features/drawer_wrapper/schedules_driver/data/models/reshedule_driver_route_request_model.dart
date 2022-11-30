class RescheduleDriverRouteRequestModel {
  RescheduleDriverRouteRequestModel({
    required this.routeId,
    required this.date,
  });
  late final String routeId;
  late final String date;

  RescheduleDriverRouteRequestModel.fromJson(Map<String, dynamic> json){
    routeId = json['routeId'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['routeId'] = routeId;
    _data['date'] = date;
    return _data;
  }
}