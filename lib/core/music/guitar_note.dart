/// 音符的音高类别，十二平均律
enum PitchClass {
  c(0, 'C'),
  cSharp(1, 'C#'),
  d(2, 'D'),
  dSharp(3, 'D#'),
  e(4, 'E'),
  f(5, 'F'),
  fSharp(6, 'F#'),
  g(7, 'G'),
  gSharp(8, 'G#'),
  a(9, 'A'),
  aSharp(10, 'A#'),
  b(11, 'B');

  final int value;
  final String name;

  const PitchClass(this.value, this.name);
}

/// 实际发出的音符
class GuitarNote {
  /// 音高类别：C、C#、D...
  final PitchClass pitchClass;

  /// 八度，例如 C3、A2
  final int octave;

  /// MIDI 音高编号，用于比较实际音高
  final int midiNumber;

  const GuitarNote({
    required this.pitchClass,
    required this.octave,
    required this.midiNumber,
  });

  factory GuitarNote.fromMidi(int midi) {
    final pitchClass = PitchClass.values[midi % 12];
    final octave = (midi ~/ 12) - 1;

    return GuitarNote(
      pitchClass: pitchClass,
      octave: octave,
      midiNumber: midi,
    );
  }

  String get name => '${pitchClass.name}$octave';
}