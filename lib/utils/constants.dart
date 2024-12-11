import 'package:flutter/material.dart';

const borderRadius = 15.0;
const imageHeight = 350.0;
const imageWidth = 700.0;
const messageBoxH = 100.0;
const paddingH = 30.0;
const paddingV = 15.0;
const buttonGroupHeigh = 45.0;

// Colors
const borderColor = Colors.grey;
const selectedColorText = Colors.white;
const selectedColorBack = Colors.amber;
const mainColor = Color(0xff3f51b5);

// Styles
final outlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(borderRadius),
  borderSide: const BorderSide(color: borderColor),
);

final outlineInputBorderFocused = OutlineInputBorder(
  borderRadius: BorderRadius.circular(borderRadius),
  borderSide: const BorderSide(color: mainColor),
);

const borderRadiusAll = BorderRadius.all(Radius.circular(borderRadius));

const symmetricEdgeInsets = EdgeInsets.symmetric(
  vertical: paddingV,
  horizontal: paddingH,
);
