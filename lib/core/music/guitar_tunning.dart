/// 吉他调弦配置
class GuitarTuning {
  /// 每根弦的空弦 MIDI 音高
  /// Key 是弦号，Value 是 MIDI 编号
  final Map<int, int> openStringMidi;

  const GuitarTuning({
    required this.openStringMidi,
  });

  /// 标准调弦
  static const standard = GuitarTuning(
    openStringMidi: {
      6: 40, // E2
      5: 45, // A2
      4: 50, // D3
      3: 55, // G3
      2: 59, // B3
      1: 64, // E4
    },
  );
}