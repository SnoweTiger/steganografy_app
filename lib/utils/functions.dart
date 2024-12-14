import 'package:flutter/material.dart';
import 'package:steganografy_app/utils/constants.dart';

void showMessage(
  BuildContext context,
  String text, [
  bool isError = false,
  int delay = 5,
]) {
  final Color backgroundColor = isError ? Colors.red : Colors.white;
  final Color textColor = isError ? Colors.white : Colors.green;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      // padding: EdgeInsets.zero,
      margin: const EdgeInsets.only(
        left: paddingH,
        right: paddingH,
        bottom: paddingV,
        // bottom: MediaQuery.of(context).size.height - 0.3 * MediaQuery.of(context).size.height,
      ),
      duration: Duration(seconds: delay),
      backgroundColor: backgroundColor,
      showCloseIcon: true,
      closeIconColor: textColor,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: textColor),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            !isError
                ? const Text('')
                : Icon(Icons.error_outline, color: textColor),
            Expanded(
              child: Text(
                text,
                overflow: TextOverflow.clip,
                softWrap: true,
                style: TextStyle(color: textColor),
              ),
            )
            // Padding(
            //   padding: const EdgeInsets.all(5.0),
            //   child: Expanded(
            //     child: Text(
            //       text,
            //       overflow: TextOverflow.clip,
            //       softWrap: true,
            //       // softWrap: false,
            //       style: TextStyle(color: textColor),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    ),
  );
}
