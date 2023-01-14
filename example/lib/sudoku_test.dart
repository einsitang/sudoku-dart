import 'package:sudoku_dart/sudoku_dart.dart';
import 'package:test/test.dart';

void main() {

  test('test solve puzzle',() {
    // resolve sudoku puzzle
    // List<int> puzzle = [
    //   -1,-1,8,    9,-1,6,     -1,-1,5,
    //   -1,4,3,     -1,-1,-1,   -1,2,-1,
    //   -1,-1,-1,   -1,-1,-1,   -1,-1,-1,
    //
    //   -1,-1,4,    -1,-1,-1,   9,-1,-1,
    //   5,-1,-1,    -1,4,-1,    6,8,-1,
    //   -1,-1,-1,   1,-1,-1,    -1,-1,-1,
    //
    //   2,-1,-1,    -1,8,-1,    -1,7,-1,
    //   -1,-1,-1,   -1,3,4,     1,-1,-1,
    //   -1,6,-1,    -1,-1,9,    -1,-1,-1,
    // ];

    // List<int> puzzle = [
    //   -1, -1, -1, 3, 1, 2, -1, -1, -1, -1, -1, -1, 6, 8, 9, -1, -1, -1, -1, -1, -1, 4, 7, 5, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1
    // ];

    // 唯一解数独
    List<int> puzzle = [
      -1,3,-1,-1,9,-1,-1,-1,7,8,9,-1,-1,-1,-1,-1,1,-1,-1,-1,2,-1,-1,-1,4,-1,-1,-1,4,8,-1,-1,6,-1,-1,-1,-1,-1,-1,-1,-1,8,-1,-1,9,-1,2,-1,-1,7,-1,-1,-1,-1,6,-1,-1,-1,3,9,1,5,-1,-1,-1,-1,2,-1,5,-1,6,-1,-1,5,9,-1,1,-1,-1,8,-1
    ];
    Sudoku sudoku = Sudoku(puzzle, strict: true);
    sudoku.debug();
    expectLater(sudoku.puzzle,puzzle);
    expectLater(sudoku.answer.any((element) => element == -1), false);

  });

  test('test generator',() {
    // sudo generator with expert level
    int beginTime = DateTime.now().millisecondsSinceEpoch;
    Sudoku sudoku = Sudoku.generate(Level.expert);
    int endTime = DateTime.now().millisecondsSinceEpoch;
    sudoku.debug();
    expect(sudoku.answer.any((element) => element == -1), false);
    String str = sudoku.puzzle.join(",");
    print('this is puzzle can be copy to the clipboard : ');
    print(str);
    print('generated total time : ${endTime - beginTime}\'ms');


  });
}
