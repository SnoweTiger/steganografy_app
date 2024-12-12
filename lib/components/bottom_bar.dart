import 'package:flutter/material.dart';
import 'package:steganografy_app/utils/constants.dart';
import 'package:steganografy_app/components/custom_button.dart';

class BottomBar extends StatelessWidget {
  Function loadImage;
  Function decodeImage;
  Function encodeImage;
  bool decodeEnable;
  bool encodeEnable;

  BottomBar({
    required this.loadImage,
    required this.decodeImage,
    required this.encodeImage,
    this.decodeEnable = false,
    this.encodeEnable = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomButton(
          title: 'Load image',
          action: loadImage,
          paddingL: paddingH,
          paddingR: paddingH / 2,
        ),
        CustomButton(
          title: 'Decode',
          action: decodeImage,
          paddingL: paddingH / 2,
          paddingR: paddingH / 2,
          disabled: !decodeEnable,
        ),
        CustomButton(
          title: 'Encode & save',
          action: encodeImage,
          paddingL: paddingH / 2,
          paddingR: paddingH,
          disabled: !encodeEnable,
        ),
      ],
    );
  }
}
