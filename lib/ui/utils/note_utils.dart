import 'package:guitar_chord_helper/core/model/fret_board_note.dart';

abstract class NoteUtils {
  NoteUtils._();

  ///根据弦获取所有note
  static List<FretboardNote?> getNotesByStrings(
    int strings,
    Map<NotePosition, FretboardNote?> noteMap,
  ) {
    return noteMap.entries
        .where((e) => e.key.strings == strings)
        .map((e) => e.value)
        .toList();
  }
}
