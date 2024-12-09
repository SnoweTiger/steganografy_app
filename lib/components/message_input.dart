import 'package:flutter/material.dart';

class MessageInput extends StatelessWidget {
  final BuildContext context;
  final TextEditingController controller;
  Function action;

  MessageInput({
    required this.action,
    required this.context,
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const rowHeight = 100.0;

    final outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.grey),
    );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      height: rowHeight,
      child: TextField(
        // onChanged: (value) => action(controller.text),
        textAlignVertical: TextAlignVertical.center,
        controller: controller,
        expands: true,
        maxLines: null,
        decoration: InputDecoration(
          hintText: 'Message',
          contentPadding: const EdgeInsets.all(10),
          focusedBorder: outlineInputBorder,
          border: outlineInputBorder,
          hintStyle: const TextStyle(color: Colors.grey),
          suffixIcon: IconButton(
            onPressed: () => controller.clear(),
            icon: const Icon(Icons.clear),
          ),
        ),
      ),
    );
  }
}
