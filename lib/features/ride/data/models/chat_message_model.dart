class ChatMessageModel {
  ChatMessageModel({
    required this.userId,
    required this.name,
    required this.profileImage,
    required this.message,
    required this.receiver,
    required this.date,
  });
  late final String userId;
  late final String name;
  late final String profileImage;
  late final String message;
  late final String receiver;
  late final String date;

  ChatMessageModel.fromJson(Map<String, dynamic> json){
    userId = json['userId'];
    name = json['name'];
    profileImage = json['profileImage'];
    message = json['message'];
    receiver = json['receiver'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['userId'] = userId;
    _data['name'] = name;
    _data['profileImage'] = profileImage;
    _data['message'] = message;
    _data['receiver'] = receiver;
    _data['date'] = date;
    return _data;
  }
}