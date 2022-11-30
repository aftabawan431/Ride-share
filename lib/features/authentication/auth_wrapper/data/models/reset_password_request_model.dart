class ResetPasswordRequestModel {
  ResetPasswordRequestModel({
    required this.mobile,
    required this.password,
  });
  late final String mobile;
  late final String password;

  ResetPasswordRequestModel.fromJson(Map<String, dynamic> json){
    mobile = json['mobile'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['mobile'] = mobile;
    _data['password'] = password;
    return _data;
  }
}