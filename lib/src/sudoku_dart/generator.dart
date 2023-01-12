import 'core.dart';
import 'tools.dart';

enum Level { easy, medium, hard, expert }

Sudoku generate({Level level = Level.easy}) {
  // level to dig hole count
  int digHoleCount = 40;
  switch (level) {
    case Level.easy:
      digHoleCount = 38;
      break;
    case Level.medium:
      digHoleCount = 45;
      break;
    case Level.hard:
      digHoleCount = 50;
      break;
    case Level.expert:
      digHoleCount = 56;
      break;
    default:
      break;
  }

  return _generate(digHoleCount);
}

Sudoku _generate(int digHoleCount) {
  List<int> randCenterZoneIndexes =
      shuffle(List.generate(9, (index) => index + 1)).cast<int>();
  List<int> simplePuzzle = List.generate(81, (index) => index);
  for (int i = 0; i < simplePuzzle.length; ++i) {
    if (Matrix.getZone(index: i) == 4) {
      simplePuzzle[i] = randCenterZoneIndexes.removeAt(0);
    } else {
      simplePuzzle[i] = -1;
    }
  }
  Sudoku sudoku = new Sudoku(simplePuzzle);
  Sudoku? generatedSudoku = _internalGenerate(sudoku.answer, digHoleCount);
  return generatedSudoku != null ? generatedSudoku : _generate(digHoleCount);
}

Sudoku? _internalGenerate(List<int> digHolePuzzle, int digHoleCount) {
  List<int> candidateIndexes = [];
  List fixedPositions =
      shuffle(List.generate(9, (index) => index).cast<int>());
  for (int i = 0; i < 81; ++i) {
    if (fixedPositions.isNotEmpty && fixedPositions.first == i) {
      fixedPositions.remove(0);
      continue;
    }
    candidateIndexes.add(i);
  }
  candidateIndexes = shuffle(candidateIndexes).cast<int>();

  int digHoleFulfill = 0;
  int old = -1, index = 0;
  for (int i = 0; i < candidateIndexes.length; ++i) {
    index = candidateIndexes[i];
    old = digHolePuzzle[index];
    digHolePuzzle[index] = -1;
    try {
      new Sudoku(digHolePuzzle, strict: true);
      digHoleFulfill++;
    } catch (e) {
      digHolePuzzle[index] = old;
    }
    if (digHoleFulfill >= digHoleCount) {
      break;
    }
  }

  return digHoleFulfill >= digHoleCount ? new Sudoku(digHolePuzzle) : null;
}
