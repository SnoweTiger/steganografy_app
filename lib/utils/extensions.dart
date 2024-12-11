import 'dart:convert';

extension Binary on String {
  List<String> splitByLength(int length) {
    List<String> pieces = [];
    for (int i = 0; i < this.length; i += length) {
      int offset = i + length;
      String piece =
          this.substring(i, offset >= this.length ? this.length : offset);

      pieces.add(piece);
    }
    return pieces;
  }

  // String toUTFBinary(int maxCharLength) {
  //   String message = '';
  //   for (int charCode in utf8.encode(this)) {
  //     String charBin = '';
  //     while (charCode > 0) {
  //       charBin = (charCode % 2 == 0 ? '0' : '1') + charBin;
  //       charCode ~/= 2;
  //     }
  //     message += charBin;
  //   }
  //   return message;
  // }
}
