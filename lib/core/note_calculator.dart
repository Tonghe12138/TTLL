import 'package:guitar_chord_helper/core/model/fret_board_note.dart';
import 'package:guitar_chord_helper/core/music/guitar_note.dart';
import 'package:guitar_chord_helper/core/music/guitar_tunning.dart';
class NoteCalculator {
  final GuitarTuning tuning;

  const NoteCalculator({
    required this.tuning,
  });

  GuitarNote? calculate(FretboardNote position) {
    // 闷音不产生实际音符
    if (position.state == StringState.muted) {
      return null;
    }

    final openMidi = tuning.openStringMidi[position.string];

    if (openMidi == null) {
      throw ArgumentError('无效的弦号：${position.string}');
    }

    // 空弦使用空弦音高，按弦使用空弦音高 + 品位
    final midi = switch (position.state) {
      StringState.open => openMidi,
      StringState.pressed => openMidi + position.fret,
      StringState.muted => null,
    };

    if (midi == null) return null;

    return GuitarNote.fromMidi(midi);
  }
}