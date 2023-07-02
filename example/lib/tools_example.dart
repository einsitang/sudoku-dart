import 'dart:math';

import 'package:sudoku_dart/src/sudoku_dart/tools.dart';
import 'package:test/test.dart';

void main() {
  test("test Matrix.getIndexByZone", () {
    Random rand = Random();
    List fixedPositions =
        List.generate(9, (zone) => Matrix.getIndexByZone(zone, rand.nextInt(9)))
            .cast<int>();

    for (int zone = 0; zone < fixedPositions.length; ++zone) {
      print("zone : $zone , position : ${fixedPositions[zone]}");
      int expectZone = Matrix.getZone(index: fixedPositions[zone]);
      expect(expectZone, zone);
    }
    fixedPositions.sort();
    print("fixedPositions sort list:");
    fixedPositions.forEach((element) {
      print("element : $element");
    });
    List<int> candidateIndexes = [];
    for (int i = 0; i < 81; ++i) {
      if (fixedPositions.isNotEmpty && fixedPositions.first == i) {
        fixedPositions.removeAt(0);
        continue;
      }
      candidateIndexes.add(i);
    }
    print("fixedPositions.length : ${fixedPositions.length}");
    expect(candidateIndexes.length, 81 - 9);
  });
}
