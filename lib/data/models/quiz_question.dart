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
