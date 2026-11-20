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

/// 吉他和弦指位：六根弦各一个槽位，一弦一音
class GuitarChordPosition {
  /// 弦数
  static const int stringCount = 6;

  /// 六根弦的槽位，索引 = 6 - 弦号
  /// 即索引 0 是 6 弦（最粗的低音弦），索引 5 是 1 弦（最高弦）
  final List<FretboardNote> strings;

  /// 槽位变化时回调
  void Function()? onChanged;

  GuitarChordPosition({required this.strings})
    : assert(strings.length == stringCount, '必须包含 $stringCount 个槽位');

  factory GuitarChordPosition.empty() => GuitarChordPosition(
    strings: [
      for (var string = stringCount; string >= 1; string--)
        FretboardNote(string: string, fret: 0, state: StringState.open),
    ],
  );

  /// 按弦号取槽位
  FretboardNote noteOf(int string) => strings[stringCount - string];

  /// 实际发声的槽位（闷音不发声），顺序为 6 弦 → 1 弦
  List<FretboardNote> get soundedNotes =>
      strings.where((note) => note.state != StringState.muted).toList();

  /// 设置某根弦的槽位，同一根弦上原有的音会被覆盖
  void setNote(
    int string, {
    required StringState state,
    int fret = 0,
    int? finger,
  }) {
    strings[stringCount - string] = FretboardNote(
      string: string,
      fret: fret,
      state: state,
      finger: finger,
    );
    onChanged?.call();
  }

  /// 取消按弦，回到空弦
  void clearString(int string) {
    setNote(string, state: StringState.open);
  }

  /// 重置所有弦为空弦
  void clearAll() {
    for (var string = 1; string <= stringCount; string++) {
      strings[stringCount - string] = FretboardNote(
        string: string,
        fret: 0,
        state: StringState.open,
      );
    }
    onChanged?.call();
  }
}

///指板上具体的音符（同时作为一根弦的槽位）
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
