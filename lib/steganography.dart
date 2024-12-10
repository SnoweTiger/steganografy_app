import 'dart:convert';
import 'dart:typed_data';
import 'package:conversion/conversion.dart';
import 'package:image/image.dart';

class ImageSteganography {
  late Image _image;
  late Uint8List _bytes;
  String _message = '';
  // String _tag = '#~#';
  // String _tagBinary = '001000110111111000100011';
  String _tagBinary = '000111000111000';
  final Convert convert = Convert();

  Image get image => _image;
  Uint8List get bytes => _bytes;
  String get message => _message;

  ImageSteganography(Uint8List bytes, [String tag = '#tag#']) {
    _bytes = bytes;
    // final image = decodeImage(bytes);
    final image = decodePng(bytes);

    if (image == null) {
      throw Exception('Image format not supported');
    } else {
      _image = image; //.convert(numChannels: 4);
    }

    // _terminatingTag = tag;
    // _terminatingTagBinary = encodeString(tag);
    // print(_terminatingTag);
    // print(_terminatingTagBinary);
  }

  Uint8List getPNG() {
    final png = encodePng(image);
    return png;
  }

  Future<void> cloakMessage(String message, [int usedChannels = 3]) async {
    final pixelCount = _image.height * _image.width * usedChannels;
    _message = message;

    try {
      // final messageBinary = encodeString(message);
      const messageBinary = '10101';
      final cloakMessageBinary = _tagBinary + messageBinary + _tagBinary;

      // Image frame = _image.frames[0];
      // Image frame = _image.frames.single;
      // frame = await swapLastBit(frame, cloakMessageBinary);
      // _image.frames[0] = frame;
      // _image = frame;
      _image = await swapLastBit(_image, cloakMessageBinary);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<String> getMessage() async {
    String message = '';
    String messageBinary = '';
    String imageTag = '';
    bool startTagFound = false;
    bool endTagFound = false;

    try {
      final frame = _image;
      // final frame = _image.frames[0];
      // message = restoreFromLastBit(frame, _tagBinary);

      for (final pixel in frame) {
        if (endTagFound) break;

        final intColors = [pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt()];
        final binaryColors = convert.decimalToBinary(values: intColors);

        for (int i = 0; i < 3; i++) {
          final batch = binaryColors[i].padLeft(8, '0');
          imageTag += batch[7];
          if (startTagFound) {
            messageBinary += batch[7];
          }
          if (imageTag.length == _tagBinary.length) {
            if (imageTag != _tagBinary) {
              imageTag = imageTag.substring(1);
            } else {
              if (startTagFound) {
                // print('endTagFound');
                endTagFound = true;
                break;
              } else {
                // print('startTagFound');
                imageTag = '';
                startTagFound = true;
              }
            }
          }
        }
      }

      final messageLength = messageBinary.length - _tagBinary.length;
      messageBinary = messageBinary.substring(0, messageLength);
      print('messageBinary = $messageBinary');
    } catch (e) {
      throw Exception(e);
    }
    return message;
  }

  Future<Image> swapLastBit(Image frame, String cloakMessageBinary) async {
    final cloakMessageLength = cloakMessageBinary.length;

    String bit = '';
    int charIndex = 0;
    for (final pixel in frame) {
      if (charIndex == cloakMessageLength) break;

      final intColors = [pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt()];
      final binaryColors = convert.decimalToBinary(values: intColors);

      for (int i = 0; i < 3; i++) {
        bit = cloakMessageBinary[charIndex];
        final batch = binaryColors[i].padLeft(8, '0');
        binaryColors[i] = batch.substring(0, 7) + bit;

        charIndex++;
        if (charIndex == cloakMessageLength) break;
      }

      final encodedColors = convert.binaryTodecimal(values: binaryColors);
      pixel.setRgba(
        encodedColors[0],
        encodedColors[1],
        encodedColors[2],
        pixel.a,
      );
    }

    return frame;
  }

  String restoreFromLastBit(Image frame, String tagBinary) {
    String messageBinary = '';
    String imageTag = '';
    bool startTagFound = false;
    bool endTagFound = false;

    for (final pixel in frame) {
      if (endTagFound) break;

      final intColors = [pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt()];
      final binaryColors = convert.decimalToBinary(values: intColors);

      for (int i = 0; i < 3; i++) {
        final batch = binaryColors[i].padLeft(8, '0');
        imageTag += batch[7];
        if (startTagFound) {
          messageBinary += batch[7];
        }
        if (imageTag.length == tagBinary.length) {
          if (imageTag != tagBinary) {
            imageTag = imageTag.substring(1);
          } else {
            if (startTagFound) {
              // print('endTagFound');
              endTagFound = true;
              break;
            } else {
              // print('startTagFound');
              imageTag = '';
              startTagFound = true;
            }
          }
        }
      }
    }

    final messageLength = messageBinary.length - tagBinary.length;
    messageBinary = messageBinary.substring(0, messageLength);
    print('messageBinary = $messageBinary');
    return messageBinary;
  }

  String encodeString(String message) {
    final encodedMessage = utf8.encode(message);
    String messageBinary = '';

    for (var charCode in convert.decimalToBinary(values: encodedMessage)) {
      messageBinary += charCode;
    }

    return messageBinary;
  }
}
