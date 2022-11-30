class ResendOtpRequestModel {
  ResendOtpRequestModel({
    required this.userId,
    required this.token,
  });
  late final String userId;
  late final String token;

  ResendOtpRequestModel.fromJson(Map<String, dynamic> json){
    userId = json['userId'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['userId'] = userId;
    _data['token'] = token;
    return _data;
  }
}