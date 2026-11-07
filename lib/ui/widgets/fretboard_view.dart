import 'package:flutter/material.dart';
import 'package:guitar_chord_helper/ui/model/guitar.dart';
import 'package:guitar_chord_helper/ui/utils/ui_utils.dart';

import 'guitar_fretborad_widget.dart';
import 'note_widget.dart';

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

  @override
  void initState() {
    super.initState();
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
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maxThumbOffset = trackWidth - _thumbWidth; //缩略图最大块偏移量
    final guitarHeight = context.guitarHeigt;
    final guitarWidth = _guitar.fretCount.count * GuitarUI.fretStep;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(left: 40, right: 10),
            child: Column(
              children: [
                Text('asd'),
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
                          onPanUpdate: (d) =>
                              _onUpdateScaleGuitar(d),
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
                return Positioned(
                  top: y + halfHeight,
                  left: 0,
                  right: 0,
                  height: GuitarUI.fretTextHeight,
                  child: Center(
                    child: Text(
                      '${Guitar.stringsCount - index}弦',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
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
            // Positioned(
            //   top:
            //       GuitarUI.fretTextHeight + stringsStep - GuitarUI.noteSize / 2,
            //   left: GuitarUI.fretStep / 2 - GuitarUI.noteSize / 2,
            //   height: GuitarUI.noteSize,
            //   width: GuitarUI.noteSize,
            //   child: NoteWidget(),
            // ),
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

  Widget? _buildAllNoteArea(BuildContext context, int index) {
    return NoteWidget(index: index);
  }
}
