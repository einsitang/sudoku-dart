# sudoku-dart
sudoku lib with dart

# 关于
开源的数独库，支持解题与题目生成

# API
```dart
import 'package:sudoku_dart/sudoku_dart.dart';
// 支持数独生成
// 其中LEVEL 分为 EASY(简单), MEDIUM(中等), HARD(困难), EXPERT(专家)
Sudoku sudoku = Sudoku.generator(LEVEL.EXPERT);

// 支持数独解题
// 输入一维数组的puzzle,-1为待填空
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

sudoku = Sudoku(puzzle: puzzle);
// 打印调试信息
sudoku.debug();
// 查看原始谜面
sudoku.puzzle;
// 获取完整数独答案
sudoku.answer;

```

# 更多
后续补充