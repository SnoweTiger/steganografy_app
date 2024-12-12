import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as service;
import 'package:steganografy_app/components/message_input.dart';
import 'package:steganografy_app/components/encryption_toggle.dart';
import 'package:steganografy_app/components/bottom_bar.dart';
import 'package:steganografy_app/steganography.dart';
import 'package:steganografy_app/utils/constants.dart';
import 'package:steganografy_app/utils/encrypter.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _messageController = TextEditingController();
  final _secretController = TextEditingController();
  File? file;
  ImageSteganography? steg;
  int? _messageMaxLength;
  int encryptionType = 0;
  Uint8List? imageBytes;
  List<bool> selectedEncryption = [true, false, false];
  bool decodeEnable = false;
  bool encodeEnable = false;
  late CustomEncrypter encryter;

  void switchEncryptionType(int index, List<bool> selected) {
    encryptionType = index;
    selected[0] = false;
    selected[1] = false;
    selected[2] = false;
    selected[index] = !selected[index];
    setState(() {});
  }

  void loadImage() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.image,
    );

    if (result != null) {
      file = File(result.files.single.path!);
      if (file != null) {
        imageBytes = await file!.readAsBytes();
        steg = ImageSteganography(pngBytes: imageBytes!);
        decodeEnable = true;
        encodeEnable = true;
      }
      setState(() {});
    } else {
      debugPrint('FilePickerResult else');
    }
  }

  void decodeImage() async {
    final message = await steg!.getMessage();
    _messageController.text = message;
    setState(() {});
  }

  void encodeImage() async {
    String message = _messageController.text;
    final outputFilePath = '${file!.path.split('.')[0]}-updated.png';

    switch (encryptionType) {
      case 1:
        print('secret ${_secretController.text}');
        final message2 = encryter.aes(message, _secretController.text);
        print('message2 = $message2');

        message = message + '1';
      case 2:
        message = message + '2';
    }

    print(message);

    final statusCode = await steg!.cloakMessage(message);

    if (statusCode == null) {
      final png = steg!.png;
      await File(outputFilePath).writeAsBytes(png);
    }
  }

  @override
  void initState() {
    encryter = CustomEncrypter();
    decodeEnable = false;
    encodeEnable = false;
    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const title = 'Steganografy App';
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: mainColor,
        title: const Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            height: imageHeight,
            width: imageWidth,
            margin: symmetricEdgeInsets,
            padding: EdgeInsets.zero,
            child: file == null
                ? const Center(child: Text('Choose image'))
                : Image.file(file!, fit: BoxFit.contain),
          ),
          const Spacer(),
          TextInput(
            controller: _messageController,
            enable: file == null ? false : true,
            hintText: 'Message',
            inputHeight: messageBoxH,
            isClearButton: true,
            maxLength: _messageMaxLength,
            textAlignVertical: TextAlignVertical.top,
          ),
          const Text('Additional encryption message?'),
          EncryptionToggle(
            context: context,
            selectedEncryption: selectedEncryption,
            enable: file != null,
            action: switchEncryptionType,
          ),
          TextInput(
            controller: _secretController,
            enable: (file != null && [1, 2].contains(encryptionType))
                ? true
                : false,
            hintText: 'Secret',
            inputHeight: messageBoxH,
            isClearButton: true,
            maxLength: secretLength,
            maxLines: 1,
            padRightEnable: true,
            inputFormatters: [
              service.FilteringTextInputFormatter.allow(
                RegExp('[a-z A-Z 0-9]'),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomBar(
        loadImage: loadImage,
        decodeImage: decodeImage,
        encodeImage: encodeImage,
        decodeEnable: decodeEnable,
        encodeEnable: encodeEnable,
      ),
    );
  }
}
