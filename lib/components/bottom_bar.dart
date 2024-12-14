import 'package:flutter/material.dart';
import 'package:steganografy_app/components/custom_button.dart';
import 'package:steganografy_app/generated/l10n.dart';
import 'package:steganografy_app/utils/constants.dart';

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
          title: S.of(context).loadImage,
          action: loadImage,
          paddingL: paddingH,
          paddingR: paddingH / 8,
        ),
        CustomButton(
          title: S.of(context).decode,
          action: decodeImage,
          paddingL: paddingH / 8,
          paddingR: paddingH / 8,
          disabled: !decodeEnable,
        ),
        CustomButton(
          title: S.of(context).encodeSave,
          action: encodeImage,
          paddingL: paddingH / 8,
          paddingR: paddingH,
          disabled: !encodeEnable,
        ),
      ],
    );
  }
}
