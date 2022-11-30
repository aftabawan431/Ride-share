class GetDashboardHistoryRidesRequestModel {
  GetDashboardHistoryRidesRequestModel({
    required this.userId,
    required this.check,
    required this.isDriver,
    required this.page,
  });
  late final String userId;
  late final String check;
  late final bool isDriver;
  late final int page;

  GetDashboardHistoryRidesRequestModel.fromJson(Map<String, dynamic> json){
    userId = json['userId'];
    check = json['check'];
    isDriver = json['isDriver'];
    page = json['page'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['userId'] = userId;
    _data['check'] = check;
    _data['isDriver'] = isDriver;
    _data['page'] = page;
    return _data;
  }
}