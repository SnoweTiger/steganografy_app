import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const borderRadius = 10.0;
const buttonGroupHeigh = 45.0;
const imageHeight = 300.0;
const imageWidth = 600.0;
const messageBoxH = 100.0;
const paddingH = 10.0;
const paddingV = 5.0;
const windowsWidth = 600.0;
const windowsHeight = 800.0;
const int secretLength = 32;

const publicKey = 'TestKeyX';
const allowedFileExtensions = ['png', 'jpg'];

final secretInputFormatter = [
  FilteringTextInputFormatter.allow(RegExp('[a-z A-Z 0-9]')),
];

// Colors
// const borderColor = Colors.grey;
const borderColor = mainColor;
const selectedColorText = Colors.white;
const selectedColorBack = Colors.blueGrey;
const mainColor = Colors.blueGrey;

// Styles
final outlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(borderRadius),
  borderSide: const BorderSide(color: borderColor),
);

final outlineInputBorderFocused = OutlineInputBorder(
  borderRadius: BorderRadius.circular(borderRadius),
  borderSide: const BorderSide(color: mainColor),
);

const symmetricEdgeInsets = EdgeInsets.symmetric(
  vertical: paddingV,
  horizontal: paddingH,
);
