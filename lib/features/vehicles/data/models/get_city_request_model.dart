class GetCityRequestModel {
  GetCityRequestModel({
    required this.province,
  });
  late final String province;

  GetCityRequestModel.fromJson(Map<String, dynamic> json){
    province = json['province'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['province'] = province;
    return _data;
  }
}