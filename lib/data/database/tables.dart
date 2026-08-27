import 'package:drift/drift.dart';

/// 問題テーブル — exam_questions.json をそのままインポート
class Questions extends Table {
  TextColumn get id => text()(); // e.g. "q_type1_R6年10月_1"
  TextColumn get examType => text()(); // 'type1' | 'type2'
  TextColumn get year => text()(); // e.g. "令和6年10月公表"
  TextColumn get categoryKey => text()();
  TextColumn get categoryName => text()();
  TextColumn get number => text()(); // e.g. "問1"
  IntColumn get numberInt => integer()(); // 問題番号の数値部分 (ソート用)
  TextColumn get questionText => text()();
  TextColumn get choicesJson => text()(); // JSON encoded List<String>, 常に5個
  IntColumn get correctIndex => integer()();
  TextColumn get officialExplanation => text()();

  @override
  Set<Column> get primaryKey => {id};
}

/// 試験セッション — 全11回分の進捗管理
class ExamSessions extends Table {
  TextColumn get id => text()(); // e.g. "r6_10"
  TextColumn get year => text()(); // categoryのyearと一致
  TextColumn get label => text()(); // e.g. "令和6年 10月"
  TextColumn get examType => text()();
  IntColumn get totalQ => integer()();
  BoolColumn get isLatest => boolean().withDefault(const Constant(false))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  // progress
  TextColumn get status => text().withDefault(
    const Constant('not_started'),
  )(); // not_started/in_progress/completed
  IntColumn get day => integer().withDefault(const Constant(0))(); // 1-7
  IntColumn get attempt =>
      integer().withDefault(const Constant(0))(); // 本日の挑戦回数
  IntColumn get avgScore => integer().nullable()(); // 平均正答率 %
  IntColumn get hanamaruDays => integer().withDefault(const Constant(0))();
  BoolColumn get weekComplete => boolean().withDefault(const Constant(false))();
  TextColumn get dayQuestionIdsJson => text()
      .nullable()(); // Day1-5 の問題ID割り当て(JSON: Map<int(day), List<String>>)
  TextColumn get reviewQuestionIdsJson =>
      text().nullable()(); // Day6-7 復習9問のID(JSON List<String>)

  @override
  Set<Column> get primaryKey => {id};
}

/// Day毎の進捗ログ (1日1エントリ、attempt毎に更新)
class DailyProgress extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get sessionId => text()();
  IntColumn get day => integer()(); // 1-7
  IntColumn get attempt => integer()();
  IntColumn get score => integer()(); // 0-9 の正解数
  IntColumn get totalQuestions => integer()();
  BoolColumn get hanamaru => boolean().withDefault(const Constant(false))();
  DateTimeColumn get completedAt => dateTime()();
}

/// 全回答履歴 (苦手抽出用)
class AnswerLog extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get questionId => text()();
  TextColumn get sessionId => text()();
  IntColumn get day => integer()();
  IntColumn get attempt => integer()();
  IntColumn get chosen => integer()();
  BoolColumn get correct => boolean()();
  DateTimeColumn get answeredAt => dateTime()();
}

/// カレンダーマーク (満点日)
class CalendarMarks extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()(); // 年月日のみ使用 (時刻は00:00に正規化)
  IntColumn get score => integer()(); // 正答率 %
  BoolColumn get hanamaru => boolean()();
  TextColumn get sessionId => text().nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {date},
  ];
}

/// ユーザー設定 (単一行)
class UserSettings extends Table {
  IntColumn get id => integer().withDefault(const Constant(0))();
  TextColumn get examType => text().withDefault(const Constant('type1'))();
  TextColumn get reminderTime => text().withDefault(const Constant('08:15'))();
  DateTimeColumn get goalDate => dateTime().nullable()();
  TextColumn get fontSize => text().withDefault(const Constant('medium'))();
  BoolColumn get purchased => boolean().withDefault(const Constant(false))();
  TextColumn get currentSessionId => text().nullable()();
  BoolColumn get onboardingComplete =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get notificationsEnabled =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
