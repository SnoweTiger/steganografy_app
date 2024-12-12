import 'package:flutter/material.dart';
import 'package:steganografy_app/utils/constants.dart';
import 'package:flutter/services.dart';

class TextInput extends StatelessWidget {
  final bool isClearButton, enable, padRightEnable;
  final double? inputHeight;
  final int? maxLength;
  final int? maxLines;
  final String? hintText;
  final TextEditingController controller;
  final TextAlignVertical? textAlignVertical;
  final List<TextInputFormatter>? inputFormatters;

  TextInput({
    required this.controller,
    this.enable = true,
    this.hintText,
    this.inputHeight,
    this.isClearButton = false,
    this.maxLength,
    this.maxLines,
    this.textAlignVertical,
    this.inputFormatters,
    this.padRightEnable = false,
    super.key,
  });

  void onTapOutside(PointerDownEvent event) {
    controller.text = controller.text.padRight(32, '0');
  }

  @override
  Widget build(BuildContext context) {
    bool expands = true;
    if (maxLines != null) expands = false;

    return Container(
      margin: symmetricEdgeInsets,
      height: inputHeight,
      child: TextField(
        inputFormatters: inputFormatters,
        enabled: enable,
        controller: controller,
        expands: expands,
        maxLines: maxLines,
        maxLength: maxLength,
        textAlignVertical: textAlignVertical,
        onTapOutside: padRightEnable ? onTapOutside : null,
        decoration: InputDecoration(
          hintText: hintText,
          focusedBorder: outlineInputBorderFocused,
          enabledBorder: outlineInputBorder,
          border: outlineInputBorder,
          hintStyle: const TextStyle(color: Colors.grey),
          suffixIcon: !isClearButton
              ? null
              : IconButton(
                  color: borderColor,
                  icon: const Icon(Icons.clear),
                  onPressed: () => controller.clear(),
                ),
        ),
      ),
    );
  }
}
