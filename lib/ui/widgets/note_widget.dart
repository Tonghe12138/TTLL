import 'package:flutter/material.dart';
import 'package:guitar_chord_helper/core/model/fret_board_note.dart';
import 'package:guitar_chord_helper/ui/utils/ui_utils.dart';

typedef TouchFretBoardNote = void Function();

class NoteWidget extends StatefulWidget {
  final TouchFretBoardNote touchNote;
  final FretboardNote? note;
  const NoteWidget({
    super.key,
    required this.touchNote,
    this.note,
  });

  @override
  State<NoteWidget> createState() => _NoteWidgetState();
}

class _NoteWidgetState extends State<NoteWidget> {
  bool get showNote => widget.note != null;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.touchNote,
      child: Container(
        width: GuitarUI.fretStep,
        height: GuitarUI.noteTouchSize,
        color: Colors.transparent,
        alignment: Alignment.center,
        child: showNote ? _buildNote() : null,
      ),
    );
  }

  Widget _buildNote() {
    final haveNote = widget.note != null;
    if(haveNote && widget.note!.state == .muted){
      return _buildMutedNote();
    }
    final isOpenNote = haveNote && widget.note!.state == .open;
    int? finger = widget.note?.finger;
    return Container(
      width: GuitarUI.noteSize,
      height: GuitarUI.noteSize,
      decoration: BoxDecoration(shape: BoxShape.circle, color: isOpenNote ? Colors.amber :Colors.blue),
      alignment: Alignment.center,
      child: Text(
        isOpenNote ? '0' : (finger == null ? '?' : finger.toString()),
        style: TextStyle(color: Colors.white, fontSize: 15),
      ),
    );
  }

  Widget _buildMutedNote() {
    return Icon(Icons.close, color: Colors.red, size: GuitarUI.noteSize);
  }
}
