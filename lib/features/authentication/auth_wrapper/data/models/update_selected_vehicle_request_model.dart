class UpdateSelectedVehicleRequestModel {
  UpdateSelectedVehicleRequestModel({
    required this.userId,
    required this.vehicleId,
  });
  late final String userId;
  late final String vehicleId;

  UpdateSelectedVehicleRequestModel.fromJson(Map<String, dynamic> json){
    userId = json['userId'];
    vehicleId = json['vehicleId'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['userId'] = userId;
    _data['vehicleId'] = vehicleId;
    return _data;
  }
}