import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:steganografy_app/components/message_input.dart';
import 'package:steganografy_app/components/encryption_toggle.dart';
import 'package:steganografy_app/components/bottom_bar.dart';
import 'package:steganografy_app/steganography.dart';
import 'package:steganografy_app/utils/constants.dart';
// import 'package:steganografy_app/components/buttons_block.dart';

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
  Uint8List? imageBytes;
  List<bool> selectedEncryption = [true, false, false];
  bool decodeEnable = false;
  bool encodeEnable = false;

  void switchEncryptionType(int index, List<bool> selected) {
    List<bool> temp = [false, false, false];
    print('index = $index');
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
      debugPrint('FilePickerResult 1');
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
    final message = _messageController.text;
    const outputFilePath = 'images/output-file.png';

    // String? outputFile = await FilePicker.platform.saveFile(
    //   dialogTitle: 'Please select an output file:',
    //   fileName: 'output-file.png',
    //   type: FileType.image,
    // );
    // final outputFilePath = outputFile + '.png';

    final statusCode = await steg!.cloakMessage(message);

    if (statusCode == null) {
      final png = steg!.png;
      await File(outputFilePath).writeAsBytes(png);
    }
  }

  @override
  void initState() {
    decodeEnable = false;
    encodeEnable = false;
    // TODO: implement initState
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
            enable: file == null ? false : true,
            hintText: 'Secret',
            inputHeight: messageBoxH,
            isClearButton: true,
            maxLength: 16,
            maxLines: 1,
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
