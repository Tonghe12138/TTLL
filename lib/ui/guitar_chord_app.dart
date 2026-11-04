import 'package:flutter/material.dart';
import 'package:guitar_chord_helper/ui/widgets/fretboard_view.dart';

class GuitarChordApp extends StatefulWidget {
  const new({super.key});

  @override
  State<GuitarChordApp> createState() => _GuitarChordAppState();
}

class _GuitarChordAppState extends State<GuitarChordApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guitar Chord Helper',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FretboardView(),
    );
  }
}