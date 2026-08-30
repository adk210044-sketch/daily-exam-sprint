import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../database/app_database.dart';

/// assets/data/exam_questions.json を起動時にローカルDBへインポートする。
///
/// [currentContentVersion] を上げると、既にインストール済みのユーザーの端末でも
/// 次回起動時に Questions テーブルのみが再インポート(insertOrReplace)される。
/// ExamSessions / AnswerLog / DailyProgress 等の学習進捗データには一切影響しない。
///
/// 【運用ルール】
/// exam_questions.json の内容 (officialExplanation の誤り修正など) を変更した場合は、
/// 必ず [currentContentVersion] を +1 すること。忘れると、既存ユーザーの端末には
/// 変更が反映されない (新規インストールのみ最新化される) ので注意。
class QuestionImporter {
  final AppDatabase db;
  QuestionImporter(this.db);

  /// 問題データのコンテンツバージョン。
  /// 履歴:
  ///   1: 初回リリース時点のデータ
  ///   2: 令和6年10月_12 / 令和4年10月_12 / 令和3年10月_15 の公式解説を修正
  static const int currentContentVersion = 2;

  static int _extractNumberInt(String number) {
    final digits = RegExp(r'[0-9]+').firstMatch(number)?.group(0);
    return digits != null ? int.parse(digits) : 0;
  }

  /// UserSettings.contentVersion が [currentContentVersion] 未満であれば
  /// Questions テーブルを再インポートする。
  /// 戻り値: インポートした件数 (バージョンが最新で不要な場合は 0)
  Future<int> importIfNeeded() async {
    final setting = await (db.select(
      db.userSettings,
    )..where((t) => t.id.equals(0))).getSingleOrNull();

    final storedVersion = setting?.contentVersion ?? 0;
    if (storedVersion >= currentContentVersion) {
      return 0;
    }

    final raw = await rootBundle.loadString('assets/data/exam_questions.json');
    final List<dynamic> list = jsonDecode(raw) as List<dynamic>;

    final companions = <QuestionsCompanion>[];
    for (final item in list) {
      final map = item as Map<String, dynamic>;

      // 法改正等により単一正解が崩れた問題(correctIndexesが複数)は
      // 自動採点が成立しないため出題対象から除外する。
      // (該当分は Day分割時に前日までの問題を再掲して穴埋めする)
      final correctIndexes = map['correctIndexes'] as List<dynamic>?;
      if (correctIndexes != null && correctIndexes.length > 1) {
        continue;
      }

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

    // 再インポート完了後、バージョン番号をDBに記録する。
    // (UserSettings行が無い場合は getOrCreate 相当の insertOnConflictUpdate で作成)
    await db
        .into(db.userSettings)
        .insertOnConflictUpdate(
          UserSettingsCompanion(
            id: const Value(0),
            contentVersion: Value(currentContentVersion),
          ),
        );

    return companions.length;
  }
}
