import 'package:logger/logger.dart';

class LoginResponseModel {
  LoginResponseModel({
    required this.msg,
    required this.data,
  });
  late final String msg;
  late final User data;

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    data = User.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['msg'] = msg;
    _data['data'] = data.toJson();
    return _data;
  }
}

class User {
  User({
    required this.totalRating,
    required this.totalRatingCount,
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.selectedUserType,
    required this.mobile,
    required this.email,
    required this.gender,
    required this.cnic,
    required this.userVehicle,
    required this.emailVerified,
    required this.mobileVerified,
    required this.profileStatus,
    required this.createdAt,
    required this.updatedAt,
    required this.token,
    required this.selectedVehicle,
    required this.dob,
    required this.profileImage,
    required this.userType,
    required this.inviteCode,
    required this.documentUpload,
    required this.active,
    required this.documentVerified,
    required this.activeCorporateCode,
    required this.corporateCode
  });
  late final int totalRating;
  late final int totalRatingCount;
  late final String id;
  String inviteCode;
  late final String firstName;
  late final String lastName;
  String selectedUserType;
  String? corporateCode;
  String userType;
  late final int mobile;
  late final String email;
  late final String gender;
  late final int cnic;
  late final List<String> userVehicle;
  bool emailVerified;
  bool mobileVerified;
  bool activeCorporateCode;
  late final bool profileStatus;
  late final String createdAt;
  late final String updatedAt;
  late final String token;
  String? selectedVehicle;
  late final String dob;
  late final String profileImage;
  bool documentUpload;
  ActiveModel active;
  DocumentVerified documentVerified;

  bool isDriver(){
    return selectedUserType=='1';
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        documentVerified: DocumentVerified.fromJson(json['documentVerified']),
        totalRating: json['totalRating'],
        inviteCode: json['inviteCode'] ?? '',
        totalRatingCount: json['totalRatingCount'],
        id: json['_id'] ?? json['id'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        selectedUserType: json['selectedUserType'],
        mobile: json['mobile'],
        email: json['email'],
        corporateCode: json['corporateCode']??'',
        activeCorporateCode: json['activeCorporateCode']??false,
        gender: json['gender'],
        documentUpload: json['documentUpload'],
        cnic: json['cnic'] ?? 0,
        userVehicle: List.castFrom<dynamic, String>(json['userVehicle']),
        emailVerified: json['emailVerified'],
        mobileVerified: json['mobileVerified'],
        profileStatus: json['profileStatus'],
        createdAt: json['createdAt'],
        userType: json['userType'],
        updatedAt: json['updatedAt'],
        token: json['token'],
        selectedVehicle: json['selectedVehicle'],
        dob: json['dob'] ?? '',
        profileImage: json['profileImage'] ?? '',
        active: ActiveModel.fromJson(json['active']));
  }

  String getFullName() {
    return "$firstName $lastName";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['totalRating'] = totalRating;
    _data['totalRatingCount'] = totalRatingCount;
    _data['id'] = id;
    _data['firstName'] = firstName;
    _data['lastName'] = lastName;
    _data['selectedUserType'] = selectedUserType;
    _data['mobile'] = mobile;
    _data['email'] = email;
    _data['documentUpload'] = documentUpload;
    _data['inviteCode'] = inviteCode;
    _data['cnic'] = cnic;
    _data['gender'] = gender;
    _data['corporateCode'] = corporateCode;
    _data['userType'] = userType;
    _data['userVehicle'] = userVehicle;
    _data['activeCorporateCode'] = activeCorporateCode;
    _data['emailVerified'] = emailVerified;
    _data['mobileVerified'] = mobileVerified;
    _data['profileStatus'] = profileStatus;
    _data['createdAt'] = createdAt;
    _data['updatedAt'] = updatedAt;
    _data['documentVerified'] = documentVerified.toJson();
    _data['token'] = token;
    _data['selectedVehicle'] = selectedVehicle;
    _data['dob'] = dob;
    _data['profileImage'] = profileImage;
    _data['active'] = active.toJson();
    return _data;
  }
}

class DocumentVerified {
  DocumentVerified({
    required this.status,
    required this.comment,
  });
  late final String status;
  late final String comment;

  DocumentVerified.fromJson(Map<String, dynamic> json) {
    print(json);
    status = json['status'];
    comment = json['comment'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['comment'] = comment;
    return _data;
  }
}

class ActiveModel {
  ActiveModel({
    required this.status,
    required this.comment,
  });
  late final bool status;
  late final String comment;

  ActiveModel.fromJson(Map<String, dynamic> json) {
    print(json);
    // status = true;
    status = json['status'];
    comment = json['comment'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['comment'] = comment;
    return _data;
  }
}
