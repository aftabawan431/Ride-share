// ignore_for_file: non_constant_identifier_names

class PlacePridictions {
 late final String secondary_text;
 late final  String main_text;
 late final  String place_id;
  PlacePridictions({required this.main_text,required this.place_id,required this.secondary_text});
  PlacePridictions.fromJson(Map<String, dynamic> json) {
    place_id = json['place_id'];
    main_text = json['structured_formatting']['main_text'];
    secondary_text = json['structured_formatting']['secondary_text'];
  }
}