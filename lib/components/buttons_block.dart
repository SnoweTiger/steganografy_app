import 'package:flutter/material.dart';

class ButtonsBlock extends StatelessWidget {
  Function load;
  Function decode;
  Function encode;

  ButtonsBlock({
    required this.load,
    required this.decode,
    required this.encode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: () => load(),
            child: const Text("Choose image (PNG)"),
          ),
          ElevatedButton(
            onPressed: () => decode(),
            child: const Text("Decode"),
          ),
          ElevatedButton(
            onPressed: () => encode(),
            child: const Text("Encode & save"),
          ),
        ],
      ),
    );
  }
}
