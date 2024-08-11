import 'generator.dart' as sudokuGenerator;
import 'tools.dart';

final List<int> _nums = List<int>.generate(9, (index) => index + 1);

class Sudoku {
  late List<int> _puzzle;
  late List<int> _answer;
  late int _timeCount;
  late List<int> traceBackNums = shuffle(_nums).cast<int>();

  Sudoku(List<int> puzzle, {bool strict = false}) {
    if (puzzle.length != 81) {
      throw StateError("pls input normal sudoku puzzle , it must length 81");
    }

    this._puzzle = puzzle;

    List<int> answer = puzzle.sublist(0);
    List<List<bool>> rows, cols, zones;
    rows = List<List<bool>>.generate(
        81, (index) => List<bool>.generate(10, (index) => false));
    cols = List<List<bool>>.generate(
        81, (index) => List<bool>.generate(10, (index) => false));
    zones = List<List<bool>>.generate(
        81, (index) => List<bool>.generate(10, (index) => false));

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

    bool isSuccess = false;
    int timeBegin = DateTime.now().millisecondsSinceEpoch;
    int firstCheckPoint = 0;
    for (int index = 0; index < 81; ++index) {
      if (answer[index] == -1) {
        firstCheckPoint = index;
        break;
      }
    }

    if (strict) {
      // 唯一解模式,多解则抛出错误
      Map mark = Map.from({"finishes": 0, "answer": null});
      _dsfOneSolutionCalculate(
          rows, cols, zones, answer, firstCheckPoint, traceBackNums, mark);
      int finishes = mark["finishes"];
      if (finishes > 1) {
        // 不是唯一解 not on-solution
        throw StateError("puzzle is not one-solution sudoku");
      } else if (finishes == 0) {
        // 数独错误，无法计算
      } else {
        // 唯一解
        answer = mark["answer"];
        isSuccess = true;
      }
    } else {
      // 回溯模式
      isSuccess =
          _backtrackCalculate(rows, cols, zones, answer, firstCheckPoint);
    }

    if (!isSuccess) {
      throw StateError(
          "not found the solution. is that you give me the puzzle with mistake?");
    }

    this._answer = answer;
    this._timeCount = DateTime.now().millisecondsSinceEpoch - timeBegin;
  }

  _dsfOneSolutionCalculate(
      List<List<bool>> rows,
      List<List<bool>> cols,
      List<List<bool>> zones,
      List<int> answer,
      int index,
      traceBackNums,
      Map mark) {
    if (mark["finishes"] > 1) {
      return;
    }

    if (index >= 81) {
      for (int i = 0; i < 81; ++i) {
        if (answer[i] == -1) {
          return;
        }
      }
      mark["answer"] = answer;
      mark["finishes"]++;
      return;
    }

    if (answer[index] != -1) {
      _dsfOneSolutionCalculate(
          rows, cols, zones, answer, index + 1, traceBackNums, mark);
      return;
    }

    int row, col, zone;
    row = Matrix.getRow(index);
    col = Matrix.getCol(index);
    zone = Matrix.getZone(row: row, col: col);
    for (int num in traceBackNums) {
      if (!rows[row][num] && !cols[col][num] && !zones[zone][num]) {
        answer[index] = num;
        rows[row][num] = true;
        cols[col][num] = true;
        zones[zone][num] = true;

        _dsfOneSolutionCalculate(
            List.from(rows),
            List.from(cols),
            List.from(zones),
            List.from(answer),
            index + 1,
            traceBackNums,
            mark);

        answer[index] = -1;
        rows[row][num] = false;
        cols[col][num] = false;
        zones[zone][num] = false;
      }
    }
  }

  bool _backtrackCalculate(List<List<bool>> rows, List<List<bool>> cols,
      List<List<bool>> zones, List<int> answer, int index) {
    int row, col, zone;
    row = Matrix.getRow(index);
    col = Matrix.getCol(index);
    zone = Matrix.getZone(row: row, col: col);

    if (index >= 81) {
      return true;
    }

    if (answer[index] != -1) {
      return _backtrackCalculate(rows, cols, zones, answer, index + 1);
    }

    List<int> nums = this.traceBackNums;
    for (int num in nums) {
      if (!rows[row][num] && !cols[col][num] && !zones[zone][num]) {
        answer[index] = num;
        rows[row][num] = true;
        cols[col][num] = true;
        zones[zone][num] = true;

        if (_backtrackCalculate(rows, cols, zones, answer, index + 1)) {
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
    print('solution');
    formatPrint(this.solution);
    print('solve total time : ${this._timeCount}\'ms');
    print('--- debug end ---');
  }

  List<int> get puzzle => this._puzzle;

  List<int> get solution => this._answer;

  int get timeCount => this._timeCount;

  static Sudoku generate(sudokuGenerator.Level level) =>
      sudokuGenerator.generate(level: level);
}
