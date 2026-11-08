/// 调弦公式
class ChordFormula {
  /// 和弦唯一标识
  final String id;

  /// 和弦名称
  final String name;

  /// 和弦后缀
  final String suffix;

  /// 相对于根音的半音偏移
  final List<int> intervals;

  const ChordFormula({
    required this.id,
    required this.name,
    required this.suffix,
    required this.intervals,
  });
}

///常见和弦公式
class ChordFormulas {
  static const List<ChordFormula> all = [
    ChordFormula(
      id: 'major',
      name: '大三和弦',
      suffix: '',
      intervals: [0, 4, 7],
    ),
    ChordFormula(
      id: 'minor',
      name: '小三和弦',
      suffix: 'm',
      intervals: [0, 3, 7],
    ),
    ChordFormula(
      id: 'major7',
      name: '大七和弦',
      suffix: 'maj7',
      intervals: [0, 4, 7, 11],
    ),
    ChordFormula(
      id: 'minor7',
      name: '小七和弦',
      suffix: 'm7',
      intervals: [0, 3, 7, 10],
    ),
    ChordFormula(
      id: 'sus2',
      name: '挂二和弦',
      suffix: 'sus2',
      intervals: [0, 2, 7],
    ),
    ChordFormula(
      id: 'sus4',
      name: '挂四和弦',
      suffix: 'sus4',
      intervals: [0, 5, 7],
    ),
    ChordFormula(
      id: 'dim',
      name: '减三和弦',
      suffix: 'dim',
      intervals: [0, 3, 6],
    ),
    ChordFormula(
      id: 'aug',
      name: '增三和弦',
      suffix: 'aug',
      intervals: [0, 4, 8],
    ),
  ];
}