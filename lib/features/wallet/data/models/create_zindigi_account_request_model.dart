class CreateZindigiAccountRequestModel {
  CreateZindigiAccountRequestModel({
    required this.dateTime,
    required this.mobileNo,
    required this.cnic,
    required this.cnicIssuanceDate,
    required this.mobileNetwork,
    required this.emailId,
    required this.userId
  });
  late final String dateTime;
  late final String mobileNo;
  late final String cnic;
  late final String cnicIssuanceDate;
  late final String mobileNetwork;
  late final String emailId;
  late final String userId;

  CreateZindigiAccountRequestModel.fromJson(Map<String, dynamic> json){
    dateTime = json['dateTime'];
    userId = json['userId'];
    mobileNo = json['mobileNo'];
    cnic = json['cnic'];
    cnicIssuanceDate = json['cnicIssuanceDate'];
    mobileNetwork = json['mobileNetwork'];
    emailId = json['emailId'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['dateTime'] = dateTime;
    _data['mobileNo'] = mobileNo;
    _data['userId'] = userId;
    _data['cnic'] = cnic;
    _data['cnicIssuanceDate'] = cnicIssuanceDate;
    _data['mobileNetwork'] = mobileNetwork;
    _data['emailId'] = emailId;
    return _data;
  }
}