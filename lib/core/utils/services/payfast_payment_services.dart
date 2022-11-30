import 'package:dio/dio.dart';
import '../../modals/get_fast_pay_token_request_model.dart';
import '../../modals/get_fast_pay_token_response_model.dart';

class PayfastPaymentService {
  static const String _getTokenUrl =
      'https://ipguat.apps.net.pk/Ecommerce/api/Transaction/GetAccessToken';

  static const String redirectionUrl =
      'https://ipguat.apps.net.pk/Ecommerce/api/Transaction/PostTransaction';

  static const String merchantKey = '';
  static const String securedKey = '';
  static const String basketID = '';

  static Future<GetFastPayTokenResponseModel> getToken(String amount) async {
    try {
      final body = GetFastPayTokenRequestModel(
          MERCHANTID: merchantKey,
          SECUREDKEY: securedKey,
          BASKETID: basketID,
          TXNAMT: amount);

      final response = await Dio().post(_getTokenUrl, data: body.toJson());
      return GetFastPayTokenResponseModel.fromJson(response.data);
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
