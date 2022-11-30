
class GetSimProvidersResponseModel {
  GetSimProvidersResponseModel({
    required this.msg,
    required this.data,
  });
  late final String msg;
  late final List<Data> data;

  GetSimProvidersResponseModel.fromJson(Map<String, dynamic> json){
    msg = json['msg'];
    data = List.from(json['data']).map((e)=>Data.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['msg'] = msg;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Data {
  Data({
    required this.id,
    required this.name,
    required this.value,
    required this.createdAt,
    required this.updatedAt,
  });
  late final String id;
  late final String name;
  late final String value;
  late final String createdAt;
  late final String updatedAt;
  late final int _V;

  Data.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    name = json['name'];
    value = json['value'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    _V = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['name'] = name;
    _data['value'] = value;
    _data['createdAt'] = createdAt;
    _data['updatedAt'] = updatedAt;
    _data['__v'] = _V;
    return _data;
  }
}