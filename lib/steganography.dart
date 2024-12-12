import 'dart:convert';
import 'dart:typed_data';
import 'package:conversion/conversion.dart';
import 'package:image/image.dart';

import 'package:steganografy_app/utils/extensions.dart';

class ImageSteganography {
  final Convert convert = Convert();
  final String _tagBinary = '000111000111000';
  late Image _image;
  int _maxChars = 0;
  int _charLength = 0;
  String _message = '';

  Image get image => _image;
  int get maxChars => _maxChars;
  String get message => _message;
  Uint8List get png => encodePng(image);

  ImageSteganography({
    required Uint8List pngBytes,
    int charLength = 32,
    int imageChannels = 4,
    int usedChannels = 3,
  }) {
    final image = decodeImage(pngBytes);
    // final image = decodePng(pngBytes);

    if (image == null) {
      throw Exception('Image format not supported');
    } else {
      // _image = image.convert(numChannels: imageChannels);
      _image = image;

      final pixels = _image.height * _image.width * usedChannels;
      _charLength = charLength;
      _maxChars = (pixels - 2 * _tagBinary.length) ~/ _charLength;
      print('max utf-32 chars = $_maxChars ($_charLength)');
    }
  }

  Future<int?> cloakMessage(String message) async {
    if (message.length > _maxChars) return 406;
    _message = message;

    final cloakMessageBinary = _encodeMessage(message);
    _image = await _swapLastBit(_image, cloakMessageBinary);

    return null;
  }

  String _encodeMessage(String message) {
    String messageBinary = '';

    try {
      final encodedMessage = utf8.encode(message);
      for (String charCode in convert.decimalToBinary(values: encodedMessage)) {
        messageBinary += charCode.padLeft(_charLength, '0');
      }
      // messageBinary = message.toUTFBinary(_charLength);
      messageBinary = _tagBinary + messageBinary + _tagBinary;
    } catch (e) {
      throw Exception('Error encode message: $e');
    }

    return messageBinary;
  }

  Future<Image> _swapLastBit(Image frame, String messageBinary) async {
    int messageIndex = 0;
    List<String> binaryColors;
    String color;

    try {
      for (final pixel in frame) {
        if (messageIndex == messageBinary.length) break;
        binaryColors = convert.decimalToBinary(
          values: [pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt()],
        );

        for (int i = 0; i < 3; i++) {
          color = binaryColors[i].padLeft(8, '0');
          binaryColors[i] = color.substring(0, 7) + messageBinary[messageIndex];
          messageIndex++;
          if (messageIndex == messageBinary.length) break;
        }

        final encodedColors = convert.binaryTodecimal(values: binaryColors);
        pixel.setRgba(
          encodedColors[0],
          encodedColors[1],
          encodedColors[2],
          pixel.a,
        );
      }
    } catch (e) {
      throw Exception('Error encode image: $e');
    }
    return frame;
  }

  Future<String> getMessage() async {
    final messageBinary = await _extractString(_image);
    final message = _decodeMessage(messageBinary);
    return message;
  }

  Future<String> _extractString(Image frame) async {
    bool endTagFound = false;
    bool startTagFound = false;
    List<int> intColors;
    List<String> binaryColors;
    String color;
    String imageTag = '';
    String messageBinary = '';

    try {
      for (final pixel in _image) {
        if (endTagFound) break;
        intColors = [pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt()];
        binaryColors = convert.decimalToBinary(values: intColors);

        for (int i = 0; i < 3; i++) {
          color = binaryColors[i].padLeft(8, '0');
          imageTag += color[7];
          if (startTagFound) messageBinary += color[7];

          if (imageTag.length == _tagBinary.length) {
            if (imageTag != _tagBinary) {
              imageTag = imageTag.substring(1);
            } else {
              if (startTagFound) {
                endTagFound = true;
                break;
              } else {
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
      throw Exception('Error restore message: $e');
    }
    return messageBinary;
  }

  String _decodeMessage(String messageBinary) {
    String message = '';
    try {
      final split = messageBinary.splitByLength(_charLength);
      final splitDecimal = convert.binaryTodecimal(values: split);
      message = utf8.decode(splitDecimal);
    } catch (e) {
      throw Exception('Error decode message: $e');
    }
    return message;
  }

  List<String> _splitByLength(String message, int length) {
    List<String> pieces = [];
    for (int i = 0; i < message.length; i += length) {
      int offset = i + length;
      String piece = message.substring(
          i, offset >= message.length ? message.length : offset);

      pieces.add(piece);
    }
    return pieces;
  }
}



  // List<String> splitByLength(int length) =>
  //     [substring(0, length), substring(length)];

