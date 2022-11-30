class AddProfileImageRequestModel {
  AddProfileImageRequestModel({
    required this.userId,
    required this.file,
  });
  late final String userId;
  late final String file;

  AddProfileImageRequestModel.fromJson(Map<String, dynamic> json){
    userId = json['userId'];
    file = json['file'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['userId'] = userId;
    _data['file'] = file;
    return _data;
  }
}