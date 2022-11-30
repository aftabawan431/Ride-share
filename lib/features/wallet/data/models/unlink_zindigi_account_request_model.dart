class UnlinkZindigiAccountRequestModel {
  UnlinkZindigiAccountRequestModel({
    required this.userId,
    required this.OTP,
  });
  late final String userId;
  late final int OTP;

  UnlinkZindigiAccountRequestModel.fromJson(Map<String, dynamic> json){
    userId = json['userId'];
    OTP = json['OTP'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['userId'] = userId;
    _data['OTP'] = OTP;
    return _data;
  }
}