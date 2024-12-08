import 'dart:typed_data';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Uint8List? imageBytes;
  File? file;

  void encodeImage() async {
    String? outputFile = await FilePicker.platform.saveFile(
      dialogTitle: 'Please select an output file:',
      fileName: 'output-file.png',
      // type: FileType.image,
      // allowedExtensions: ['png'],
      bytes: await file!.readAsBytes(),
    );

    if (outputFile == null) {
      // User canceled the picker
    } else {
      print(outputFile);
      file!.copy(outputFile);
    }
  }

  void chooseImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.image,
      allowedExtensions: ['png', 'jpg', 'jpeg'],
    );

    if (result != null) {
      print(1);
      file = File(result.files.single.path!);
      setState(() {});
    } else {
      print(2);
    }

    // FilePickerResult? result;

    // if (result != null) {
    //   setImage(result);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Steganografy App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 500,
              margin: const EdgeInsets.all(15),
              child: file == null
                  ? const Center(child: Text('Choose image'))
                  : Image.file(
                      file!,
                      fit: BoxFit.fill,
                    ),
              // Image.memory(
              //     imageBytes!,
              //
              //   ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: chooseImage,
                  child: const Text("Choose image (PNG)"),
                ),
                ElevatedButton(
                  onPressed: encodeImage,
                  child: const Text("Encode & save"),
                ),
              ],
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
