import 'dart:convert';

import 'package:encrypt/encrypt.dart' as encryption;

class Encryption {
  static final encryption.Key key =
      encryption.Key.fromUtf8('e33b5c9c6c0998bc');
  static final encryption.IV iv = encryption.IV.fromUtf8('NcRfUjWnZr4u7x');
  static final encryption.Encrypter encrypt = encryption.Encrypter(
    encryption.AES(key, mode: encryption.AESMode.ctr, padding: 'PKCS7'),
  );

  static Map<String,dynamic> encryptObject(String object) {
    final encryption.Encrypted encrypted = encrypt.encrypt(
      object,
      iv: iv,
    );
    return {"cipher":encrypted.base64};
  }

  static String decryptObject(String response) {
    final String decrypted = encrypt.decrypt64(
      response,
      iv: iv,
    );
    return decrypted;
  }

  static Map<String, dynamic> decryptJson(Map<String, dynamic> map) {
    final String decrypted = encrypt.decrypt64(
      map['cipher'],
      iv: iv,
    );
    return jsonDecode(decrypted);
  }
}
