class GetModelsResponseModel {
  GetModelsResponseModel({
    required this.data,
  });
  late final List<VehicleModel> data;

  GetModelsResponseModel.fromJson(Map<String, dynamic> json){
    data = List.from(json['data']).map((e)=>VehicleModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class VehicleModel {
  VehicleModel({
    required this.id,
    required this.model,
  });
  late final String id;
  late final String model;

  VehicleModel.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    model = json['model'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['model'] = model;
    return _data;
  }
}