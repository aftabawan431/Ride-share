// ignore_for_file: non_constant_identifier_names

class GetFastPayTokenResponseModel {
  GetFastPayTokenResponseModel({
    required this.MERCHANTID,
    required this.ACCESSTOKEN,
    required this.NAME,
    required this.GENERATEDDATETIME,
  });
  late final String MERCHANTID;
  late final String ACCESSTOKEN;
  late final String NAME;
  late final String GENERATEDDATETIME;

  GetFastPayTokenResponseModel.fromJson(Map<String, dynamic> json){
    MERCHANTID = json['MERCHANT_ID'];
    ACCESSTOKEN = json['ACCESS_TOKEN'];
    NAME = json['NAME'];
    GENERATEDDATETIME = json['GENERATED_DATE_TIME'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['MERCHANT_ID'] = MERCHANTID;
    _data['ACCESS_TOKEN'] = ACCESSTOKEN;
    _data['NAME'] = NAME;
    _data['GENERATED_DATE_TIME'] = GENERATEDDATETIME;
    return _data;
  }
}


