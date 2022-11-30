// ignore_for_file: file_names

class GetCityResponseModel {
  GetCityResponseModel({
    required this.data,
  });
  late final List<VehicleCity> data;

  GetCityResponseModel.fromJson(Map<String, dynamic> json){
    data = List.from(json['data']).map((e)=>VehicleCity.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class VehicleCity {
  VehicleCity({
    required this.id,
    required this.city,
  });
  late final String id;
  late final String city;

  VehicleCity.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    city = json['city'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['city'] = city;
    return _data;
  }
}