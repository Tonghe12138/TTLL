import 'package:flutter/material.dart';
import 'package:guitar_chord_helper/core/note_calculator.dart';
import 'package:guitar_chord_helper/ui/model/guitar.dart';
import 'package:guitar_chord_helper/ui/pages/dialog/note_dialog.dart';
import 'package:guitar_chord_helper/ui/utils/note_utils.dart';
import 'package:guitar_chord_helper/ui/utils/ui_utils.dart';

import '../../core/model/fret_board_note.dart';
import '../widgets/guitar_fretborad_widget.dart';
import '../widgets/note_widget.dart';

class FretboardView extends StatefulWidget {
  const new({super.key});

  @override
  State<FretboardView> createState() => _FretboardViewState();
}

class _FretboardViewState extends State<FretboardView> {
  static const double trackWidth = 300.0;
  double _scrollPosition = 0;
  double _thumbWidth = 50;
  final _scrollController = ScrollController();
  final _guitar = Guitar();

  late final NoteCalculator _calculator;
  final _guitarChordPosition = GuitarChordPosition.empty();

  @override
  void initState() {
    super.initState();
    _calculator = NoteCalculator(tuning: _guitar.tuning);
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) return;
      final viewportWidth = _scrollController.position.viewportDimension;

      final contentWidth =
          _scrollController.position.maxScrollExtent + viewportWidth;

