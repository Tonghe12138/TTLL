void main() {
  // final list = [0, 1];
  // list[3];

  List<List<int>> exam = [
    [3, 0, 8],
    [0],
    [1, 9, 9, 9],
    [2, 0, 9],
  ];
  for (int i = 0; i < exam.length; i++) {
    print(add(exam[i]));
  }
}

List<int> add(List<int> digist) {
  for (int i = digist.length -1; i > 0; i--) {
    print(digist[i]);
  }
  return digist;
}
