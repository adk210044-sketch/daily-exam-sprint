import 'dart:math';

import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../models/quiz_question.dart';

/// 苦手復習 (Forever Free) — 過去に間違えた問題からランダム抽出
class ReviewRepository {
  final AppDatabase db;
  ReviewRepository(this.db);

  /// 苦手 (取りこぼし) から卒業するために必要な「連続正解数」。
  /// 偶然の1回正解では卒業させない (反復演習で確実に定着させるため)。
  static const int graduationStreak = 2;

  /// 現在も「取りこぼし」扱いの問題ID一覧を返す。
  ///
  /// 判定ロジック: 各問題の回答履歴を時系列順に見て、末尾から連続で
  /// 正解している回数 (直近の連続正解数) が [graduationStreak] 未満なら
  /// まだ苦手 (取りこぼし) として扱う。
  /// - 一度も間違えたことがない問題は対象外 (そもそも取りこぼしではない)。
  /// - 直近の連続正解が [graduationStreak] 回に達した問題は苦手卒業。
  /// - 卒業条件を満たす前に1回でも間違えると連続カウントは0にリセットされる。
  Future<List<String>> getMissedQuestionIds() async {
    final logs = await (db.select(
      db.answerLog,
    )..orderBy([(t) => OrderingTerm.asc(t.answeredAt)])).get();

    final byQuestion = <String, List<AnswerLogData>>{};
    for (final log in logs) {
      byQuestion.putIfAbsent(log.questionId, () => []).add(log);
    }

    final missed = <String>[];
    byQuestion.forEach((questionId, history) {
      // 一度も間違えたことがなければ苦手ではない。
      final hasEverMissed = history.any((l) => !l.correct);
      if (!hasEverMissed) return;

      // 末尾 (最新) から連続正解数を数える。
      var streak = 0;
      for (final log in history.reversed) {
        if (log.correct) {
          streak++;
        } else {
          break;
        }
      }

      if (streak < graduationStreak) {
        missed.add(questionId);
      }
    });
    return missed;
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
