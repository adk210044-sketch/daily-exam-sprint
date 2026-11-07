import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../models/quiz_question.dart';
import '../repositories/exam_session_repository.dart';

/// 公式試験の「科目」区分 (合格基準は科目ごとに40%以上)。
/// Questions.categoryKey は law_harm/law_general/labor_harm/labor_general/
/// physiology の5種類。第1種はこの5科目区分のまま合否判定されるため、
/// 「有害業務に係るもの」「有害業務以外」を分けて診断する。
/// (第2種には law_harm/labor_harm の問題が存在しないため、結果的に
/// 3科目のみが表示される)
enum ExamSubject { lawHarm, lawGeneral, hygieneHarm, hygieneGeneral, physiology }

extension ExamSubjectX on ExamSubject {
  String get label {
    switch (this) {
      case ExamSubject.lawHarm:
        return '関係法令(有害業務に係るもの)';
      case ExamSubject.lawGeneral:
        return '関係法令(有害業務以外)';
      case ExamSubject.hygieneHarm:
        return '労働衛生(有害業務に係るもの)';
      case ExamSubject.hygieneGeneral:
        return '労働衛生(有害業務以外)';
      case ExamSubject.physiology:
        return '労働生理';
    }
  }

  /// レイアウトが狭い箇所向けの短縮ラベル。
  String get shortLabel {
    switch (this) {
      case ExamSubject.lawHarm:
        return '関係法令(有害)';
      case ExamSubject.lawGeneral:
        return '関係法令(有害以外)';
      case ExamSubject.hygieneHarm:
        return '労働衛生(有害)';
      case ExamSubject.hygieneGeneral:
        return '労働衛生(有害以外)';
      case ExamSubject.physiology:
        return '労働生理';
    }
  }
}

/// categoryKey ("law_harm" 等) を公式科目区分にマッピングする。
ExamSubject subjectOfCategoryKey(String categoryKey) {
  switch (categoryKey) {
    case 'law_harm':
      return ExamSubject.lawHarm;
    case 'law_general':
      return ExamSubject.lawGeneral;
    case 'labor_harm':
      return ExamSubject.hygieneHarm;
    case 'labor_general':
      return ExamSubject.hygieneGeneral;
    default:
      return ExamSubject.physiology;
  }
}

/// 1科目分の正答率集計結果。
class SubjectScore {
  final ExamSubject subject;
  final int correct;
  final int total;

  const SubjectScore({
    required this.subject,
    required this.correct,
    required this.total,
  });

  double get rate => total == 0 ? 0 : correct / total;
  int get ratePercent => (rate * 100).round();

  /// 公式合格基準: 各科目40%以上。
  bool get passesSubjectMinimum => total == 0 ? true : rate >= 0.4;
}

/// 合格可能性診断の結果一式。
class PassDiagnosis {
  final List<SubjectScore> subjects;
  final int totalCorrect;
  final int totalQuestions;
  /// 診断の母数に使われた回答ログの件数 (問題単位で最新1回のみを採用)。
  final int answeredQuestionCount;

  const PassDiagnosis({
    required this.subjects,
    required this.totalCorrect,
    required this.totalQuestions,
    required this.answeredQuestionCount,
  });

  double get overallRate =>
      totalQuestions == 0 ? 0 : totalCorrect / totalQuestions;
  int get overallPercent => (overallRate * 100).round();

  /// 公式合格基準: 総合60%以上 かつ 各科目40%以上。
  bool get isLikelyPass =>
      totalQuestions > 0 &&
      overallRate >= 0.6 &&
      subjects.every((s) => s.passesSubjectMinimum);

  List<SubjectScore> get failingSubjects =>
      subjects.where((s) => !s.passesSubjectMinimum).toList();
}

/// 合格可能性診断のロジック。
///
/// 現在選択中の試験区分 (examType) に属する全セッションの AnswerLog を
/// 問題IDごとに集約し (同じ問題に複数回答している場合は「最新の回答」を
/// 採用)、公式科目区分ごとの正答率・総合正答率を算出する。
///
/// 【設計メモ】
/// - 「苦手復習」の回答ログ (sessionId == QuizSessionProvider.reviewSessionId)
///   は、同じ問題への再挑戦の結果であり、ここでの集計対象にすると
///   「複数回答した問題だけ結果が上書きされる」という不整合が起きにくいよう、
///   questionId ごとに answeredAt が最も新しいログを採用する方式で統一する。
/// - 「おかわり」(isReplay) の回答はログに記録されない仕様 (recordAnswer が
///   呼ばれない) ため、自然に集計対象から除外される。
class DiagnosisService {
  final AppDatabase db;
  final ExamSessionRepository examRepo;

