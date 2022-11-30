class LogoutRequestModel {
  LogoutRequestModel({
    required this.userId,
  });
  late final String userId;

  LogoutRequestModel.fromJson(Map<String, dynamic> json){
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['userId'] = userId;
    return _data;
  }
}