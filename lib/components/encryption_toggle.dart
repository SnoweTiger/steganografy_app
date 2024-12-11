import 'package:flutter/material.dart';
import 'package:steganografy_app/utils/constants.dart';

class EncryptionToggle extends StatelessWidget {
  final BuildContext context;
  final List<bool> selectedEncryption;
  bool enable;
  Function action;

  EncryptionToggle({
    required this.action,
    required this.context,
    required this.selectedEncryption,
    this.enable = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final width = (MediaQuery.of(context).size.width - 2 * paddingH) /
        encryptionToggleWidgets(context).length;

    final constraints = BoxConstraints(
      minHeight: buttonGroupHeigh,
      maxWidth: width,
    );

    return Container(
      padding: const EdgeInsets.all(paddingV),
      child: ToggleButtons(
        constraints: constraints,
        onPressed:
            !enable ? null : (int index) => action(index, selectedEncryption),
        borderRadius: borderRadiusAll,
        borderColor: borderColor,
        fillColor: selectedColorBack,
        isSelected: selectedEncryption,
        selectedColor: selectedColorText,
        children: encryptionToggleWidgets(context),
      ),
    );
  }
}

List<Widget> encryptionToggleWidgets(BuildContext context) {
  List<Widget> tmp = [];

  List<String> encryptionTypes(BuildContext context) => [
        'No encryption',
        'AES',
        'Salsa',
      ];

  for (String type in encryptionTypes(context)) {
    tmp.add(Text(type));
  }

  tmp[0] = Padding(
    padding: EdgeInsets.zero,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.no_encryption, size: 15),
        tmp[0],
      ],
    ),
  );

  tmp[1] = Padding(
    padding: EdgeInsets.zero,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.enhanced_encryption, size: 15),
        tmp[1],
      ],
    ),
  );

  tmp[2] = Padding(
    padding: EdgeInsets.zero,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.enhanced_encryption, size: 15),
        tmp[2],
      ],
    ),
  );

  return tmp;
}
