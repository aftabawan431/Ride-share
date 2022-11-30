class CompleteRideReuqestModel {
  CompleteRideReuqestModel({
    required this.passengerId,
    required this.otp,
  });
  late final String passengerId;
  late final String otp;

  CompleteRideReuqestModel.fromJson(Map<String, dynamic> json){
    passengerId = json['passengerId'];
    otp = json['otp'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['passengerId'] = passengerId;
    _data['otp'] = otp;
    return _data;
  }
}