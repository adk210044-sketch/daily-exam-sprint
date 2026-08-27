import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../database/app_database.dart';

/// assets/data/exam_questions.json を初回起動時にローカルDBへインポートする
class QuestionImporter {
  final AppDatabase db;
  QuestionImporter(this.db);

  static int _extractNumberInt(String number) {
    final digits = RegExp(r'[0-9]+').firstMatch(number)?.group(0);
    return digits != null ? int.parse(digits) : 0;
  }

  /// Questions テーブルが空であれば JSON をインポートする。
  /// 戻り値: インポートした件数 (既にデータがあれば 0)
  Future<int> importIfNeeded() async {
    final count = await db.select(db.questions).get();
    if (count.isNotEmpty) return 0;

    final raw = await rootBundle.loadString('assets/data/exam_questions.json');
    final List<dynamic> list = jsonDecode(raw) as List<dynamic>;

    final companions = <QuestionsCompanion>[];
    for (final item in list) {
      final map = item as Map<String, dynamic>;
      final choices = (map['choices'] as List<dynamic>)
          .map((e) => e.toString())
          .toList();
      companions.add(
        QuestionsCompanion.insert(
          id: map['id'] as String,
          examType: map['examType'] as String,
          year: map['year'] as String,
          categoryKey: map['categoryKey'] as String? ?? '',
          categoryName: map['categoryName'] as String,
          number: map['number'] as String,
          numberInt: _extractNumberInt(map['number'] as String),
          questionText: map['text'] as String,
          choicesJson: jsonEncode(choices),
          correctIndex: map['correctIndex'] as int,
          officialExplanation: map['officialExplanation'] as String? ?? '',
        ),
      );
    }

    await db.batch((batch) {
      batch.insertAll(
        db.questions,
        companions,
        mode: InsertMode.insertOrReplace,
      );
    });

    return companions.length;
  }
}
