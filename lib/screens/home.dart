import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:steganografy_app/components/all.dart';
import 'package:steganografy_app/generated/l10n.dart';
import 'package:steganografy_app/steganography.dart';
import 'package:steganografy_app/utils/all.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _messageController = TextEditingController();
  final _secretController = TextEditingController();
  late CustomEncrypter encryter;
  bool decodeEnable = false;
  bool encodeEnable = false;
  File? file;
  ImageSteganography? steg;
  int encryptionType = 0;
  List<bool> selectedEncryption = [true, false, false];
  Uint8List? imageBytes;

  bool encodeAvailable() {
    bool encodeAvailable;

    if (_messageController.text.isNotEmpty &&
        (encryptionType == 0 || _secretController.text.isNotEmpty)) {
      encodeAvailable = true;
    } else {
      encodeAvailable = false;
    }

    return encodeAvailable;
  }

  void switchEncryptionType(int index, List<bool> selected) {
    encryptionType = index;
    selected[0] = false;
    selected[1] = false;
    selected[2] = false;
    selected[index] = !selected[index];
    encodeEnable = encodeAvailable();
    setState(() {});
  }

  void onSecretUpdate(String text) {
    encodeEnable = encodeAvailable();
    setState(() {});
  }

  void raiseNotification(
    BuildContext context,
    String notification, [
    bool error = false,
  ]) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showMessage(context, notification, error);
    });
  }

  void loadImage() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.image,
    );
    if (result == null) return;

    try {
      file = File(result.files.single.path!);
      if (file == null) throw Exception('');
      imageBytes = await file!.readAsBytes();
      steg = ImageSteganography(pngBytes: imageBytes!);
    } catch (e) {
      const notification = 'Error: read file';
      debugPrint(notification);
      showMessage(context, notification, true);
      return;
    }

    decodeEnable = true;
    encodeEnable = encodeAvailable();
    setState(() {});
    final notification =
        'Loaded image-${steg!.image.width}x${steg!.image.height}x3\npixels=${steg!.image.width * steg!.image.height}\nmax utf-32 chars = ${steg!.maxChars}';
    debugPrint(notification);
    raiseNotification(context, notification);
  }

  void decodeImage() async {
    String? messageFromImage = await steg!.getMessage();
    if (messageFromImage == null) {
      raiseNotification(context, 'Error: Message not found', true);
      return;
    }

    switch (encryptionType) {
      case 1:
        messageFromImage = encryter.decryptAES(
          messageFromImage,
          _secretController.text,
        );
      case 2:
        messageFromImage = encryter.decryptSalsa(
          messageFromImage,
          _secretController.text,
        );
    }
    if (messageFromImage == null) {
      raiseNotification(context, 'Error decrypt message', true);
      return;
    }

    _messageController.text = messageFromImage;
    setState(() {});
  }

  void encodeImage() async {
    String? message = _messageController.text;
    final outputFilePath = '${file!.path.split('.')[0]}-updated.png';

    switch (encryptionType) {
      case 1:
        message = encryter.encryptAES(
          message,
          _secretController.text,
        );
      case 2:
        message = encryter.encryptSalsa(
          message,
          _secretController.text,
        );
    }
    if (message == null) {
      raiseNotification(context, 'Error: encrypt message', true);
      return;
    }

    if (message.length <= steg!.maxChars) {
      final statusCode = await steg!.cloakMessage(message);
      if (statusCode == null) {
        final png = steg!.png;
        await File(outputFilePath).writeAsBytes(png);

        String notification = 'Image encoded.\n ${File(outputFilePath).path}';
        debugPrint(notification);
        raiseNotification(context, notification);
      }
    } else {
      final String notification =
          'Error: max chars ${steg!.maxChars}, message chars ${message.length}(after encryption)';
      debugPrint(notification);
      raiseNotification(context, notification, true);
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text(
          S.of(context).title,
          style: const TextStyle(color: Colors.white),
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
                ? Center(child: Text(S.of(context).chooseImage))
                : Image.file(
                    file!,
                    fit: BoxFit.scaleDown,
                    // fit: BoxFit.contain,
                  ),
          ),
          const Spacer(),
          TextInput(
            controller: _messageController,
            enable: file == null ? false : true,
            expands: true,
            hintText: S.of(context).message,
            inputHeight: messageBoxH,
            isClearButton: true,
            textAlignVertical: TextAlignVertical.top,
            onUpdate: onSecretUpdate,
          ),
          Text(S.of(context).additionalEncryptionMessage),
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
            hintText: S.of(context).secrethint,
            inputFormatters: secretInputFormatter,
            inputHeight: messageBoxH,
            isClearButton: true,
            maxLength: secretLength,
            fillByChar: 'X',
            onUpdate: onSecretUpdate,
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
