class ValidateZindigiAccountRequestModel {
  ValidateZindigiAccountRequestModel({
    required this.userId,
    required this.mobileNo,
    required this.dateTime,
    required this.cnic
  });
  late final String userId;
  late final String mobileNo;
  late final String dateTime;
  late final String cnic;

  ValidateZindigiAccountRequestModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    mobileNo = json['mobileNo'];
    dateTime = json['dateTime'];
    cnic = json['cnic'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['userId'] = userId;
    _data['mobileNo'] = mobileNo;
    _data['dateTime'] = dateTime;
    _data['cnic'] = cnic;
    return _data;
  }
}
