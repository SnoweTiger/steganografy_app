import 'package:flutter/material.dart';
import 'package:steganografy_app/utils/constants.dart';

class TextInput extends StatelessWidget {
  final bool isClearButton, enable;
  final double? inputHeight;
  final int? maxLength;
  final int? maxLines;
  final String? hintText;
  final TextEditingController controller;
  final TextAlignVertical? textAlignVertical;

  TextInput({
    required this.controller,
    this.enable = true,
    this.hintText,
    this.inputHeight,
    this.isClearButton = false,
    this.maxLength,
    this.maxLines,
    this.textAlignVertical,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    bool expands = true;
    if (maxLines != null) expands = false;

    return Container(
      margin: symmetricEdgeInsets,
      height: inputHeight,
      child: TextField(
        enabled: enable,
        controller: controller,
        expands: expands,
        maxLines: maxLines,
        maxLength: maxLength,
        textAlignVertical: textAlignVertical,
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding: const EdgeInsets.all(paddingV),
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
