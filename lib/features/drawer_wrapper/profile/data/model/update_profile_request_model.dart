class UpdateProfileRequestModel {
  UpdateProfileRequestModel({
    required this.userId,
    required this.firstName,
    required this.lastName,
    // required this.gender,
    required this.activeCorporateCode,
    required this.corporateCode,
    required this.dob,
  });
  late final String userId;
  late final String firstName;
  late final String lastName;
  late final bool activeCorporateCode;
  late final String corporateCode;

  // late final String gender;
  late final String dob;

  UpdateProfileRequestModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    activeCorporateCode = json['activeCorporateCode'];
    corporateCode = json['corporateCode'];
    // gender = json['gender'];
    dob = json['dob'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['userId'] = userId;
    _data['firstName'] = firstName;
    _data['lastName'] = lastName;
    _data['corporateCode'] = corporateCode;
    _data['activeCorporateCode'] = activeCorporateCode;
    // _data['gender'] = gender;
    _data['dob'] = dob;
    return _data;
  }
}
