import 'package:flutter/material.dart';
import 'package:guitar_chord_helper/ui/utils/ui_utils.dart';

class NoteWidget extends StatefulWidget {
  final int index;
  const new({super.key,required this.index});

  @override
  State<NoteWidget> createState() => _NoteWidgetState();
}

class _NoteWidgetState extends State<NoteWidget> {
  bool _showNote = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _touchNoteArea,
      child: Container(
        width: GuitarUI.fretStep,
        height: GuitarUI.noteTouchSize,
        color: Colors.transparent,
        alignment: Alignment.center,
        child: _showNote ? _buildNote() : null,
      ),
    );
  }

  Container _buildNote() {
    return Container(
      width: GuitarUI.noteSize,
      height: GuitarUI.noteSize,
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
      alignment: Alignment.center,
      child: Text('1', style: TextStyle(color: Colors.white, fontSize: 15)),
    );
  }

  void _touchNoteArea() {
    print('touch index: ${widget.index}');
    setState(() {
      _showNote = !_showNote;
    });
  }
}
