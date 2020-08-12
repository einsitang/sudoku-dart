import 'package:sudoku_dart/src/sudoku/generator.dart';
import 'package:sudoku_dart/src/sudoku/tools.dart';
import 'package:sudoku_dart/sudoku.dart' ;

void main(){
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

//  Sudoku sudoku = new Sudoku(puzzle: puzzle);
//  sudoku.debug();

  puzzle = Sudoku.generator(LEVEL.EXPERT);
  formatPrint(puzzle);

}