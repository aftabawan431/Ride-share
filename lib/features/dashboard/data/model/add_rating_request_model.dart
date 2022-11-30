class AddRatingRequestModel {
  AddRatingRequestModel(
      {required this.ratingBy,
      required this.ratingTo,
      required this.routeId,
      required this.text,
      required this.isDriver,
      required this.rating,
      required this.scheduleId,
      required this.historyId});
  late final String ratingBy;
  late final String ratingTo;
  late final String routeId;
  late final String text;
  late final bool isDriver;
  late final double rating;
  late final String scheduleId;
  String? historyId;

  factory AddRatingRequestModel.fromJson(Map<String, dynamic> json) {
    return AddRatingRequestModel(
        ratingBy: json['ratingBy'],
        ratingTo: json['ratingTo'],
        routeId: json['routeId'],
        text: json['text'],
        isDriver: json['isDriver'],
        rating: json['rating'],
        scheduleId: json['scheduleId'],
        historyId: json['historyId']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['ratingBy'] = ratingBy;
    _data['ratingTo'] = ratingTo;
    _data['routeId'] = routeId;
    _data['text'] = text;
    _data['isDriver'] = isDriver;
    _data['rating'] = rating;
    _data['scheduleId'] = scheduleId;
    _data['historyId'] = historyId;
    return _data;
  }
}
