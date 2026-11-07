import 'package:guitar_chord_library/guitar_chord_library.dart';
import 'package:guitar_chord_library/src/dataset/guitar_dataset.dart';

import 'model/fret_board_note.dart';

abstract class ChordHelper {
  static const String chordRegex = r'([A-G][#b]?)?([0-9])?([a-zA-Z0-9])?';

  static List<Chord> getLibraryChordsByGuitar2Position(List<FretboardNote> positions) {
    if (positions.isEmpty) return [];

    final result = <Chord>[];
    final matchedNames = <String>{};

    // 将用户选择的音符转换成 Map：
    // key = 弦号，value = 实际品位
    final selectedNotes = <int, int>{};

    for (final note in positions) {
      // 同一根弦不能同时存在两个不同品位
      if (selectedNotes.containsKey(note.string) &&
          selectedNotes[note.string] != note.fret) {
        return [];
      }

      selectedNotes[note.string] = note.fret;
    }

    // 遍历所有根音
    for (final chords in guitarDataSet.values) {
      for (final chord in chords) {
        if (matchedNames.contains(chord.name)) continue;

        // 遍历当前和弦的所有指法
        for (final chordPosition in chord.chordPositions) {
          final frets = chordPosition.frets
              .trim()
              .split(RegExp(r'\s+'))
              .map(int.parse)
              .toList();

          if (frets.length != 6) continue;

          bool isMatch = true;

          // 检查用户选择的所有音符
          for (final note in positions) {
            // string 1 对应数组索引 5
            // string 6 对应数组索引 0
            final index = 6 - note.string;

            final relativeFret = frets[index];

            // -1 代表这根弦不弹奏
            if (relativeFret == -1) {
              isMatch = false;
              break;
            }

            // 转换成实际品位
            final actualFret = relativeFret == 0
                ? 0
                : chordPosition.baseFret + relativeFret - 1;

            if (actualFret != note.fret) {
              isMatch = false;
              break;
            }
          }

          if (isMatch) {
            result.add(chord);
            matchedNames.add(chord.name);
            break;
          }
        }
      }
    }

    return result;
  }
}
