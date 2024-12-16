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
  late List<bool> selectedEncryption;
  bool decodeEnable = false;
  bool encodeEnable = false;
  File? file;
  ImageSteganography? steg;
  int encryptionType = 0;

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

  void onInputUpdate(String text) {
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
      type: FileType.custom,
      allowedExtensions: allowedFileExtensions,
    );
    if (result == null) return;

    _messageController.text = '';

    try {
      file = File(result.files.single.path!);
      if (file == null) throw Exception('');

      final Uint8List imageBytes = await file!.readAsBytes();
      steg = ImageSteganography(pngBytes: imageBytes);
    } catch (e) {
      final notification = '${S.of(context).error} ${S.of(context).readFile}';
      debugPrint(notification);
      showMessage(context, notification, true);
      return;
    }

    decodeEnable = true;
    encodeEnable = encodeAvailable();
    setState(() {});

    final notification =
        '${S.of(context).loadedImage}\n${steg!.image.width}x${steg!.image.height}x3\npixels=${steg!.image.width * steg!.image.height}\nmax utf-32 chars = ${steg!.maxChars}';
    debugPrint(notification);
    raiseNotification(context, notification);
  }

  void decodeImage() async {
    String? messageFromImage = await steg!.getMessage();
    if (messageFromImage == null) {
      raiseNotification(
        context,
        '${S.of(context).error} ${S.of(context).messageNotFound}',
        true,
      );
      return;
    }

    switch (encryptionType) {
      case 1:
        final secret = _secretController.text.padRight(32, 'x');
        messageFromImage = encryter.decryptAES(messageFromImage, secret);
      case 2:
        final secret = _secretController.text.padRight(32, 'x');
        messageFromImage = encryter.decryptSalsa(messageFromImage, secret);
    }
    if (messageFromImage == null) {
      raiseNotification(
        context,
        '${S.of(context).error} ${S.of(context).decryptMessage}',
        true,
      );
      return;
    }

    _messageController.text = messageFromImage;
    raiseNotification(context, S.of(context).foundMessageSymbols);
    setState(() {});
  }

  void encodeImage() async {
    String? message = _messageController.text;

    // Encrypt message
    if (encryptionType != 0) {
      final secret = _secretController.text.padRight(32, 'x');
      switch (encryptionType) {
        case 1:
          message = encryter.encryptAES(message, secret);
        case 2:
          message = encryter.encryptSalsa(message, secret);
      }
      if (message == null) {
        raiseNotification(
          context,
          '${S.of(context).error} ${S.of(context).encryptionMessage}',
          true,
        );
        return;
      }
    }

    // Check message length
    if (message.length > steg!.maxChars) {
      final String notification =
          '${S.of(context).error} ${S.of(context).messageChars}=${message.length}(${S.of(context).afterEncryption})';
      debugPrint(notification);
      raiseNotification(context, notification, true);
      return;
    }

    // Cloak message
    final statusCode = await steg!.cloakMessage(message);
    if (statusCode != null) {
      final notification =
          '${S.of(context).error} ${S.of(context).cloakMessage}';
      debugPrint(notification);
      raiseNotification(context, notification, true);
      return;
    }

    // Write file
    final png = steg!.png;
    final String notificationWrite;
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      final outputFilePath = '${file!.path.split('.')[0]}-updated.png';
      await File(outputFilePath).writeAsBytes(png);
      notificationWrite =
          '${S.of(context).imageEncoded}\n${File(outputFilePath).path}';
    } else {
      String? result = await FilePicker.platform.saveFile(
        dialogTitle: S.of(context).pleaseSelectAnOutputFile,
        fileName: 'image-updated.png',
        bytes: png,
        type: FileType.image,
      );
      if (result == null) {
        final notification =
            '${S.of(context).error} ${S.of(context).imageEncoded}';
        debugPrint(notification);
        raiseNotification(context, notification, true);
        return;
      }
      notificationWrite = '${S.of(context).imageEncoded}\n$result';
    }
    debugPrint(notificationWrite);
    raiseNotification(context, notificationWrite);
  }

  @override
  void initState() {
    encryter = CustomEncrypter.fromPublicKey(publicKey);
    decodeEnable = false;
    encodeEnable = false;
    selectedEncryption = [true, false, false];
    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _secretController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Add singlechildscrollview for android

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text(
          S.of(context).title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: imageHeight,
              width: imageWidth,
              margin: symmetricEdgeInsets,
              child: file == null
                  ? Center(child: Text(S.of(context).chooseImage))
                  : Image.file(
                      file!,
                      fit: BoxFit.scaleDown,
                    ),
            ),
            TextInput(
              controller: _messageController,
              enable: file == null ? false : true,
              expands: true,
              hintText: S.of(context).message,
              inputHeight: messageBoxH,
              isClearButton: true,
              textAlignVertical: TextAlignVertical.top,
              onUpdate: onInputUpdate,
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
              onUpdate: onInputUpdate,
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
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
