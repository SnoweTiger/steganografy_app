import 'package:flutter/material.dart';
import 'package:steganografy_app/utils/constants.dart';

class CustomButton extends StatelessWidget {
  final String title;
  Function action;
  bool disabled;
  double paddingL, paddingR, paddingT, paddingB;

  CustomButton({
    required this.action,
    required this.title,
    required this.paddingL,
    required this.paddingR,
    required this.paddingT,
    required this.paddingB,
    this.disabled = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          height: buttonGroupHeigh,
          margin: EdgeInsets.only(
            left: paddingL,
            right: paddingR,
            top: paddingT,
            bottom: paddingB,
          ),
          child: ElevatedButton(
            onPressed: disabled ? null : () => action(),
            style: ElevatedButton.styleFrom(
              alignment: Alignment.center,
              padding: EdgeInsets.zero,
              elevation: 5,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: mainColor),
                borderRadius: BorderRadius.circular(borderRadius),
              ),
            ),
            child: Text(
              title,
              style: const TextStyle(color: mainColor),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
}
