class ReschedulePassengerScheduleRequestModel {
  ReschedulePassengerScheduleRequestModel({
    required this.scheduleId,
    required this.date,
    required this.startTime,
    required this.endTime,
  });
  late final String scheduleId;
  late final String date;
  late final String startTime;
  late final String endTime;

  ReschedulePassengerScheduleRequestModel.fromJson(Map<String, dynamic> json){
    scheduleId = json['scheduleId'];
    date = json['date'];
    startTime = json['startTime'];
    endTime = json['endTime'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['scheduleId'] = scheduleId;
    _data['date'] = date;
    _data['startTime'] = startTime;
    _data['endTime'] = endTime;
    return _data;
  }
}