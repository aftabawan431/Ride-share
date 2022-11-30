class LoginRequestModel {
  LoginRequestModel({
    required this.mobile,
    required this.password,
    required this.fcmToken,
    required this.deviceId
  });
  late final String mobile;
  late final String password;
  late final String fcmToken;
  late final String deviceId;

  LoginRequestModel.fromJson(Map<String, dynamic> json){
    mobile = json['mobile'];
    fcmToken = json['fcmToken'];
    password = json['password'];
    deviceId = json['deviceId'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['mobile'] = mobile;
    _data['password'] = password;
    _data['fcmToken'] = fcmToken;
    _data['deviceId'] = deviceId;
    return _data;
  }
}