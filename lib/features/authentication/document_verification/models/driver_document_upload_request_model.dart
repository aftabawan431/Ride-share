
class DriverDocumentUploadRequestModel {
  DriverDocumentUploadRequestModel({
    required this.userId,
    required this.document,
  });
  late final String userId;
  late final List<String> document;

  DriverDocumentUploadRequestModel.fromJson(Map<String, dynamic> json){
    userId = json['userId'];
    document = List.castFrom<dynamic, String>(json['document']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['userId'] = userId;
    _data['document'] = document;
    return _data;
  }
}