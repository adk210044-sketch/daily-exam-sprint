import 'dart:math';

import '../database/app_database.dart';
import '../models/quiz_question.dart';

/// 苦手復習 (Forever Free) — 過去に間違えた問題からランダム抽出
class ReviewRepository {
  final AppDatabase db;
  ReviewRepository(this.db);

  /// 現在も「取りこぼし」扱いの問題ID一覧 (直近の回答が不正解のもの)
  Future<List<String>> getMissedQuestionIds() async {
    final logs = await db.select(db.answerLog).get();
    // questionId ごとに最新の回答を見て、不正解なら「取りこぼし」
    final latestByQuestion = <String, AnswerLogData>{};
    for (final log in logs) {
      final existing = latestByQuestion[log.questionId];
      if (existing == null || log.answeredAt.isAfter(existing.answeredAt)) {
        latestByQuestion[log.questionId] = log;
      }
    }
    return latestByQuestion.values
        .where((l) => !l.correct)
        .map((l) => l.questionId)
        .toList();
  }

  Future<int> getMissedCount() async => (await getMissedQuestionIds()).length;

  /// カテゴリ別の取りこぼし数
  Future<Map<String, int>> getMissedByCategory() async {
    final ids = await getMissedQuestionIds();
    if (ids.isEmpty) return {};
    final rows = await (db.select(
      db.questions,
    )..where((t) => t.id.isIn(ids))).get();
    final result = <String, int>{};
    for (final r in rows) {
      result[r.categoryName] = (result[r.categoryName] ?? 0) + 1;
    }
    return result;
  }

  /// 苦手復習N問 (無料版) or 無制限 (有料版) をランダム抽出
  /// N = examType に応じた1日あたり問題数 (第1種=9 / 第2種=6)
  Future<List<QuizQuestion>> buildReviewSet({
    required bool purchased,
    required int dailyCount,
  }) async {
    final ids = await getMissedQuestionIds();
    if (ids.isEmpty) return [];
    ids.shuffle(Random());
    final limited = purchased ? ids : ids.take(dailyCount).toList();
    final rows = await (db.select(
      db.questions,
    )..where((t) => t.id.isIn(limited))).get();
    final byId = {for (final r in rows) r.id: QuizQuestion.fromRow(r)};
    return limited.map((id) => byId[id]).whereType<QuizQuestion>().toList();
  }
}
