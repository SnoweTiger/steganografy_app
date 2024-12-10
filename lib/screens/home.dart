import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:steganografy_app/components/message_input.dart';
import 'package:steganografy_app/steganography.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Uint8List? imageBytes;
  File? file;
  final _messageController = TextEditingController();
  ImageSteganography? steg;

  void loadImage() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.image,
    );

    if (result != null) {
      debugPrint('FilePickerResult 1');
      file = File(result.files.single.path!);
      imageBytes = await file!.readAsBytes();
      steg = ImageSteganography(imageBytes!);
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

    // String? outputFile = await FilePicker.platform.saveFile(
    //   dialogTitle: 'Please select an output file:',
    //   fileName: 'output-file.png',
    //   type: FileType.image,
    // );

    await steg!.cloakMessage(message);
    final outputFile = '';

    if (outputFile != null) {
      // final outputFilePath = outputFile + '.png';
      final outputFilePath = 'images/output-file.png';
      final png = steg!.getPNG();
      await File(outputFilePath).writeAsBytes(png);
    }
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
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 250,
                  margin: const EdgeInsets.all(15),
                  child: file == null
                      ? const Center(child: Text('Choose image'))
                      : Image.file(file!, fit: BoxFit.fill),
                ),
                // Container(
                //   height: 250,
                //   margin: const EdgeInsets.all(15),
                //   child: file == null
                //       ? const Center(child: Text('Choose image'))
                //       : Image.file(file!, fit: BoxFit.fill),
                // ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: loadImage,
                  child: const Text("Choose image (PNG)"),
                ),
                ElevatedButton(
                  onPressed: decodeImage,
                  child: const Text("Decode"),
                ),
                ElevatedButton(
                  onPressed: encodeImage,
                  child: const Text("Encode & save"),
                ),
              ],
            ),
            MessageInput(
              controller: _messageController,
              context: context,
              action: () {},
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
