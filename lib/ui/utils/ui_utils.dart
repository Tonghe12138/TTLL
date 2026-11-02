import 'package:flutter/material.dart';

abstract class UiUtils {}

abstract class GuitarUI{
  static const double fretStep = 60;
}

extension BuildContextEx on BuildContext {
  double get width => MediaQuery.sizeOf(this).width;
  double get height => MediaQuery.sizeOf(this).height;
  double get guitarHeigt => height * 0.4;
}
