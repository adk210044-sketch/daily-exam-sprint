import '../database/app_database.dart';

/// buildDaySets() の Dart 移植
/// 出典: design_handoff_zen_habit_v2/01_prototype/components/mockData.js
///
/// 実試験1回分 (44問 or 30問) を 5日 × 約9問 に分割する。
/// - 各カテゴリ内で round-robin で days 個に配分 (複数回混合はしない)
/// - 各日を問題番号順にソート
class DaySplitService {
  /// [questions] は同一 examType・同一 year の問題一覧を渡すこと。
  /// 戻り値: [ [Day1 の問題], [Day2 の問題], ... [Day5 の問題] ]
  static List<List<Question>> buildDaySets(
    List<Question> questions, {
    int days = 5,
  }) {
    if (questions.isEmpty) return List.generate(days, (_) => <Question>[]);

    // 1. カテゴリごとに分類 (元の出現順を保持するため LinkedHashMap 的に扱う)
    final byCat = <String, List<Question>>{};
    for (final q in questions) {
      byCat.putIfAbsent(q.categoryName, () => []).add(q);
    }

    // 2. 各カテゴリ内で round-robin に days 個へ配分
    final result = List.generate(days, (_) => <Question>[]);
    for (final qs in byCat.values) {
      for (var i = 0; i < qs.length; i++) {
        result[i % days].add(qs[i]);
      }
    }

    // 3. 各日を問題番号順にソート
    for (final day in result) {
      day.sort((a, b) => a.numberInt.compareTo(b.numberInt));
    }

    return result;
  }
}
