class DeleteAccountRequestModel {
  DeleteAccountRequestModel({
    required this.userId,
    required this.password,
  });
  late final String userId;
  late final String password;

  DeleteAccountRequestModel.fromJson(Map<String, dynamic> json){
    userId = json['userId'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['userId'] = userId;
    _data['password'] = password;
    return _data;
  }
}