class GetDriversListRequestModel {
  GetDriversListRequestModel({
    required this.isScheduled,
    required this.scheduleId,
  });
  late final bool isScheduled;
  late final String scheduleId;

  GetDriversListRequestModel.fromJson(Map<String, dynamic> json){
    isScheduled = json['isScheduled'];
    scheduleId = json['scheduleId'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['isScheduled'] = isScheduled;
    _data['scheduleId'] = scheduleId;
    return _data;
  }
}