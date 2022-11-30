class NewNumberAvailableCheckRequestModel {
  NewNumberAvailableCheckRequestModel({
    required this.mobile,
    required this.userId,
  });
  late final String mobile;
  late final String userId;

  NewNumberAvailableCheckRequestModel.fromJson(Map<String, dynamic> json){
    mobile = json['mobile'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['mobile'] = mobile;
    _data['userId'] = userId;
    return _data;
  }
}