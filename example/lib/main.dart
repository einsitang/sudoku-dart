import 'package:sudoku_dart/sudoku_dart.dart';

void main(){

  // resolve sudoku puzzle
  List<int> puzzle = [
    -1,-1,8,    9,-1,6,     -1,-1,5,
    -1,4,3,     -1,-1,-1,   -1,2,-1,
    -1,-1,-1,   -1,-1,-1,   -1,-1,-1,

    -1,-1,4,    -1,-1,-1,   9,-1,-1,
    5,-1,-1,    -1,4,-1,    6,8,-1,
    -1,-1,-1,   1,-1,-1,    -1,-1,-1,

    2,-1,-1,    -1,8,-1,    -1,7,-1,
    -1,-1,-1,   -1,3,4,     1,-1,-1,
    -1,6,-1,    -1,-1,9,    -1,-1,-1,
  ];

  Sudoku sudoku_dart = Sudoku(puzzle);
  sudoku_dart.debug();

  // sudo generator with expert level
  Sudoku newSudoku = Sudoku.generator(LEVEL.EXPERT);
  newSudoku.debug();

}