      _thumbWidth = (trackWidth * viewportWidth / contentWidth).clamp(
        0.0,
        trackWidth,
      );
      setState(() {});
    });

    // 监听 note 变化
    _guitarChordPosition.onNoteChanged = (note) {
      _checkStringsNotes(note); // 自动触发
      if (mounted) setState(() {});
    };
    _guitarChordPosition.onNoteRemoved = (note) {
      print('remove note: $note');
      _checkStringsNotes(note); // 自动触发
      // 删除时如果需要也处理弦状态，可以在这里做
      if (mounted) setState(() {});
    };
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final guitarHeight = context.guitarHeigt;
    final guitarWidth = _guitar.fretCount.count * GuitarUI.fretStep;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Column(
              children: [
                Text('吉他面板'),
                Row(
                  children: [
                    IconButton(
                      onPressed: _removeAllNotes,
                      icon: Icon(Icons.delete),
                    ),
                  ],
                ),
                _buildGuitarArea(guitarWidth, guitarHeight),
                Text('data'),
                SizedBox(height: 20),
                SizedBox(
                  width: trackWidth,
                  height: 50,
                  child: Stack(
                    children: [
                      Center(
                        child: Container(
                          width: trackWidth,
                          height: 40,
                          color: Colors.black,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: _scrollPosition,
                        child: GestureDetector(
                          onPanUpdate: (d) => _onUpdateScaleGuitar(d),
                          child: Container(
                            width: _thumbWidth,
                            height: 50,
                            color: Colors.blue.withAlpha(100),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                _buildChordArea(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container _buildGuitarArea(double guitarWidth, double guitarHeight) {
    final stringsStep = guitarHeight / (Guitar.stringsCount + 1);
    // print('guitarHeigt: $guitarHeight, stringsStep: $stringsStep');
    return Container(
      color: Colors.black.withAlpha(200),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 40,
            height: guitarHeight,
            child: Stack(
              clipBehavior: Clip.none,
              children: List.generate(Guitar.stringsCount, (index) {
                final y = (index + 1) * stringsStep;
                final halfHeight = GuitarUI.fretTextHeight / 2;
                final strings = Guitar.stringsCount - index;
                return Positioned(
                  top: y + halfHeight,
                  left: 0,
                  right: 0,
                  height: GuitarUI.fretTextHeight,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: .center,
                      children: [
                        Text(
                          '$strings弦',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                        _buildStringsState(strings),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          Expanded(
            child: _buildGuitarFret(guitarWidth, guitarHeight, stringsStep),
          ),
        ],
      ),
    );
  }

  Widget _buildStringsState(int strings) {
    final state = _getStringState(strings);
    if (state == .muted) {
      return Icon(Icons.close, size: 12, color: Colors.red);
    } else if (state == .open) {
      return Icon(Icons.circle_outlined, size: 12, color: Colors.amber);
    }
    return SizedBox(width: 12);
  }

  Widget _buildGuitarFret(
    double guitarWidth,
    double guitarHeight,
    double stringsStep,
  ) {
    final double fretHeight = 20;
    final totalHeigt = fretHeight + guitarHeight;
    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: _guitar.fretCount.count * GuitarUI.fretStep,
        height: totalHeigt,
        child: Stack(
          children: [
            //guitar fretboard
            Positioned(
              top: fretHeight,
              child: CustomPaint(
                size: Size(guitarWidth, guitarHeight),
                painter: GuitarFretboradPainter(
                  _guitar,
                  stringsStep: stringsStep,
                ),
              ),
            ),
            //fret text
            ...List.generate(
              _guitar.fretCount.count,
              (i) => Positioned(
                top: 0,
                left: i * GuitarUI.fretStep,
                child: SizedBox(
                  width: GuitarUI.fretStep,
                  height: fretHeight,
                  child: Center(
                    child: Text(
                      '${i + 1}品',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ),
            ),
            //note area
            Positioned(
              top: 0,
              left: 0,
              width: guitarWidth,
              height: guitarHeight,
              child: GridView.builder(
                itemCount: _guitar.fretCount.count * Guitar.stringsCount,
                shrinkWrap: false,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.only(
                  top:
                      GuitarUI.fretTextHeight +
                      stringsStep -
                      GuitarUI.noteTouchSize / 2,
                  left: 0,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _guitar.fretCount.count,
                  mainAxisSpacing: stringsStep - GuitarUI.noteTouchSize,
                  crossAxisSpacing: 0,
                  childAspectRatio: GuitarUI.fretStep / GuitarUI.noteTouchSize,
                ),
                itemBuilder: _buildAllNoteArea,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget? _buildAllNoteArea(BuildContext context, int index) {
    final strings = 6 - index ~/ _guitar.fretCount.count;
    final fret = index % _guitar.fretCount.count + 1;
    final notePosition = NotePosition(strings, fret);
    // final note = _fretBoardNotes[notePosition];
    final note = _guitarChordPosition.noteMap[notePosition];
    return NoteWidget(
      note: note,
      touchNote: () => _onTouchNote(note, notePosition),
      onMouseRight: () => _guitarChordPosition.removeNote(notePosition),
    );
  }

  Widget _buildChordArea() {
    print('guitar count: ${_guitarChordPosition.noteMap.values.length}');
    final allNotes = _guitarChordPosition.noteMap.values;
    final notesString = allNotes
        .map((e) => "${e?.string}弦 ${e?.fret}品")
        .toList();
    final guitarNotes = allNotes.map((e) => _calculator.calculate(e)).toList();
    return Column(
      children: [
        Text('按下的音符:'),
        Row(
          mainAxisAlignment: .center,
          children: [
            SizedBox(
              width: 70,
              height: 70,
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(
                    notesString.length,
                    (i) => Text(notesString[i]),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 70,
              height: 70,
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(
                    guitarNotes.length,
                    (i) => Text(guitarNotes[i]?.toString() ?? ''),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;
    final maxScrollExtent = position.maxScrollExtent;
    final maxThumbOffset = trackWidth - _thumbWidth;

    if (maxScrollExtent <= 0 || maxThumbOffset <= 0) {
      return;
    }
    // 当前指板滚动进度，范围 0 ~ 1
    final progress = position.pixels / maxScrollExtent;
    // 将指板滚动进度映射到缩略图滑块位置
    final newPosition = progress * maxThumbOffset;

    setState(() {
      _scrollPosition = newPosition;
    });
  }

  void _onUpdateScaleGuitar(DragUpdateDetails details) {
    if (!_scrollController.hasClients) return;

    final maxThumbOffset = trackWidth - _thumbWidth;
    if (maxThumbOffset <= 0) return;

    // 更新滑块位置
    _scrollPosition = (_scrollPosition + details.delta.dx).clamp(
      0.0,
      maxThumbOffset,
    );
    // 转换成 0 ~ 1 的滚动进度
    final progress = _scrollPosition / maxThumbOffset;
    // 获取指板最大滚动距离
    final maxScrollExtent = _scrollController.position.maxScrollExtent;
    // 映射到指板滚动距离
    final scrollOffset = progress * maxScrollExtent;

    // jumpTo 会触发 _onScroll，由监听器同步 UI
    _scrollController.jumpTo(scrollOffset);
  }

  ///检查弦上所有的音符是否符合状态
  void _checkStringsNotes(FretboardNote? note) {
    print('check strings notes: $note');
    if (note == null) {
      return;
    }
    StringState curState = note.state;
    if (curState != .pressed) {
      //删除所有弦上的note
      final notesFretList = NoteUtils.getNotesByStrings(
        note.string,
        _guitarChordPosition.noteMap,
      ).map((e) => e?.fret).toList();
      print('notesFretList: $notesFretList');
      if (notesFretList.isNotEmpty) {
        for (var fret in notesFretList) {
          if (fret == null) {
            continue;
          }
          _guitarChordPosition.removeNote(
            NotePosition(note.string, fret),
            notify: false,
          );
        }
      }
    }else{
      //判断这个弦上的所有音符是否都被移除
      final notesFretList = NoteUtils.getNotesByStrings(
        note.string,
        _guitarChordPosition.noteMap,
      ).map((e) => e?.fret).toList();
      print('notesFretList: $notesFretList');
      if (notesFretList.isEmpty) {
        curState = .open;
      }
    }

    //更新弦状态
    _updateStringState(note.string, curState);
  }

  void _onTouchNote(FretboardNote? note, NotePosition notePosition) async {
    print('string: ${notePosition.strings}, fret: ${notePosition.fret}');
    if (note == null) {
      //添加音符
      _addNote(notePosition);

      if (mounted) {
        setState(() {});
      }
    } else {
      //修改音符
      (FretboardNote?, bool) result = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (c) =>
            NoteDialog(note: _guitarChordPosition.noteMap[notePosition]!),
      );

      if (mounted && result.$1 != null) {
        //修改音符
        final updateNote = result.$1!;
        _updateNote(notePosition, updateNote);
        if (updateNote.state != .pressed) {
          _guitarChordPosition.removeNote(notePosition);
        }
        setState(() {});
      } else if (result.$2) {
        //移除音符
        _guitarChordPosition.removeNote(notePosition);
        setState(() {});
      }
    }
  }

  void _addNote(NotePosition notePosition) {
    final note = FretboardNote(
      string: notePosition.strings,
      fret: notePosition.fret,
    );
    _guitarChordPosition.addNote(notePosition, note);
  }

  void _updateNote(NotePosition notePosition, FretboardNote updateNote) {
    _guitarChordPosition.updateNote(notePosition, updateNote);
    print('updateNote: $updateNote');
  }

  void _updateStringState(int string, StringState state) {
    final index = _guitarChordPosition.strings.indexWhere(
      (e) => e.string == string,
    );

    if (index == -1) {
      _guitarChordPosition.strings.add(
        GuitarString(string: string, state: state),
      );
    } else {
      _guitarChordPosition.strings[index] = GuitarString(
        string: string,
        state: state,
      );
    }
    print('updateStringState: $string, $state');
  }

  StringState _getStringState(int string) {
    final index = _guitarChordPosition.strings.indexWhere(
      (e) => e.string == string,
    );
    if (index == -1) {
      return .pressed;
    }
    return _guitarChordPosition.strings[index].state;
  }

  void _removeAllNotes() {
    _guitarChordPosition.removeAllNotes();
    setState(() {});
  }
}
