class UpdateSelectedVehicleResponseModel {
  UpdateSelectedVehicleResponseModel({
    required this.msg,
  });
  late final String msg;

  UpdateSelectedVehicleResponseModel.fromJson(Map<String, dynamic> json){
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['msg'] = msg;
    return _data;
  }
}