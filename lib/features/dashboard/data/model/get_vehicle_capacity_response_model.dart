
class GetVehicleCapacityResponseModel {
  GetVehicleCapacityResponseModel({
    required this.msg,
    required this.data,
  });
  late final String msg;
  late final Data data;

  GetVehicleCapacityResponseModel.fromJson(Map<String, dynamic> json){
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
  Data({
    required this.id,
    required this.seatingCapacity,
  });
  late final String id;
  late final int seatingCapacity;

  Data.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    seatingCapacity = json['seatingCapacity'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['seatingCapacity'] = seatingCapacity;
    return _data;
  }
}