import 'chord_formula.dart';

class ChordResult {
  /// 根音编号，例如 C = 0、D = 2
  final int rootPitchClass;

  /// 匹配到的和弦公式
  final ChordFormula formula;

  const ChordResult({
    required this.rootPitchClass,
    required this.formula,
  });

  /// 和弦名称，例如 C、Dm、Gmaj7
  String get name {
    return '${pitchClassNames[rootPitchClass]}${formula.suffix}';
  }

  @override
  String toString() {
    return 'ChordResult(rootPitchClass: $rootPitchClass, formula: $formula)';
  }
}

/// 十二音体系的音名
const pitchClassNames = [
  'C', 'C#', 'D', 'D#', 'E', 'F',
  'F#', 'G', 'G#', 'A', 'A#', 'B',
];