
class GetRequestedPassengersRequestModel {
  GetRequestedPassengersRequestModel({
    required this.routeId,
  });
  late final String routeId;

  GetRequestedPassengersRequestModel.fromJson(Map<String, dynamic> json){
    routeId = json['routeId'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['routeId'] = routeId;
    return _data;
  }
}

