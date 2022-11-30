class GetHistoryRequestModel {
  GetHistoryRequestModel({
    required this.userId,
    required this.isDriver,
    required this.page,
  });
  late final String userId;
  late final bool isDriver;
  late final int page;

  GetHistoryRequestModel.fromJson(Map<String, dynamic> json){
    userId = json['userId'];
    isDriver = json['isDriver'];
    page = json['page'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['userId'] = userId;
    _data['isDriver'] = isDriver;
    _data['page'] = page;
    return _data;
  }
}