import 'package:flutter_test/flutter_test.dart';
import 'package:guitar_chord_helper/core/model/fret_board_note.dart';
import 'package:guitar_chord_helper/core/music/chord_analyzer.dart';
import 'package:guitar_chord_helper/core/music/chord_formula.dart';
import 'package:guitar_chord_helper/core/note_calculator.dart';
import 'package:guitar_chord_helper/ui/model/guitar.dart';

void main() {
  final guitar = Guitar();
  final calculator = NoteCalculator(tuning: guitar.tuning); //标准调音
  group('吉他指板音符转换为实际音', () {
    List<FretboardNote> notes = [
      FretboardNote(string: 6, fret: 0, state: .open),
      FretboardNote(string: 5, fret: 0, state: .open),
      FretboardNote(string: 5, fret: 3),
      FretboardNote(string: 4, fret: 2),
      FretboardNote(string: 3, fret: 0, state: .open),
      FretboardNote(string: 2, fret: 1),
      FretboardNote(string: 1, fret: 0, state: .open),
      FretboardNote(string: 6, fret: 0, state: .muted),
    ];
    List<String?> expectRes = ['E2', 'A2', 'C3', 'E3', 'G3', 'C4', 'E4', null];
    for (int i = 0; i < notes.length; i++) {
      test('test$i', () {
        final guitarNote = calculator.calculate(notes[i]);
        expect(guitarNote?.name, expectRes[i]);
      });
    }
  });

  group('所有和弦公式应该合法', () {
    test('所有和弦公式都应该合法', () {
      for (final formula in ChordFormulas.all) {
        expect(formula.intervals.first, 0);
        expect(formula.intervals.toSet().length, formula.intervals.length);

        for (final interval in formula.intervals) {
          expect(interval, inInclusiveRange(0, 11));
        }
      }
    });
  });

  group('测试根音和弦识别', () {
    late ChordAnalyzer analyzer;

    setUp(() {
      analyzer = ChordAnalyzer();
    });

    test('C 大三和弦应该识别为 C', () {
      final results = analyzer.analyze([0, 4, 7]);

      expect(results.any((result) => result.name == 'C'), isTrue);
    });

    test('C 小三和弦应该识别为 Cm', () {
      final results = analyzer.analyze([0, 3, 7]);

      expect(results.any((result) => result.name == 'Cm'), isTrue);
    });

    test('Cmaj7 应该正确识别', () {
      final results = analyzer.analyze([0, 4, 7, 11]);

      expect(results.any((result) => result.name == 'Cmaj7'), isTrue);
    });

    test('重复音符不应该影响识别', () {
      final results = analyzer.analyze([0, 4, 7, 0, 7]);

      expect(results.any((result) => result.name == 'C'), isTrue);
    });

    test('不同排列顺序应该识别为相同和弦', () {
      final results = analyzer.analyze([4, 7, 0]);

      expect(results.any((result) => result.name == 'C'), isTrue);
    });

    test('空音符应该返回空结果', () {
      final results = analyzer.analyze([]);

      expect(results, isEmpty);
    });
  });
}
