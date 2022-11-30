import 'package:logger/logger.dart';

class GetVehicleInitialsResponseModel {
  GetVehicleInitialsResponseModel({
    required this.vehicleTypes,
    required this.vehicleMakes,
    required this.vehicleColors,
    required this.provinces,
  });
  late final List<VehicleTypes> vehicleTypes;
  late final List<VehicleMakes> vehicleMakes;
  late final List<VehicleColors> vehicleColors;
  late final List<Provinces> provinces;

  GetVehicleInitialsResponseModel.fromJson(Map<String, dynamic> json){
    vehicleTypes = List.from(json['vehicleTypes']).map((e)=>VehicleTypes.fromJson(e)).toList();
    vehicleMakes =List.from(json['vehicleMakes']).map((e)=>VehicleMakes.fromJson(e)).toList();

    vehicleColors = List.from(json['vehicleColors']).map((e)=>VehicleColors.fromJson(e)).toList();
    provinces = List.from(json['provinces']).map((e)=>Provinces.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['vehicleTypes'] = vehicleTypes.map((e)=>e.toJson()).toList();
    _data['vehicleMakes'] = vehicleMakes.map((e)=>e.toJson()).toList();
    _data['vehicleColors'] = vehicleColors.map((e)=>e.toJson()).toList();
    _data['provinces'] = provinces.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class VehicleTypes {
  VehicleTypes({
    required this.id,
    required this.type,
  });
  late final String id;
  late final String type;

  VehicleTypes.fromJson(Map<String, dynamic> json){
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

class VehicleMakes {
  VehicleMakes({
    required this.id,
    required this.make,
  });
  late final String id;
  late final String make;

  VehicleMakes.fromJson(Map<String, dynamic> json){
    if(json['make']==null){
      Logger().v(json['_id']);
    }
    id = json['_id'];
    make = json['make']??'';
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['make'] = make;
    return _data;
  }
}

class VehicleColors {
  VehicleColors({
    required this.code,
    required this.id,
    required this.color,
  });
  late final Code code;
  late final String id;
  late final String color;

  VehicleColors.fromJson(Map<String, dynamic> json){
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

class Provinces {
  Provinces({
    required this.id,
    required this.name,
  });
  late final String id;
  late final String name;

  Provinces.fromJson(Map<String, dynamic> json){
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