class GetNotificationsResponseModel {
  GetNotificationsResponseModel({
    required this.msg,
    required this.data,
  });
  late final String msg;
  late final List<NotificationModel> data;

  GetNotificationsResponseModel.fromJson(Map<String, dynamic> json){
    msg = json['msg'];
    data = List.from(json['data']).map((e)=>NotificationModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['msg'] = msg;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class NotificationModel {
  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.message,
    required this.topic,
    required this.icon,
    required this.createdAt,
    required this.updatedAt,
  });
  late final String id;
  late final String title;
  late final String body;
  late final String message;
  late final String topic;
  late final String icon;
  late final String createdAt;
  late final String updatedAt;

  NotificationModel.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    title = json['title'];
    body = json['body'];
    message = json['message'];
    topic = json['topic'];
    icon = json['icon'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['title'] = title;
    _data['body'] = body;
    _data['message'] = message;
    _data['topic'] = topic;
    _data['icon'] = icon;
    _data['createdAt'] = createdAt;
    _data['updatedAt'] = updatedAt;
    return _data;
  }
}