# Changelog
## 1.2.0
- version-dependent update
## 1.1.0
- amend api
- optimize format print
- automatic difficulty adjustment
  - `sudoku_dart` is run on client side , don't want generate puzzle take long time
## 1.0.4
- fix generate logic make sure each zone both have less one number
- adjust expert rollback 1.0.2 difficulty
- change test file you can use `dart test example/lib/*_test.dart` to use test case
## 1.0.2
- enhance `Level.expert` difficulty
- change dart specification
- detailed document
- enjoy it
## 1.0.1
-  support null safety
## 1.0.0
- recode solver and generator
- easy to read code and english friendly(maybe..)
- however , if you want to use this library , just need to know this version better than the old version
- have good fun :-)
## 0.1.0
- 更新文档结构

## 0.0.9
- update readme.md and code specification

## 0.0.8
- fix(tools):Matrix.getZone

## 0.0.7
- `tools.dart` 函数row和col计算错误修复

## 0.0.6
- update `tools` api , add `getRowIndexes`,`getColIndexes`

## 0.0.3
- update `Sudoku.generator` api

## 0.0.2
- 更改包名与文件结构
- 修正类型作用域

## 0.0.1
- 数独解题
- 数独谜题生成器,支持 easy / medium / hard / expert 四种难度
