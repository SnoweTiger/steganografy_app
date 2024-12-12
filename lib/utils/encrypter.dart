import 'package:encrypt/encrypt.dart';

class CustomEncrypter {
  late IV iv;

  CustomEncrypter() {
    iv = IV.fromSecureRandom(16);
  }

  String aes(String text, String secret) {
    // final key = Key.fromSecureRandom(32);
    final key = Key.fromUtf8(secret);
    final encrypter = Encrypter(AES(key));
    return encrypter.encrypt(text, iv: iv).base64;
  }
}
