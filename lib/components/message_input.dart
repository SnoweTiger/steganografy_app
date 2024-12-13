import 'package:flutter/material.dart';
import 'package:steganografy_app/utils/constants.dart';
import 'package:flutter/services.dart';

class TextInput extends StatelessWidget {
  final bool isClearButton, enable, expands;
  final double? inputHeight;
  final int? maxLength;
  final String? hintText, fillByChar;
  final TextEditingController controller;
  final TextAlignVertical? textAlignVertical;
  final List<TextInputFormatter>? inputFormatters;
  Function(String)? onUpdate;

  TextInput({
    required this.controller,
    this.enable = true,
    this.hintText,
    this.inputHeight,
    this.isClearButton = false,
    this.maxLength,
    this.expands = false,
    // this.maxLines,
    this.textAlignVertical,
    this.inputFormatters,
    this.fillByChar,
    this.onUpdate,
    super.key,
  });

  void onTapOutside(PointerDownEvent event) {
    controller.text = controller.text.padRight(32, fillByChar!);
  }

  @override
  Widget build(BuildContext context) {
    int? maxLines = 1;
    if (expands) {
      maxLines = null;
    }

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
        onTapOutside: fillByChar != null ? onTapOutside : null,
        onChanged: onUpdate,
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
