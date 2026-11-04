import 'package:flutter/material.dart';

class FretboardNote {
  final int stringIndex;
  final int fretIndex;
  final String name;
  final Color color;

  const FretboardNote({
    required this.stringIndex,
    required this.fretIndex,
    required this.name,
    this.color = Colors.blue,
  });
}