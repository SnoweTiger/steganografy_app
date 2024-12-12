import 'package:flutter/material.dart';

const borderRadius = 12.0;
const buttonGroupHeigh = 45.0;
const imageHeight = 300.0;
const imageWidth = 600.0;
const messageBoxH = 100.0;
const paddingH = 30.0;
const paddingV = 8.0;
const windowsWidth = 600.0;
const windowsHeight = 800.0;
const int secretLength = 32;

// Colors
const borderColor = Colors.grey;
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

// const borderRadiusAll = BorderRadius.all(Radius.circular(borderRadius));

const symmetricEdgeInsets = EdgeInsets.symmetric(
  vertical: paddingV,
  horizontal: paddingH,
);
