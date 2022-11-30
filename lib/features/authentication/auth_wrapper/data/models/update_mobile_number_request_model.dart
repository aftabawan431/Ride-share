class UpdateMobileNumberRequestModel {
  UpdateMobileNumberRequestModel({
    required this.userId,
    required this.mobile,
    required this.OTP,
  });
  late final String userId;
  late final String mobile;
  late final int OTP;

  UpdateMobileNumberRequestModel.fromJson(Map<String, dynamic> json){
    userId = json['userId'];
    mobile = json['mobile'];
    OTP = json['OTP'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['userId'] = userId;
    _data['mobile'] = mobile;
    _data['OTP'] = OTP;
    return _data;
  }
}