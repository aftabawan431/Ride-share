// ignore_for_file: non_constant_identifier_names

class PayFastPostRequestModel {
  PayFastPostRequestModel({
    required this.MERCHANTID,
    required this.MERCHANTNAME,
    required this.TOKEN,
    required this.PROCCODE,
    required this.TXNAMT,
    required this.CUSTOMERMOBILENO,
    required this.CUSTOMEREMAILADDRESS,
    required this.SIGNATURE,
    required this.VERSION,
    required this.TXNDESC,
    required this.SUCCESSURL,
    required this.FAILUREURL,
    required this.BASKETID,
    required this.ORDERDATE,
    required this.CHECKOUTURL,
    required this.CURRENCYCODE,
    required this.CUSTOMERNAME,
    required this.MERCHANTCUSTOMERID,
    required this.COUNTRY,
  });
  late final String MERCHANTID;
  late final String MERCHANTNAME;
  late final String TOKEN;
  /// set to 00
  late final String PROCCODE;
  late final String TXNAMT;
  late final String CUSTOMERMOBILENO;
  late final String CUSTOMEREMAILADDRESS;
  late final String SIGNATURE;
  late final String VERSION;
  late final String TXNDESC;
  late final String SUCCESSURL;
  late final String FAILUREURL;
  late final String BASKETID;
  late final String ORDERDATE;
  late final String CHECKOUTURL;
  late final String CURRENCYCODE;
  late final String CUSTOMERNAME;
  late final String MERCHANTCUSTOMERID;
  late final String COUNTRY;

  PayFastPostRequestModel.fromJson(Map<String, dynamic> json){
    MERCHANTID = json['MERCHANT_ID'];
    MERCHANTNAME = json['MERCHANT_NAME'];
    TOKEN = json['TOKEN'];
    PROCCODE = json['PROCCODE'];
    TXNAMT = json['TXNAMT'];
    CUSTOMERMOBILENO = json['CUSTOMER_MOBILE_NO'];
    CUSTOMEREMAILADDRESS = json['CUSTOMER_EMAIL_ADDRESS'];
    SIGNATURE = json['SIGNATURE'];
    VERSION = json['VERSION'];
    TXNDESC = json['TXNDESC'];
    SUCCESSURL = json['SUCCESS_URL'];
    FAILUREURL = json['FAILURE_URL'];
    BASKETID = json['BASKET_ID'];
    ORDERDATE = json['ORDER_DATE'];
    CHECKOUTURL = json['CHECKOUT_URL'];
    CURRENCYCODE = json['CURRENCY_CODE'];
    CUSTOMERNAME = json['CUSTOMER_NAME'];
    MERCHANTCUSTOMERID = json['MERCHANT_CUSTOMER_ID'];
    COUNTRY = json['COUNTRY'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['MERCHANT_ID'] = MERCHANTID;
    _data['MERCHANT_NAME'] = MERCHANTNAME;
    _data['TOKEN'] = TOKEN;
    _data['PROCCODE'] = PROCCODE;
    _data['TXNAMT'] = TXNAMT;
    _data['CUSTOMER_MOBILE_NO'] = CUSTOMERMOBILENO;
    _data['CUSTOMER_EMAIL_ADDRESS'] = CUSTOMEREMAILADDRESS;
    _data['SIGNATURE'] = SIGNATURE;
    _data['VERSION'] = VERSION;
    _data['TXNDESC'] = TXNDESC;
    _data['SUCCESS_URL'] = SUCCESSURL;
    _data['FAILURE_URL'] = FAILUREURL;
    _data['BASKET_ID'] = BASKETID;
    _data['ORDER_DATE'] = ORDERDATE;
    _data['CHECKOUT_URL'] = CHECKOUTURL;
    _data['CURRENCY_CODE'] = CURRENCYCODE;
    _data['CUSTOMER_NAME'] = CUSTOMERNAME;
    _data['MERCHANT_CUSTOMER_ID'] = MERCHANTCUSTOMERID;
    _data['COUNTRY'] = COUNTRY;
    return _data;
  }
}