import '../database/app_database.dart';

/// 実試験1回分を Day1〜5すべて dailyCount問 に分割する。
///
/// - 各カテゴリ内で round-robin して、カテゴリ横断で均等になる1本の
///   フラットリストを作る (バランスの取れた出題順)。
/// - Day1〜Day4 は dailyCount 問ずつ新問を割り当てる。
/// - Day5(最終日) は「残りの新問」+「dailyCount 問に揃えるための
///   前日までの問題の再掲」で構成する。
///   (法改正等で除外された問題や、試験によって総問題数が少ない場合は、
///    再掲で埋める問題数が自然と増える)
/// - 各日は最後に問題番号順にソートする。
class DaySplitService {
  /// [questions] は同一 examType・同一 year の問題一覧(除外済み)を渡すこと。
  /// [dailyCount] は 1日あたりの基本問題数 (第1種=9 / 第2種=6)。
  /// 戻り値: [ [Day1の問題], [Day2の問題], ... [Day5の問題] ]
  static List<List<Question>> buildDaySets(
    List<Question> questions, {
    required int dailyCount,
    int days = 5,
  }) {
    if (questions.isEmpty) return List.generate(days, (_) => <Question>[]);
    if (days < 2) days = 2; // 最終日の再掲ロジックのため最低2日は必要

    // 1. カテゴリごとに分類 (元の出現順を保持)
    final byCat = <String, List<Question>>{};
    for (final q in questions) {
      byCat.putIfAbsent(q.categoryName, () => []).add(q);
    }
    final catLists = byCat.values.toList();

    // 2. カテゴリ横断で round-robin し、1本のバランス済みフラットリストへ
    final flat = <Question>[];
    var idx = 0;
    while (flat.length < questions.length) {
      var addedAny = false;
      for (final list in catLists) {
        if (idx < list.length) {
          flat.add(list[idx]);
          addedAny = true;
        }
      }
      if (!addedAny) break;
      idx++;
    }

    final result = List.generate(days, (_) => <Question>[]);
    final regularDays = days - 1; // Day1〜Day(days-1) は dailyCount ずつ

    var cursor = 0;
    for (var d = 0; d < regularDays; d++) {
      final end = ((d + 1) * dailyCount).clamp(0, flat.length);
      result[d] = flat.sublist(cursor.clamp(0, flat.length), end);
      cursor = end;
    }

    // 3. 最終日: 残りの新問 + 前日までの問題からの再掲で dailyCount に揃える
    final lastTarget = dailyCount;
    final remaining = cursor < flat.length
        ? flat.sublist(cursor)
        : <Question>[];
    final lastDay = <Question>[...remaining];

    if (lastDay.length < lastTarget) {
      // 前日まで(Day1〜Day(days-1))に出題した問題プールから再掲して補充
      final pool = flat.sublist(0, cursor.clamp(0, flat.length));
      if (pool.isNotEmpty) {
        var poolIdx = 0;
        while (lastDay.length < lastTarget) {
          lastDay.add(pool[poolIdx % pool.length]);
          poolIdx++;
        }
      }
    } else if (lastDay.length > lastTarget) {
      lastDay.removeRange(lastTarget, lastDay.length);
    }
    result[days - 1] = lastDay;

    // 4. 各日を問題番号順にソート
    for (final day in result) {
      day.sort((a, b) => a.numberInt.compareTo(b.numberInt));
    }

    return result;
  }

  /// examType に応じた1日あたりの基本問題数 (第1種=9問 / 第2種=6問)
  static int dailyCountForExamType(String examType) =>
      examType == 'type1' ? 9 : 6;
}
