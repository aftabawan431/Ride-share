import 'package:flutter_rideshare/core/utils/extension/extensions.dart';
import 'package:logger/logger.dart';

class GetWalletInfoResponseModel {
  GetWalletInfoResponseModel({
    required this.msg,
    required this.data,
  });
  late final String msg;
  late final Data data;

  GetWalletInfoResponseModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    data = Data.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['msg'] = msg;
    _data['data'] = data.toJson();
    return _data;
  }
}

class Data {
  Data({
    required this.walletInfo,
    required this.zindgiWalletInfo,
  });
  late final WalletInfo walletInfo;
  ZindgiWalletInfo? zindgiWalletInfo;

  factory Data.fromJson(Map<String, dynamic> json) {

    return Data(
        walletInfo: WalletInfo.fromJson(json['walletInfo']),
        zindgiWalletInfo:json['zindgiWalletInfo']==null?null: ZindgiWalletInfo.fromJson(json['zindigiWalletInfo']));
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['walletInfo'] = walletInfo.toJson();
    _data['zindgiWalletInfo'] = zindgiWalletInfo!.toJson();
    return _data;
  }
}

class WalletInfo {
  WalletInfo({
    required this.wallet,
    required this.zindgiWallet,
    required this.id,
    required this.firstName,
    required this.lastName,
  });
  late final Wallet wallet;
  late final ZindgiWallet zindgiWallet;
  late final String id;
  late final String firstName;
  late final String lastName;

  String getFullName() {
    return "${firstName} ${lastName}".toTitleCase();
  }

  WalletInfo.fromJson(Map<String, dynamic> json) {

    wallet = Wallet.fromJson(json['wallet']);
    zindgiWallet = ZindgiWallet.fromJson(json['zindigiWallet']);

    id = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['wallet'] = wallet.toJson();
    _data['zindgiWallet'] = zindgiWallet.toJson();
    _data['_id'] = id;
    _data['firstName'] = firstName;
    _data['lastName'] = lastName;
    return _data;
  }
}

class Wallet {
  Wallet({
    required this.balance,
  });
  late final int balance;

  Wallet.fromJson(Map<String, dynamic> json) {

    balance = json['balance'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['balance'] = balance;
    return _data;
  }
}

class ZindgiWallet {
  ZindgiWallet({
     this.zindgiWalletNumber,
    required this.linked,
  });
  String? zindgiWalletNumber;
  late final bool linked;

  factory ZindgiWallet.fromJson(Map<String, dynamic> json) {

    return ZindgiWallet(
      zindgiWalletNumber: json['zindigiWalletNumber'],
      linked: json['linked'],
    );
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['zindgiWalletNumber'] = zindgiWalletNumber;
    _data['linked'] = linked;
    return _data;
  }
}

class ZindgiWalletInfo {
  ZindgiWalletInfo({
    required this.title,
    required this.balance,
  });
  late final String title;
  late final int balance;

  ZindgiWalletInfo.fromJson(Map<String, dynamic> json) {
    Logger().v(json);
    Logger().v("here 3");
    title = json['title'];
    balance = json['balance'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['title'] = title;
    _data['balance'] = balance;
    return _data;
  }
}
