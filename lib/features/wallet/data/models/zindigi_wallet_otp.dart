class ZindigWalletOtpRequestModel {
  ZindigWalletOtpRequestModel({
    required this.userId,
  });
  late final String userId;
  ZindigWalletOtpRequestModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
  }
  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['userId'] = userId;
    return _data;
  }
}
