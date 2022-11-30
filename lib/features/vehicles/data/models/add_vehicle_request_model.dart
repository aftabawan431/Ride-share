// ignore_for_file: non_constant_identifier_names

class AddVehicleRequestModel {
  AddVehicleRequestModel({
    required this.userId,
    required this.model,
    required this.year,
    required this.registrationNumber,
    required this.registrationCity,
    required this.registrationProvince,
    required this.minMileage,
    required this.maxMileage,
    required this.AC,
    required this.heater,
    required this.color,
    required this.seatingCapacity,
    required this.token,
  });
  late final String userId;
  late final String model;
  late final String year;
  late final String registrationNumber;
  late final String registrationCity;
  late final String registrationProvince;
  late final String minMileage;
  late final String maxMileage;
  late final bool AC;
  late final bool heater;
  late final String color;
  late final String seatingCapacity;
  late final String token;

  AddVehicleRequestModel.fromJson(Map<String, dynamic> json){
    userId = json['userId'];
    model = json['model'];
    year = json['year'];
    registrationNumber = json['registrationNumber'];
    registrationCity = json['registrationCity'];
    registrationProvince = json['registrationProvince'];
    minMileage = json['minMileage'];
    maxMileage = json['maxMileage'];
    AC = json['AC'];
    heater = json['heater'];
    color = json['color'];
    seatingCapacity = json['seatingCapacity'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['userId'] = userId;
    _data['model'] = model;
    _data['year'] = year;
    _data['registrationNumber'] = registrationNumber;
    _data['registrationCity'] = registrationCity;
    _data['registrationProvince'] = registrationProvince;
    _data['minMileage'] = minMileage;
    _data['maxMileage'] = maxMileage;
    _data['AC'] = AC;
    _data['heater'] = heater;
    _data['color'] = color;
    _data['seatingCapacity'] = seatingCapacity;
    _data['token'] = token;
    return _data;
  }
}