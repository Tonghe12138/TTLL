enum FretCount {
  _21(21),
  _22(22),
  _23(23),
  _24(24);

  final int count;

  const FretCount(this.count);
}

class Guitar {
  static const stringsCount = 6;
  FretCount fretCount;

  Guitar({this.fretCount = FretCount._24});
}
