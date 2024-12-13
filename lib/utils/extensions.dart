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
}
