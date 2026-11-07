import 'package:flutter_test/flutter_test.dart';
import 'package:guitar_chord_helper/core/model/fret_board_note.dart';
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
}
