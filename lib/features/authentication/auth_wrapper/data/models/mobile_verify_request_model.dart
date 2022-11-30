class MobileVerifyRequestModel {
  MobileVerifyRequestModel({
    required this.mobile,
    required this.mobileOTP,
  });
  late final String mobile;
  late final String mobileOTP;

  MobileVerifyRequestModel.fromJson(Map<String, dynamic> json){
    mobile = json['mobile'];
    mobileOTP = json['mobileOTP'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['mobile'] = mobile;
    _data['mobileOTP'] = mobileOTP;
    return _data;
  }
}