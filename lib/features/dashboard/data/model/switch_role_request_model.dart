

class SwitchRoleRequestModel {
  SwitchRoleRequestModel({
    required this.userId,
  });
  late final String userId;

  SwitchRoleRequestModel.fromJson(Map<String, dynamic> json){
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['userId'] = userId;
    return _data;
  }
}