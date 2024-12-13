import 'package:encrypt/encrypt.dart';

class CustomEncrypter {
  late IV iv;

  CustomEncrypter() {
    iv = IV.fromSecureRandom(8);
  }

  String? encryptAES(String text, String secret) {
    final key = Key.fromUtf8(secret);
    return _encrypt(text, AES(key));
  }

  String? encryptSalsa(String text, String secret) {
    final key = Key.fromUtf8(secret);
    return _encrypt(text, Salsa20(key));
  }

  String? decryptAES(String text, String secret) {
    final key = Key.fromUtf8(secret);
    return _decrypt(text, AES(key));
  }

  String? decryptSalsa(String text, String secret) {
    final key = Key.fromUtf8(secret);
    return _decrypt(text, Salsa20(key));
  }

  String? _encrypt(String text, Algorithm algo) {
    String? message;
    try {
      final encrypter = Encrypter(algo);
      message = encrypter.encrypt(text, iv: iv).base64;
    } catch (e) {
      Exception(e);
    }
    return message;
  }

  String? _decrypt(String text, Algorithm algo) {
    String? message;
    try {
      final encrypter = Encrypter(algo);
      message = encrypter.decrypt64(text, iv: iv);
    } catch (e) {
      Exception(e);
    }
    return message;
  }
}
