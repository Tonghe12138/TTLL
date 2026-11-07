import '../../core/music/guitar_tunning.dart';

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
  final FretCount fretCount;
  final GuitarTuning tuning;

  Guitar({this.fretCount = FretCount._24, this.tuning = GuitarTuning.standard});
}
