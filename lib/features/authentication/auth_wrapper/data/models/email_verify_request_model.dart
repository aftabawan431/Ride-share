class EmailVerifyRequestModel {
  EmailVerifyRequestModel({
    required this.email,
    required this.emailOTP,
  });
  late final String email;
  late final String emailOTP;

  EmailVerifyRequestModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    emailOTP = json['emailOTP'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['email'] = email;
    _data['emailOTP'] = emailOTP;
    return _data;
  }
}
