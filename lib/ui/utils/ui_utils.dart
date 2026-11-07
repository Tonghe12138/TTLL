import 'package:flutter/material.dart';

abstract class UiUtils {}

abstract class GuitarUI{
  ///吉他品格水平之间的距离
  static const double fretStep = 60;
  static const double fretTextHeight = 20;
  static const double noteSize = 25;
  static const double noteTouchSize = 35;
}

extension BuildContextEx on BuildContext {
  double get width => MediaQuery.sizeOf(this).width;
  double get height => MediaQuery.sizeOf(this).height;
  double get guitarHeigt => height * 0.4;
}
