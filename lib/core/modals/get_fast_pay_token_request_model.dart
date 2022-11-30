// ignore_for_file: non_constant_identifier_names

class GetFastPayTokenRequestModel {
  GetFastPayTokenRequestModel({
    required this.MERCHANTID,
    required this.SECUREDKEY,
    required this.BASKETID,
    required this.TXNAMT,
  });
  late final String MERCHANTID;
  late final String SECUREDKEY;
  late final String BASKETID;
  late final String TXNAMT;

  GetFastPayTokenRequestModel.fromJson(Map<String, dynamic> json){
    MERCHANTID = json['MERCHANT_ID'];
    SECUREDKEY = json['SECURED_KEY'];
    BASKETID = json['BASKET_ID'];
    TXNAMT = json['TXNAMT'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['MERCHANT_ID'] = MERCHANTID;
    _data['SECURED_KEY'] = SECUREDKEY;
    _data['BASKET_ID'] = BASKETID;
    _data['TXNAMT'] = TXNAMT;
    return _data;
  }
}