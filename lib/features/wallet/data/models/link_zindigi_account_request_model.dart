class LinkZindigiAccountRequestModel {
  LinkZindigiAccountRequestModel({
    required this.dateTime,
    required this.mobileNo,
    required this.cnic,
    required this.otpPin,
    required this.userId,
  });
  late final String dateTime;
  late final String mobileNo;
  late final String cnic;
  late final String otpPin;
  late final String userId;

  LinkZindigiAccountRequestModel.fromJson(Map<String, dynamic> json){
    dateTime = json['dateTime'];
    mobileNo = json['mobileNo'];
    cnic = json['cnic'];
    otpPin = json['otpPin'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['dateTime'] = dateTime;
    _data['mobileNo'] = mobileNo;
    _data['cnic'] = cnic;
    _data['otpPin'] = otpPin;
    _data['userId'] = userId;
    return _data;
  }
}