
class GetModelsRequestModel {
  GetModelsRequestModel({
    required this.vehicleType,
    required this.vehicleMake,
  });
  late final String vehicleType;
  late final String vehicleMake;

  GetModelsRequestModel.fromJson(Map<String, dynamic> json){
    vehicleType = json['vehicleType'];
    vehicleMake = json['vehicleMake'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['vehicleType'] = vehicleType;
    _data['vehicleMake'] = vehicleMake;
    return _data;
  }
}