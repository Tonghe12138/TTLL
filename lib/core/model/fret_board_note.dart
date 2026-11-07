enum StringState{
  ///空弦
  open,
  ///不弹奏
  muted,
  ///有指法
  pressed,
}
///指板上具体的音符
class FretboardNote {
  ///弦号,1-6,1是最高弦,6是最粗的低音弦
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
  this.state = StringState.pressed
}) {
  assert(string >= 1 && string <= 6);
  assert(fret >= 0 && fret <= 30);

  assert(
    state != StringState.open || fret == 0,
    '空弦的 fret 必须为 0',
  );

  assert(
    state != StringState.pressed || fret > 0,
    '按弦的 fret 必须大于 0',
  );
}
}