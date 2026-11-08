import 'chord_formula.dart';
import 'chord_result.dart';

/// 调弦分析器
/// 用于分析调弦公式，判断是否符合调弦公式
class ChordAnalyzer {
  /// 分析输入的音高编号，返回匹配的和弦，结果可能为空集合
  List<ChordResult> analyze(List<int> pitchClasses) {
    // 1. 去除重复音符，并确保音高编号处于 0~11
    final inputNotes = pitchClasses
        .map((note) => note % 12)
        .toSet();

    // 没有有效音符，直接返回
    if (inputNotes.isEmpty) {
      return [];
    }

    final results = <ChordResult>[];

    // 2. 遍历所有可能的根音
    for (int root = 0; root < 12; root++) {

      // 3. 遍历所有和弦公式
      for (final formula in ChordFormulas.all) {

        // 4. 根据根音和公式，计算理论构成音
        final expectedNotes = formula.intervals
            .map((interval) => (root + interval) % 12)
            .toSet();

        // 5. 比较输入音符和理论构成音是否完全一致
        if (_isSameNotes(inputNotes, expectedNotes)) {
          results.add(
            ChordResult(
              rootPitchClass: root,
              formula: formula,
            ),
          );
        }
      }
    }

    return results;
  }

  /// 判断两个音符集合是否完全相同
  bool _isSameNotes(Set<int> a, Set<int> b) {
    return a.length == b.length && a.containsAll(b);
  }
}