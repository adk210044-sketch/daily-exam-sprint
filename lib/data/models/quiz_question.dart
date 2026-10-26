import 'dart:convert';

import '../database/app_database.dart';

/// Question テーブルの行を扱いやすくしたモデル (choicesJson をデコード済み)
class QuizQuestion {
  final String id;
  final String examType;
  final String year;
  final String categoryName;
  final String number;
  final int numberInt;
  final String text;
  final List<String> choices;
  final int correctIndex;
  final String officialExplanation;

  QuizQuestion({
    required this.id,
    required this.examType,
    required this.year,
    required this.categoryName,
    required this.number,
    required this.numberInt,
    required this.text,
    required this.choices,
    required this.correctIndex,
    required this.officialExplanation,
  });

  /// 選択肢テキストの先頭に含まれる "(1)" "（２）" のような番号表記を除去する。
  ///
  /// 出題データ(JSON)には選択肢本文に "(1) 〜" のように選択肢番号が
  /// 埋め込まれているが、UI側では丸数字バッジ(①②③…)を別途表示しているため、
  /// そのまま表示すると番号が二重に見えてしまう。表示直前にこの関数を通し、
  /// 重複する番号表記だけを取り除く。
  static final RegExp _leadingChoiceNumber = RegExp(
    r'^\s*[\(（]\s*[0-9０-９]+\s*[\)）]\s*',
  );

  static String displayChoice(String choice) {
    return choice.replaceFirst(_leadingChoiceNumber, '');
  }

  factory QuizQuestion.fromRow(Question row) {
    final list = (jsonDecode(row.choicesJson) as List<dynamic>)
        .map((e) => e.toString())
        .toList();
    return QuizQuestion(
      id: row.id,
      examType: row.examType,
      year: row.year,
      categoryName: row.categoryName,
      number: row.number,
      numberInt: row.numberInt,
      text: row.questionText,
      choices: list,
      correctIndex: row.correctIndex,
      officialExplanation: row.officialExplanation,
    );
  }
}
