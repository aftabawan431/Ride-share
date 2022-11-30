// ignore_for_file: file_names

class AddVehicleResponseModel {
  AddVehicleResponseModel({
    required this.msg,
    required this.statusCode,
  });
  late final String msg;
  late final int statusCode;

  AddVehicleResponseModel.fromJson(Map<String, dynamic> json){
    msg = json['msg'];
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['msg'] = msg;
    _data['statusCode'] = statusCode;
    return _data;
  }
}