
//import 'dart:nativewrappers/_internal/vm/lib/core_patch.dart';

import 'package:flutter/material.dart';

class Paper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: CustomPaint( // 使用CustomPaint
        painter: PaperPainter(),
      ),
    );
  }
}

class PaperPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 创建画笔
    final Paint paint = Paint();
    paint.color = Colors.black;
    paint.strokeWidth = 2.0;
    paint.style = PaintingStyle.stroke;

    double startX = 150;
    double startY = 40;
    double columnWidth = 60;
    double lineSpacing = 90;
    int string = 6;
    int fret = 6;

    for (int i = 0;i < fret;i++){
      var y = startY + i * columnWidth;
      canvas.drawLine(Offset(startX, y), Offset( startX + lineSpacing * (string-1),y), paint);
    }
    for (int i = 0;i < string;i++){
      var x = startX + i * lineSpacing;
      canvas.drawLine(Offset(x, startY), Offset(x, startY + columnWidth * (fret-1)), paint);
    }
    final topPaint = Paint();
    topPaint.color = Colors.black;
    topPaint.strokeWidth = 6.0;
    topPaint.style = PaintingStyle.stroke;
    canvas.drawLine(Offset(startX, startY),Offset(startX, startY + columnWidth * (string-1)),topPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
