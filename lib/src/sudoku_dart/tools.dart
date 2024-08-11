import 'dart:math';

class Matrix {
  static int getRow(int index) => index ~/ 9;

  static int getCol(int index) => index % 9;

  static int getZone({int? index, int? row, int? col}) {
    if (index == null) {
      if (col == null || row == null) {
        throw StateError("index or (col and row) can't be null");
      }
    } else {
      row = getRow(index);
      col = getCol(index);
    }

    int x = col ~/ 3;
    int y = row ~/ 3;
    return y * 3 + x;
  }

  static int getIndex(int row, int col) => col * 9 + row;

  static List<int> getZoneIndexes({int zone = 0}) {
    List<int> indexes = [];

    // cols
    [0, 1, 2].forEach((col) {
      // rows
      [0, 1, 2].forEach((row) {
        indexes.add(((col + zone ~/ 3 * 3) * 9) + (row + (zone % 3) * 3));
      });
    });

    return indexes;
  }

  static List<int> getColIndexes(int col) =>
      List.generate(9, (index) => index * 9 + col);

  static List<int> getRowIndexes(int row) =>
      List.generate(9, (index) => row * 9 + index);

  static int getIndexByZone(int zone, int indexOfZone) {
    int x = zone ~/ 3 * 3 + indexOfZone ~/ 3;
    int y = zone % 3 * 3 + indexOfZone % 3;
    return x * 9 + y;
  }
}

List shuffle(List list) {
  var random = Random();
  int n, temp;
  for (var i = list.length - 1; i > 0; i--) {
    // Pick a pseudorandom number according to the list length
    n = random.nextInt(i + 1);

    temp = list[i];
    list[i] = list[n];
    list[n] = temp;
  }
  return list;
}

void formatPrint(List<int> arr) {
  int element;
  String out = "";
  for (int index = 0; index < arr.length; ++index) {
    element = arr[index];
    if (index % 9 == 0) {
      out += "\n";
      if ((index ~/ 9) % 3 == 0 && index != 0) {
        out += "\n";
      }
    }
    out +=
        '${element == -1 ? "." : element} ${(index + 1) % 3 == 0 ? "\t" : ""}';
  }
  print(out);
}
