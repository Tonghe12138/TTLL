import 'package:flutter/material.dart';
import 'package:guitar_chord_helper/core/music/chord_analyzer.dart';
import 'package:guitar_chord_helper/core/note_calculator.dart';
import 'package:guitar_chord_helper/ui/model/guitar.dart';
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
  late final ChordAnalyzer _analyzer;
  final _guitarChordPosition = GuitarChordPosition.empty();

  @override
  void initState() {
    super.initState();
    _calculator = NoteCalculator(tuning: _guitar.tuning);
    _analyzer = ChordAnalyzer();
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

    // 槽位变化时刷新 UI
    _guitarChordPosition.onChanged = () {
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
    final state = _guitarChordPosition.noteOf(strings).state;
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
    final strings = Guitar.stringsCount - index ~/ _guitar.fretCount.count;
    final fret = index % _guitar.fretCount.count + 1;
    final notePosition = NotePosition(strings, fret);
    // 该弦只在格子品位与槽位品位一致时显示音符
    final slot = _guitarChordPosition.noteOf(strings);
    final note = slot.state == StringState.pressed && slot.fret == fret
        ? slot
        : null;
    return NoteWidget(
      note: note,
      touchNote: () => _onTouchNote(note, notePosition),
      onMouseRight: () {
        if (note != null) {
          _guitarChordPosition.clearString(strings);
        }
      },
    );
  }

  Widget _buildChordArea() {
    final noteList = _guitarChordPosition.soundedNotes;
    final guitarNotes = noteList.map((e) => _calculator.calculate(e)).toList();
    final pitchClassList = guitarNotes
        .map((e) => (e?.pitchClass.value ?? 0))
        .toList();
    final choldList = _analyzer.analyze(pitchClassList);
    final notesString = List.generate(
      noteList.length,
      (i) =>
          '${noteList[i].string}弦 ${noteList[i].state == StringState.open ? '空弦' : '${noteList[i].fret}品'}',
    );
    return Column(
      children: [
        Text('发声的音符:'),
        Row(
          mainAxisAlignment: .center,
          children: [
            SizedBox(
              height: 70,
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(
                    notesString.length,
                    (i) => Row(
                      children: [
                        Text(notesString[i]),
                        SizedBox(width: 10),
                        Text(guitarNotes[i]?.toString() ?? ''),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Text('出现的音高:'),
        Text('[${pitchClassList.join(',')}]'),
        Text('可能的和弦:'),
        Text('[${choldList.map((e) => e.name).join(',')}]'),
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

  void _onTouchNote(FretboardNote? note, NotePosition notePosition) {
    if (note == null) {
      // 按弦：一弦一音，直接覆盖该弦槽位
      _guitarChordPosition.setNote(
        notePosition.strings,
        state: StringState.pressed,
        fret: notePosition.fret,
      );
    } else {
      // 取消按弦
      _guitarChordPosition.clearString(notePosition.strings);
    }
  }

  void _removeAllNotes() {
    _guitarChordPosition.clearAll();
  }
}
