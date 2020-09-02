import 'tools.dart';
import 'generator.dart' as sudoku_generator;

final List<int> NUMS = List<int>.generate(9, (index) => index + 1);

class Sudoku {
  List<int> _puzzle;
  List<int> _answer;
  int _timeCount;
  List<int> traceBackNums = shuffle(NUMS);

  Sudoku(List<int> puzzle) {
    if (puzzle == null || puzzle.length != 81) {
      throw StateError("请输入正确的数独题");
    }

    this._puzzle = puzzle;

    List<int> answer = puzzle.sublist(0);
    List<List<bool>> rows, cols, zones;
    rows = List<List<bool>>.generate(81, (index) => List<bool>.generate(10, (index) => false));
    cols = List<List<bool>>.generate(81, (index) => List<bool>.generate(10, (index) => false));
    zones = List<List<bool>>.generate(81, (index) => List<bool>.generate(10, (index) => false));

    int row, col, zone;
    this._puzzle.asMap().forEach((int index, int num) {
      row = Matrix.getRow(index);
      col = Matrix.getCol(index);
      zone = Matrix.getZone(index: index);
      if (num != -1) {
        rows[row][num] = true;
        cols[col][num] = true;
        zones[zone][num] = true;
      }
    });

    bool isSuccess = true;
    int timeBegin = DateTime.now().millisecondsSinceEpoch;
    for (int index = 0; index < 81; ++index) {
      if (answer[index] == -1) {
        isSuccess = _calculate(rows, cols, zones, answer, index);
        break;
      }
    }

    if (!isSuccess) {
      throw StateError("数独错误，无法计算");
    }

    this._answer = answer;
    this._timeCount = DateTime.now().millisecondsSinceEpoch - timeBegin;
  }

  bool _calculate(List<List<bool>> rows, List<List<bool>> cols, List<List<bool>> zones, List<int> answer, int index) {
    int row, col, zone;
    row = Matrix.getRow(index);
    col = Matrix.getCol(index);
    zone = Matrix.getZone(row: row, col: col);

    if (index >= 81) {
      return true;
    }
    if (answer[index] != -1) {
      return _calculate(rows, cols, zones, answer, index + 1);
    }

    List<int> nums = this.traceBackNums;
    for (int num in nums) {
      if (!rows[row][num] && !cols[col][num] && !zones[zone][num]) {
        answer[index] = num;
        rows[row][num] = true;
        cols[col][num] = true;
        zones[zone][num] = true;

        if (_calculate(rows, cols, zones, answer, index + 1)) {
          return true;
        } else {
          answer[index] = -1;
          rows[row][num] = false;
          cols[col][num] = false;
          zones[zone][num] = false;
        }
      }
    }

    return false;
  }

  debug() {
    print('--- debug info ---');
    print('puzzle');
    formatPrint(this.puzzle);
    print('answer');
    formatPrint(this.answer);
    print('解题耗时 : ${this._timeCount}\'ms');
    print('--- debug end ---');
  }

  List<int> get puzzle => this._puzzle;

  List<int> get answer => this._answer;

  static Sudoku generator(sudoku_generator.LEVEL level) => sudoku_generator.generator(level: level);
}
