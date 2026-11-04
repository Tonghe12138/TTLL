import 'package:flutter/material.dart';
import 'package:guitar_chord_helper/ui/model/guitar.dart';
import 'package:guitar_chord_helper/ui/utils/ui_utils.dart';

class GuitarFretboradPainter extends CustomPainter {
  final Guitar guitar;
  late Paint _paint; // 画笔
  late Paint _stringsPaint; // 画笔
  final double strokeWidth = .5; // 线宽
  final Color color = Colors.white; // 线颜色
  final double stringsStep;

  GuitarFretboradPainter(this.guitar, {required this.stringsStep}) {
    _paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth;
    _stringsPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeWidth = 3;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // print('size: $size');
    // 绘制弦
    for (int i = 0; i < Guitar.stringsCount; i++) {
      final y = (i + 1) * stringsStep;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), _paint);
    }

    // 最左侧的琴枕
    canvas.drawLine(const Offset(0, 0), Offset(0, size.height), _stringsPaint);

    // 绘制品格线
    // 绘制品格线
    for (int i = 1; i <= guitar.fretCount.count; i++) {
      final x = i * GuitarUI.fretStep;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), _paint);
    }
  }

  @override
  bool shouldRepaint(covariant GuitarFretboradPainter oldDelegate) {
    return guitar != oldDelegate.guitar ||
        stringsStep != oldDelegate.stringsStep;
  }
}
