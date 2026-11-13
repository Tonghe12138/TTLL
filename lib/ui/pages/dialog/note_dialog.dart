import 'package:flutter/material.dart';
import 'package:guitar_chord_helper/core/model/fret_board_note.dart';

class NoteDialog extends StatefulWidget {
  final FretboardNote note;
  const new({super.key, required this.note});

  @override
  State<NoteDialog> createState() => _NoteDialogState();
}

class _NoteDialogState extends State<NoteDialog> {
  int? _finger;
  StringState _state = .pressed;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((a) {
      setState(() {
        _finger = widget.note.finger;
        _state = widget.note.state;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AlertDialog(
        content: Column(
          mainAxisSize: .min,
          children: [
            _buildSelectGroup<int?>(
              '按弦的指头',
              _finger,
              [1, 2, 3, 4],
              ['食指', '中指', '无名指', '小指'],
              (f) => setState(() {
                if (_state != .pressed) {
                  _finger = 0;
                  return;
                }
                _finger = f;
              }),
            ),
            _buildSelectGroup<StringState?>(
              '按压状态',
              _state,
              StringState.values,
              ['空弦', '不弹奏/静音', '有指法'],
              (v) => setState(() {
                _state = v ?? StringState.pressed;
              }),
            ),

            // SegmentedButton<int>(
            //   segments: [
            //     ButtonSegment(label: Text('食指'), value: 1),
            //     ButtonSegment(label: Text('中指'), value: 2),
            //     ButtonSegment(label: Text('无名指'), value: 3),
            //     ButtonSegment(label: Text('小指'), value: 4),
            //   ],
            //   selected: {_finger ?? 0},
            //   onSelectionChanged: (f) => setState(() {
            //     _finger = f.first;
            //   }),
            // ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop((null, true)),
            child: Text('删除'),
          ),
          TextButton(onPressed: _confirm, child: Text('确定')),
          TextButton(
            onPressed: () => Navigator.of(context).pop((null, false)),
            child: Text('取消'),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectGroup<T>(
    String title,
    T groupValue,
    List<T> valueList,
    List<String> titleList,
    Function(T?) onChanged,
  ) {
    return Column(
      children: [
        Text(title),
        RadioGroup<T>(
          groupValue: groupValue,
          onChanged: onChanged,
          child: Column(
            children: List.generate(
              valueList.length,
              (i) =>
                  RadioListTile(value: valueList[i], title: Text(titleList[i])),
            ),
          ),
        ),
      ],
    );
  }

  void _confirm() {
    int fret = widget.note.fret;
    if (_state == .muted) {
      _finger = 0;
    } else if (_state == .open) {
      _finger = null;
      fret = 0;
    }
    final newNote = FretboardNote(
      string: widget.note.string,
      fret: fret,
      finger: _finger,
      state: _state,
    );
    Navigator.of(context).pop((newNote, false));
  }
}
