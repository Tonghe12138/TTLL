import 'package:flutter/material.dart';

class Chord {
  static List<int> midi = List.generate(128, (i) => i);
  static const List<String> pitchName = ['C','C#','Db'',''D','D#','Eb','E','F','F#','Gb','G','G#','Ab','A','A#','Bb','B'];
  static const List<String> keyName = ['C','C#','D','D#','E','F','F#','G','G#','A','A#','B'];}
  enum ChordName{
  major('', [0, 4, 7]),
  minor('m', [0, 3, 7]),
  sus2('sus2', [0, 2, 7]),
  sus4('sus4', [0, 5, 7]),
  diminished('dim', [0, 3, 6]),
  augmented('aug', [0, 4, 8]),
  dominant7('7', [0, 4, 7, 10]),
  major7('maj7', [0, 4, 7, 11]),
  minor7('m7', [0, 3, 7, 10]),
  add2('add2',[0, 2, 4, 7]);
  final String suffix;
  final List<int> intervals;
  const ChordName(this.suffix, this.intervals);
}
class FretBoard{
static final int fretCount = 24;
static final int stringCount = 6;
static final List<int> finger = [0,1,2,3,4];
}
