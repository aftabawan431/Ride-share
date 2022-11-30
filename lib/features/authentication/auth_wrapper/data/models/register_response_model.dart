import 'login_response_modal.dart';

class RegisterResponseModel {
  RegisterResponseModel({
    required this.msg,
    required this.data,
  });
  late final String msg;
  late final User data;

  RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    data = User.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['msg'] = msg;
    _data['data'] = data.toJson();
    return _data;
  }
}




