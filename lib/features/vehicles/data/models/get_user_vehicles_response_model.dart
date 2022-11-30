// ignore_for_file: file_names, non_constant_identifier_names

class GetUserVehiclesResponseModel {
  GetUserVehiclesResponseModel({
    required this.data,
  });
  late final Data data;

  GetUserVehiclesResponseModel.fromJson(Map<String, dynamic> json){
    data = Data.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['data'] = data.toJson();
    return _data;
  }
}

class Data {
  Data({
    required this.id,
    required this.userVehicle,
  });
  late final String id;
  late final List<UserVehicle> userVehicle;

  Data.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    userVehicle = List.from(json['userVehicle']).map((e)=>UserVehicle.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['userVehicle'] = userVehicle.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class UserVehicle {
  UserVehicle({
    required this.id,
    required this.model,
    required this.year,
    required this.registrationNumber,
    required this.registrationCity,
    required this.minMileage,
    required this.AC,
    required this.heater,
    required this.color,
    required this.seatingCapacity,
  });
  late final String id;
  late final Model model;
  late final int year;
  late final String registrationNumber;
  late final RegistrationCity registrationCity;
  late final int minMileage;
  late final bool AC;
  late final bool heater;
  late final Color color;
  late final int seatingCapacity;

  UserVehicle.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    model = Model.fromJson(json['model']);
    year = json['year'];
    registrationNumber = json['registrationNumber'];
    registrationCity = RegistrationCity.fromJson(json['registrationCity']);
    minMileage = json['minMileage'];
    AC = json['AC'];
    heater = json['heater'];
    color = Color.fromJson(json['color']);
    seatingCapacity = json['seatingCapacity'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['model'] = model.toJson();
    _data['year'] = year;
    _data['registrationNumber'] = registrationNumber;
    _data['registrationCity'] = registrationCity.toJson();
    _data['minMileage'] = minMileage;
    _data['AC'] = AC;
    _data['heater'] = heater;
    _data['color'] = color.toJson();
    _data['seatingCapacity'] = seatingCapacity;
    return _data;
  }
}

class Model {
  Model({
    required this.id,
    required this.type,
    required this.make,
    required this.model,
  });
  late final String id;
  late final Type type;
  late final Make make;
  late final String model;

  Model.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    type = Type.fromJson(json['type']);
    make = Make.fromJson(json['make']);
    model = json['model'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['type'] = type.toJson();
    _data['make'] = make.toJson();
    _data['model'] = model;
    return _data;
  }
}

class Type {
  Type({
    required this.id,
    required this.type,
  });
  late final String id;
  late final String type;

  Type.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['type'] = type;
    return _data;
  }
}

class Make {
  Make({
    required this.id,
    required this.make,
  });
  late final String id;
  late final String make;

  Make.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    make = json['make'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['make'] = make;
    return _data;
  }
}

class RegistrationCity {
  RegistrationCity({
    required this.id,
    required this.city,
    required this.province,
  });
  late final String id;
  late final String city;
  late final Province province;

  RegistrationCity.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    city = json['city'];
    province = Province.fromJson(json['province']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['city'] = city;
    _data['province'] = province.toJson();
    return _data;
  }
}

class Province {
  Province({
    required this.id,
    required this.name,
  });
  late final String id;
  late final String name;

  Province.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['name'] = name;
    return _data;
  }
}

class Color {
  Color({
    required this.code,
    required this.id,
    required this.color,
  });
  late final Code code;
  late final String id;
  late final String color;

  Color.fromJson(Map<String, dynamic> json){
    code = Code.fromJson(json['code']);
    id = json['_id'];
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['code'] = code.toJson();
    _data['_id'] = id;
    _data['color'] = color;
    return _data;
  }
}

class Code {
  Code({
    required this.rgba,
    required this.hex,
  });
  late final List<int> rgba;
  late final String hex;

  Code.fromJson(Map<String, dynamic> json){
    rgba = List.castFrom<dynamic, int>(json['rgba']);
    hex = json['hex'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['rgba'] = rgba;
    _data['hex'] = hex;
    return _data;
  }
}