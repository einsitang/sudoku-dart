import 'dart:math';

import 'core.dart';
import 'tools.dart';

enum LEVEL { EASY, MEDIUM, HARD, EXPERT }

///
/// 谜题规则
class _PuzzleRule {

  /// fill 为宫填充数量
  /// count 为宫数量
  int fill, count;

  _PuzzleRule(int fill, int count) {
    this.fill = fill;
    this.count = count;
  }
}

class _FillRule {
  int fill, count, progress;
  List<int> indexes;

  _FillRule(int fill, int count, int progress, List<int> indexes) {
    this.fill = fill;
    this.count = count;
    this.progress = progress;
    this.indexes = indexes;
  }
}

///
/// 不同谜题的级别规则
final _PUZZLE_RULES = {
  LEVEL.EASY: [
    _PuzzleRule(7, 1),
    _PuzzleRule(6, 1),
    _PuzzleRule(5, 3),
    _PuzzleRule(4, 2),
    _PuzzleRule(3, 2),
  ],
  LEVEL.MEDIUM: [
    _PuzzleRule(6, 1),
    _PuzzleRule(5, 3),
    _PuzzleRule(4, 2),
    _PuzzleRule(3, 2),
    _PuzzleRule(2, 1),
  ],
  LEVEL.HARD: [
    _PuzzleRule(5, 1),
    _PuzzleRule(4, 2),
    _PuzzleRule(3, 3),
    _PuzzleRule(2, 2),
    _PuzzleRule(1, 1),
  ],
  LEVEL.EXPERT: [
    _PuzzleRule(5, 1),
    _PuzzleRule(4, 1),
    _PuzzleRule(3, 3),
    _PuzzleRule(2, 3),
    _PuzzleRule(1, 1),
  ]
};

class _NumPool {
  var capacity, replace, meta;

  _NumPool({int capacity = 3}) {
    this.capacity = capacity;
    this.replace = 0;
    this.meta = {};
  }

  List<int> nums() {
    List<int> originNums = List.generate(9, (index) => index + 1);
    List<int> nums = [];
    originNums = shuffle(originNums);
    originNums.forEach((num) {
      var numMeta = this.meta[num];
      if (numMeta == null) {
        numMeta = 0;
      }
      if (numMeta < this.capacity) {
        nums.add(num);
      }
    });

    return nums;
  }

  record(num) {
    var numMeta = this.meta[num];
    if (numMeta == null) {
      numMeta = 0;
    }
    numMeta++;
    this.meta[num] = numMeta;
    if (numMeta >= this.capacity) {
      this.replace++;
    }
    if (this.replace >= 2) {
      this.capacity++;
      this.replace = 0;
    }
  }
}

void _simFill(List<int> puzzle, List<List<bool>> rows, List<List<bool>> cols, List<List<bool>> zones, int index, _NumPool numPool) {
  List<int> tryNums = numPool.nums();

  int row = Matrix.getRow(index);
  int col = Matrix.getCol(index);
  int zone = Matrix.getZone(index: index);

  for (int tryNum in tryNums) {
    if (!rows[row][tryNum] && !cols[col][tryNum] && !zones[zone][tryNum]) {
      rows[row][tryNum] = true;
      cols[col][tryNum] = true;
      zones[zone][tryNum] = true;
      puzzle[index] = tryNum;
      numPool.record(tryNum);
      break;
    }
  }
}

List _buildFillRules(List<_PuzzleRule> puzzleRules) {
  // 分配宫的填充规则
  List<int> distributeZones = List.generate(9, (index) => index);
  List<_FillRule> zoneRules = [];
  List<List<int>> zoneIndexes = List.generate(9, (index) {
    return Matrix.getZoneIndexes(zone: index);
  });

  Random random = Random();
  puzzleRules.forEach((rule) {
    List<int> indexes = [];

    int zoneCounter = 0;
    while (zoneCounter < rule.count) {
      // 随机一个候选宫
      int randomZone = random.nextInt(distributeZones.length);
      List<int> distributeIndexes = zoneIndexes[distributeZones.removeAt(randomZone)];

      // 在候选宫中随机出需要fill的格子
      int fillCounter = 0;
      while (fillCounter < rule.fill) {
        int randomIndex = random.nextInt(distributeIndexes.length);
        indexes.add(distributeIndexes.removeAt(randomIndex));
        fillCounter++;
      }

      zoneCounter++;
    }
    zoneRules.add(_FillRule(rule.fill, rule.count, 0, indexes));
  });

  return zoneRules;
}

///
/// 根据填充规则生成谜题
/// @param fillRules 填充规则
Sudoku _generator(List<_FillRule> fillRules) {
  // 初始化填充记录
  List<List<bool>> rows, cols, zones;
  rows = List<List<bool>>.generate(9, (index) => List<bool>.generate(10, (index) => false));
  cols = List<List<bool>>.generate(9, (index) => List<bool>.generate(10, (index) => false));
  zones = List<List<bool>>.generate(9, (index) => List<bool>.generate(10, (index) => false));

  _NumPool numPool = _NumPool();
  List<int> fillIndexs = [];
  fillRules.forEach((fillRule) {
    fillIndexs.addAll(fillRule.indexes);
  });

  // 计算中心位置
  List<int> basicIndexes = [];
  List.generate(3, (index) => index + 3).forEach((y) {
    List.generate(3, (index) => y * 9 + 3 + index).forEach((basicIndex) {
      basicIndexes.add(basicIndex);
    });
  });

  // 基础数据填充
  List<int> basicPuzzle = List.generate(81, (index) => -1);
  basicIndexes.forEach((index) {
    _simFill(basicPuzzle, rows, cols, zones, index, numPool);
  });

  // 根据基准数据计算完整数独
  Sudoku sudoku1 = Sudoku(basicPuzzle);
  List<int> answer1 = sudoku1.answer;

  // 挖洞
  List<int> puzzle = List.generate(81, (index) => -1);
  fillIndexs.forEach((index) {
    puzzle[index] = answer1[index];
  });

  // 校验挖洞之后的puzzle

  Sudoku testSudoku1 = Sudoku(puzzle);
  Sudoku testSudoku2 = Sudoku(puzzle);

  List<int> testAnswer1 = testSudoku1.answer;
  List<int> testAnswer2 = testSudoku2.answer;

  for(int i = 0 ;i<testAnswer1.length;++i){
    if (testAnswer1[i] != testAnswer2[i]) {
      throw StateError("retry");
    }
  }

  // 输出校验后的题目
  return testSudoku1;
}

///
/// 默认级别为:简单(LEVEL.EASY)
Sudoku generator({LEVEL level = LEVEL.EASY}) {

  List<_PuzzleRule> puzzleRules = _PUZZLE_RULES[level];

  // 构建填充规则
  var fillRules = _buildFillRules(puzzleRules);

  Sudoku sudoku;
  int beginTime = DateTime.now().millisecondsSinceEpoch;

//  int retryCount = 0;
  while (sudoku == null) {
    try {
      sudoku = _generator(fillRules);
    } catch (e) {
      // retry
//      print('retryCount:${++retryCount}');
    }
  }

  int endTime = DateTime.now().millisecondsSinceEpoch;
  print('数独题目生成耗时: ${endTime - beginTime}\'ms');

  return sudoku;
}
