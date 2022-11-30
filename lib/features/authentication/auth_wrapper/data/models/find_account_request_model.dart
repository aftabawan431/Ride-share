class FindAccountRequestModel {
  FindAccountRequestModel({
    required this.mobile,
  });
  late final String mobile;

  FindAccountRequestModel.fromJson(Map<String, dynamic> json){
    mobile = json['mobile'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['mobile'] = mobile;
    return _data;
  }
}