  DiagnosisService(this.db, this.examRepo);

  /// 指定した examType の全問題に対する回答状況から診断を作成する。
  /// 一度も回答していない場合は totalQuestions=0 の診断を返す
  /// (呼び出し側で「データ不足」として扱うこと)。
  Future<PassDiagnosis> diagnose(String examType) async {
    // 1. examType に属する全セッションIDを取得
    final sessions = await examRepo.getAllSessions();
    final sessionIds = sessions
        .where((s) => s.examType == examType)
        .map((s) => s.id)
        .toSet();
    if (sessionIds.isEmpty) {
      return const PassDiagnosis(
        subjects: [],
        totalCorrect: 0,
        totalQuestions: 0,
        answeredQuestionCount: 0,
      );
    }

    // 2. 全回答ログを取得 (苦手復習時の固定IDは対象外: 学習進捗ログのみ)
    final rows = await db.select(db.answerLog).get();
    final relevant = rows.where((r) => sessionIds.contains(r.sessionId));

    // 3. 問題IDごとに最新の回答のみ採用
    final latestByQuestion = <String, AnswerLogData>{};
    for (final r in relevant) {
      final existing = latestByQuestion[r.questionId];
      if (existing == null || r.answeredAt.isAfter(existing.answeredAt)) {
        latestByQuestion[r.questionId] = r;
      }
    }
    if (latestByQuestion.isEmpty) {
      return const PassDiagnosis(
        subjects: [],
        totalCorrect: 0,
        totalQuestions: 0,
        answeredQuestionCount: 0,
      );
    }

    // 4. 該当する問題の categoryKey を取得
    final questionIds = latestByQuestion.keys.toList();
    final questionRows = await (db.select(
      db.questions,
    )..where((t) => t.id.isIn(questionIds))).get();
    final categoryById = {for (final q in questionRows) q.id: q.categoryKey};

    // 5. 科目ごとに集計
    final totalBySubject = <ExamSubject, int>{};
    final correctBySubject = <ExamSubject, int>{};
    var totalCorrect = 0;
    var totalCount = 0;
    for (final entry in latestByQuestion.entries) {
      final categoryKey = categoryById[entry.key];
      if (categoryKey == null) continue; // 法改正等で削除された問題は除外
      final subject = subjectOfCategoryKey(categoryKey);
      totalBySubject[subject] = (totalBySubject[subject] ?? 0) + 1;
      totalCount++;
      if (entry.value.correct) {
        correctBySubject[subject] = (correctBySubject[subject] ?? 0) + 1;
        totalCorrect++;
      }
    }

    final subjects = ExamSubject.values
        .map(
          (s) => SubjectScore(
            subject: s,
            correct: correctBySubject[s] ?? 0,
            total: totalBySubject[s] ?? 0,
          ),
        )
        .where((s) => s.total > 0)
        .toList();

    return PassDiagnosis(
      subjects: subjects,
      totalCorrect: totalCorrect,
      totalQuestions: totalCount,
      answeredQuestionCount: totalCount,
    );
  }

  /// 診断に十分なデータが集まっているとみなす最低回答数。
  /// (カテゴリ別の偏りを避けるため、ある程度の問題数が必要)
  static const int minAnsweredForDiagnosis = 20;
}

/// 模試モード (既存の過去問1回分を、本番と同じ構成・問題数で時間制限付きに
/// 解く有料限定モード) 用のヘルパー。
class MockExamService {
  final AppDatabase db;

  MockExamService(this.db);

  /// 指定した試験回 (examType + year) の全問題を取得する。
  Future<List<QuizQuestion>> fullQuestionsFor(ExamSession session) async {
    final rows =
        await (db.select(db.questions)..where(
              (t) =>
                  t.examType.equals(session.examType) &
                  t.year.equals(session.year),
            ))
            .get();
    final list = rows.map(QuizQuestion.fromRow).toList()
      ..sort((a, b) => a.numberInt.compareTo(b.numberInt));
    return list;
  }

  /// 試験種別に応じた制限時間 (本番と同じ: 3時間)。
  static const Duration timeLimit = Duration(hours: 3);
}
