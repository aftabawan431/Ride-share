class RegisterRequestModel {
  RegisterRequestModel({
    required this.firstName,
    required this.lastName,
    required this.userType,
    required this.mobile,
    required this.email,
    required this.password,
    required this.gender,
    required this.cnic,
    required this.fcmToken,
    required this.inviteCode,
    required this.corporateCode,
    required this.deviceId,
  });
  late final String firstName;
  late final String lastName;
  late final String userType;
  late final String mobile;
  late final String email;
  late final String password;
  late final String gender;
  late final String cnic;
  late final String fcmToken;
  late final String? inviteCode;
  late final String? corporateCode;
  late final String? deviceId;

  RegisterRequestModel.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    userType = json['userType'];
    mobile = json['mobile'];
    email = json['email'];
    inviteCode = json['inviteCode'];
    password = json['password'];
    gender = json['gender'];
    cnic = json['cnic'];
    fcmToken = json['fcmToken'];
    deviceId = json['deviceId'];
    corporateCode = json['corporateCode'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['firstName'] = firstName;
    _data['lastName'] = lastName;
    _data['userType'] = userType;
    _data['inviteCode'] = inviteCode;
    _data['mobile'] = mobile;
    _data['email'] = email;
    _data['password'] = password;
    _data['gender'] = gender;
    _data['cnic'] = cnic;
    _data['fcmToken'] = fcmToken;
    _data['corporateCode'] = corporateCode;
    _data['deviceId'] = deviceId;
    return _data;
  }
}
