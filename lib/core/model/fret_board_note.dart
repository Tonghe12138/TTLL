enum StringState {
  ///空弦
  open,

  ///不弹奏
  muted,

  ///有指法
  pressed,
}

class NotePosition {
  ///弦号,1-6,1是最高弦,6是最粗的低音弦
  final int strings;
  final int fret;
  NotePosition(this.strings, this.fret) {
    assert(strings >= 1 && strings <= 6);
    assert(fret >= 0 && fret <= 30);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is NotePosition) {
      return strings == other.strings && fret == other.fret;
    }
    return false;
  }

  @override
  int get hashCode => strings.hashCode ^ fret.hashCode;

  @override
  String toString() {
    return 'NotePosition(strings: $strings, fret: $fret)';
  }
}

class GuitarChordPosition {
  /// 六根弦的演奏状态
  final List<GuitarString> strings;

  final Map<NotePosition, FretboardNote?> noteMap;

  const GuitarChordPosition({required this.strings, required this.noteMap});

  factory GuitarChordPosition.empty() => GuitarChordPosition(
    strings: List.generate(
      6,
      (index) => GuitarString(string: index + 1, state: StringState.open),
    ),
    noteMap: {},
  );
}

/// 吉他单根弦
class GuitarString {
  /// 弦号：1-6
  /// 1 是最高音弦，6 是最低音弦
  final int string;

  /// 当前弦的演奏状态
  final StringState state;

  const GuitarString({required this.string, required this.state})
    : assert(string >= 1 && string <= 6);

  @override
  String toString() {
    return 'GuitarString(string: $string, state: $state)';
  }
}

///指板上具体的音符
class FretboardNote {
  final int string;

  ///弦状态
  final StringState state;

  ///品位,0表示空弦,1代表实际品位
  final int fret;

  ///0是空弦,食指1,中指2,无名指3,小指4
  ///null表示还未指定
  final int? finger;

  FretboardNote({
    this.finger,
    required this.string,
    required this.fret,
    this.state = StringState.pressed,
  }) {
    assert(string >= 1 && string <= 6);
    assert(fret >= 0 && fret <= 30);

    assert(state != StringState.open || fret == 0, '空弦的 fret 必须为 0');

    assert(state != StringState.pressed || fret > 0, '按弦的 fret 必须大于 0');
  }

  @override
  String toString() {
    return 'FretboardNote(string: $string, fret: $fret, state: $state, finger: $finger)';
  }
}
