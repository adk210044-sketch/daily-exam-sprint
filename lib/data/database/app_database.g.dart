// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $QuestionsTable extends Questions
    with TableInfo<$QuestionsTable, Question> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuestionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _examTypeMeta = const VerificationMeta(
    'examType',
  );
  @override
  late final GeneratedColumn<String> examType = GeneratedColumn<String>(
    'exam_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<String> year = GeneratedColumn<String>(
    'year',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryKeyMeta = const VerificationMeta(
    'categoryKey',
  );
  @override
  late final GeneratedColumn<String> categoryKey = GeneratedColumn<String>(
    'category_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryNameMeta = const VerificationMeta(
    'categoryName',
  );
  @override
  late final GeneratedColumn<String> categoryName = GeneratedColumn<String>(
    'category_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _numberMeta = const VerificationMeta('number');
  @override
  late final GeneratedColumn<String> number = GeneratedColumn<String>(
    'number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _numberIntMeta = const VerificationMeta(
    'numberInt',
  );
  @override
  late final GeneratedColumn<int> numberInt = GeneratedColumn<int>(
    'number_int',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _questionTextMeta = const VerificationMeta(
    'questionText',
  );
  @override
  late final GeneratedColumn<String> questionText = GeneratedColumn<String>(
    'question_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _choicesJsonMeta = const VerificationMeta(
    'choicesJson',
  );
  @override
  late final GeneratedColumn<String> choicesJson = GeneratedColumn<String>(
    'choices_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _correctIndexMeta = const VerificationMeta(
    'correctIndex',
  );
  @override
  late final GeneratedColumn<int> correctIndex = GeneratedColumn<int>(
    'correct_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _officialExplanationMeta =
      const VerificationMeta('officialExplanation');
  @override
  late final GeneratedColumn<String> officialExplanation =
      GeneratedColumn<String>(
        'official_explanation',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    examType,
    year,
    categoryKey,
    categoryName,
    number,
    numberInt,
    questionText,
    choicesJson,
    correctIndex,
    officialExplanation,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'questions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Question> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('exam_type')) {
      context.handle(
        _examTypeMeta,
        examType.isAcceptableOrUnknown(data['exam_type']!, _examTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_examTypeMeta);
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    } else if (isInserting) {
      context.missing(_yearMeta);
    }
    if (data.containsKey('category_key')) {
      context.handle(
        _categoryKeyMeta,
        categoryKey.isAcceptableOrUnknown(
          data['category_key']!,
          _categoryKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_categoryKeyMeta);
    }
    if (data.containsKey('category_name')) {
      context.handle(
        _categoryNameMeta,
        categoryName.isAcceptableOrUnknown(
          data['category_name']!,
          _categoryNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_categoryNameMeta);
    }
    if (data.containsKey('number')) {
      context.handle(
        _numberMeta,
        number.isAcceptableOrUnknown(data['number']!, _numberMeta),
      );
    } else if (isInserting) {
      context.missing(_numberMeta);
    }
    if (data.containsKey('number_int')) {
      context.handle(
        _numberIntMeta,
        numberInt.isAcceptableOrUnknown(data['number_int']!, _numberIntMeta),
      );
    } else if (isInserting) {
      context.missing(_numberIntMeta);
    }
    if (data.containsKey('question_text')) {
      context.handle(
        _questionTextMeta,
        questionText.isAcceptableOrUnknown(
          data['question_text']!,
          _questionTextMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_questionTextMeta);
    }
    if (data.containsKey('choices_json')) {
      context.handle(
        _choicesJsonMeta,
        choicesJson.isAcceptableOrUnknown(
          data['choices_json']!,
          _choicesJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_choicesJsonMeta);
    }
    if (data.containsKey('correct_index')) {
      context.handle(
        _correctIndexMeta,
        correctIndex.isAcceptableOrUnknown(
          data['correct_index']!,
          _correctIndexMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_correctIndexMeta);
    }
    if (data.containsKey('official_explanation')) {
      context.handle(
        _officialExplanationMeta,
        officialExplanation.isAcceptableOrUnknown(
          data['official_explanation']!,
          _officialExplanationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_officialExplanationMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Question map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Question(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      examType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exam_type'],
      )!,
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}year'],
      )!,
      categoryKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_key'],
      )!,
      categoryName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_name'],
      )!,
      number: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}number'],
      )!,
      numberInt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}number_int'],
      )!,
      questionText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}question_text'],
      )!,
      choicesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}choices_json'],
      )!,
      correctIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}correct_index'],
      )!,
      officialExplanation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}official_explanation'],
      )!,
    );
  }

  @override
  $QuestionsTable createAlias(String alias) {
    return $QuestionsTable(attachedDatabase, alias);
  }
}

class Question extends DataClass implements Insertable<Question> {
  final String id;
  final String examType;
  final String year;
  final String categoryKey;
  final String categoryName;
  final String number;
  final int numberInt;
  final String questionText;
  final String choicesJson;
  final int correctIndex;
  final String officialExplanation;
  const Question({
    required this.id,
    required this.examType,
    required this.year,
    required this.categoryKey,
    required this.categoryName,
    required this.number,
    required this.numberInt,
    required this.questionText,
    required this.choicesJson,
    required this.correctIndex,
    required this.officialExplanation,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['exam_type'] = Variable<String>(examType);
    map['year'] = Variable<String>(year);
    map['category_key'] = Variable<String>(categoryKey);
    map['category_name'] = Variable<String>(categoryName);
    map['number'] = Variable<String>(number);
    map['number_int'] = Variable<int>(numberInt);
    map['question_text'] = Variable<String>(questionText);
    map['choices_json'] = Variable<String>(choicesJson);
    map['correct_index'] = Variable<int>(correctIndex);
    map['official_explanation'] = Variable<String>(officialExplanation);
    return map;
  }

  QuestionsCompanion toCompanion(bool nullToAbsent) {
    return QuestionsCompanion(
      id: Value(id),
      examType: Value(examType),
      year: Value(year),
      categoryKey: Value(categoryKey),
      categoryName: Value(categoryName),
      number: Value(number),
      numberInt: Value(numberInt),
      questionText: Value(questionText),
      choicesJson: Value(choicesJson),
      correctIndex: Value(correctIndex),
      officialExplanation: Value(officialExplanation),
    );
  }

  factory Question.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Question(
      id: serializer.fromJson<String>(json['id']),
      examType: serializer.fromJson<String>(json['examType']),
      year: serializer.fromJson<String>(json['year']),
      categoryKey: serializer.fromJson<String>(json['categoryKey']),
      categoryName: serializer.fromJson<String>(json['categoryName']),
      number: serializer.fromJson<String>(json['number']),
      numberInt: serializer.fromJson<int>(json['numberInt']),
      questionText: serializer.fromJson<String>(json['questionText']),
      choicesJson: serializer.fromJson<String>(json['choicesJson']),
      correctIndex: serializer.fromJson<int>(json['correctIndex']),
      officialExplanation: serializer.fromJson<String>(
        json['officialExplanation'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'examType': serializer.toJson<String>(examType),
      'year': serializer.toJson<String>(year),
      'categoryKey': serializer.toJson<String>(categoryKey),
      'categoryName': serializer.toJson<String>(categoryName),
      'number': serializer.toJson<String>(number),
      'numberInt': serializer.toJson<int>(numberInt),
      'questionText': serializer.toJson<String>(questionText),
      'choicesJson': serializer.toJson<String>(choicesJson),
      'correctIndex': serializer.toJson<int>(correctIndex),
      'officialExplanation': serializer.toJson<String>(officialExplanation),
    };
  }

  Question copyWith({
    String? id,
    String? examType,
    String? year,
    String? categoryKey,
    String? categoryName,
    String? number,
    int? numberInt,
    String? questionText,
    String? choicesJson,
    int? correctIndex,
    String? officialExplanation,
  }) => Question(
    id: id ?? this.id,
    examType: examType ?? this.examType,
    year: year ?? this.year,
    categoryKey: categoryKey ?? this.categoryKey,
    categoryName: categoryName ?? this.categoryName,
    number: number ?? this.number,
    numberInt: numberInt ?? this.numberInt,
    questionText: questionText ?? this.questionText,
    choicesJson: choicesJson ?? this.choicesJson,
    correctIndex: correctIndex ?? this.correctIndex,
    officialExplanation: officialExplanation ?? this.officialExplanation,
  );
  Question copyWithCompanion(QuestionsCompanion data) {
    return Question(
      id: data.id.present ? data.id.value : this.id,
      examType: data.examType.present ? data.examType.value : this.examType,
      year: data.year.present ? data.year.value : this.year,
      categoryKey: data.categoryKey.present
          ? data.categoryKey.value
          : this.categoryKey,
      categoryName: data.categoryName.present
          ? data.categoryName.value
          : this.categoryName,
      number: data.number.present ? data.number.value : this.number,
      numberInt: data.numberInt.present ? data.numberInt.value : this.numberInt,
      questionText: data.questionText.present
          ? data.questionText.value
          : this.questionText,
      choicesJson: data.choicesJson.present
          ? data.choicesJson.value
          : this.choicesJson,
      correctIndex: data.correctIndex.present
          ? data.correctIndex.value
          : this.correctIndex,
      officialExplanation: data.officialExplanation.present
          ? data.officialExplanation.value
          : this.officialExplanation,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Question(')
          ..write('id: $id, ')
          ..write('examType: $examType, ')
          ..write('year: $year, ')
          ..write('categoryKey: $categoryKey, ')
          ..write('categoryName: $categoryName, ')
          ..write('number: $number, ')
          ..write('numberInt: $numberInt, ')
          ..write('questionText: $questionText, ')
          ..write('choicesJson: $choicesJson, ')
          ..write('correctIndex: $correctIndex, ')
          ..write('officialExplanation: $officialExplanation')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    examType,
    year,
    categoryKey,
    categoryName,
    number,
    numberInt,
    questionText,
    choicesJson,
    correctIndex,
    officialExplanation,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Question &&
          other.id == this.id &&
          other.examType == this.examType &&
          other.year == this.year &&
          other.categoryKey == this.categoryKey &&
          other.categoryName == this.categoryName &&
          other.number == this.number &&
          other.numberInt == this.numberInt &&
          other.questionText == this.questionText &&
          other.choicesJson == this.choicesJson &&
          other.correctIndex == this.correctIndex &&
          other.officialExplanation == this.officialExplanation);
}

class QuestionsCompanion extends UpdateCompanion<Question> {
  final Value<String> id;
  final Value<String> examType;
  final Value<String> year;
  final Value<String> categoryKey;
  final Value<String> categoryName;
  final Value<String> number;
  final Value<int> numberInt;
  final Value<String> questionText;
  final Value<String> choicesJson;
  final Value<int> correctIndex;
  final Value<String> officialExplanation;
  final Value<int> rowid;
  const QuestionsCompanion({
    this.id = const Value.absent(),
    this.examType = const Value.absent(),
    this.year = const Value.absent(),
    this.categoryKey = const Value.absent(),
    this.categoryName = const Value.absent(),
    this.number = const Value.absent(),
    this.numberInt = const Value.absent(),
    this.questionText = const Value.absent(),
    this.choicesJson = const Value.absent(),
    this.correctIndex = const Value.absent(),
    this.officialExplanation = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QuestionsCompanion.insert({
    required String id,
    required String examType,
    required String year,
    required String categoryKey,
    required String categoryName,
    required String number,
    required int numberInt,
    required String questionText,
    required String choicesJson,
    required int correctIndex,
    required String officialExplanation,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       examType = Value(examType),
       year = Value(year),
       categoryKey = Value(categoryKey),
       categoryName = Value(categoryName),
       number = Value(number),
       numberInt = Value(numberInt),
       questionText = Value(questionText),
       choicesJson = Value(choicesJson),
       correctIndex = Value(correctIndex),
       officialExplanation = Value(officialExplanation);
  static Insertable<Question> custom({
    Expression<String>? id,
    Expression<String>? examType,
    Expression<String>? year,
    Expression<String>? categoryKey,
    Expression<String>? categoryName,
    Expression<String>? number,
    Expression<int>? numberInt,
    Expression<String>? questionText,
    Expression<String>? choicesJson,
    Expression<int>? correctIndex,
    Expression<String>? officialExplanation,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (examType != null) 'exam_type': examType,
      if (year != null) 'year': year,
      if (categoryKey != null) 'category_key': categoryKey,
      if (categoryName != null) 'category_name': categoryName,
      if (number != null) 'number': number,
      if (numberInt != null) 'number_int': numberInt,
      if (questionText != null) 'question_text': questionText,
      if (choicesJson != null) 'choices_json': choicesJson,
      if (correctIndex != null) 'correct_index': correctIndex,
      if (officialExplanation != null)
        'official_explanation': officialExplanation,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QuestionsCompanion copyWith({
    Value<String>? id,
    Value<String>? examType,
    Value<String>? year,
    Value<String>? categoryKey,
    Value<String>? categoryName,
    Value<String>? number,
    Value<int>? numberInt,
    Value<String>? questionText,
    Value<String>? choicesJson,
    Value<int>? correctIndex,
    Value<String>? officialExplanation,
    Value<int>? rowid,
  }) {
    return QuestionsCompanion(
      id: id ?? this.id,
      examType: examType ?? this.examType,
      year: year ?? this.year,
      categoryKey: categoryKey ?? this.categoryKey,
      categoryName: categoryName ?? this.categoryName,
      number: number ?? this.number,
      numberInt: numberInt ?? this.numberInt,
      questionText: questionText ?? this.questionText,
      choicesJson: choicesJson ?? this.choicesJson,
      correctIndex: correctIndex ?? this.correctIndex,
      officialExplanation: officialExplanation ?? this.officialExplanation,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (examType.present) {
      map['exam_type'] = Variable<String>(examType.value);
    }
    if (year.present) {
      map['year'] = Variable<String>(year.value);
    }
    if (categoryKey.present) {
      map['category_key'] = Variable<String>(categoryKey.value);
    }
    if (categoryName.present) {
      map['category_name'] = Variable<String>(categoryName.value);
    }
    if (number.present) {
      map['number'] = Variable<String>(number.value);
    }
    if (numberInt.present) {
      map['number_int'] = Variable<int>(numberInt.value);
    }
    if (questionText.present) {
      map['question_text'] = Variable<String>(questionText.value);
    }
    if (choicesJson.present) {
      map['choices_json'] = Variable<String>(choicesJson.value);
    }
    if (correctIndex.present) {
      map['correct_index'] = Variable<int>(correctIndex.value);
    }
    if (officialExplanation.present) {
      map['official_explanation'] = Variable<String>(officialExplanation.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuestionsCompanion(')
          ..write('id: $id, ')
          ..write('examType: $examType, ')
          ..write('year: $year, ')
          ..write('categoryKey: $categoryKey, ')
          ..write('categoryName: $categoryName, ')
          ..write('number: $number, ')
          ..write('numberInt: $numberInt, ')
          ..write('questionText: $questionText, ')
          ..write('choicesJson: $choicesJson, ')
          ..write('correctIndex: $correctIndex, ')
          ..write('officialExplanation: $officialExplanation, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExamSessionsTable extends ExamSessions
    with TableInfo<$ExamSessionsTable, ExamSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExamSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<String> year = GeneratedColumn<String>(
    'year',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _examTypeMeta = const VerificationMeta(
    'examType',
  );
  @override
  late final GeneratedColumn<String> examType = GeneratedColumn<String>(
    'exam_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalQMeta = const VerificationMeta('totalQ');
  @override
  late final GeneratedColumn<int> totalQ = GeneratedColumn<int>(
    'total_q',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isLatestMeta = const VerificationMeta(
    'isLatest',
  );
  @override
  late final GeneratedColumn<bool> isLatest = GeneratedColumn<bool>(
    'is_latest',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_latest" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('not_started'),
  );
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumn<int> day = GeneratedColumn<int>(
    'day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _attemptMeta = const VerificationMeta(
    'attempt',
  );
  @override
  late final GeneratedColumn<int> attempt = GeneratedColumn<int>(
    'attempt',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _avgScoreMeta = const VerificationMeta(
    'avgScore',
  );
  @override
  late final GeneratedColumn<int> avgScore = GeneratedColumn<int>(
    'avg_score',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hanamaruDaysMeta = const VerificationMeta(
    'hanamaruDays',
  );
  @override
  late final GeneratedColumn<int> hanamaruDays = GeneratedColumn<int>(
    'hanamaru_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _weekCompleteMeta = const VerificationMeta(
    'weekComplete',
  );
  @override
  late final GeneratedColumn<bool> weekComplete = GeneratedColumn<bool>(
    'week_complete',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("week_complete" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _dayQuestionIdsJsonMeta =
      const VerificationMeta('dayQuestionIdsJson');
  @override
  late final GeneratedColumn<String> dayQuestionIdsJson =
      GeneratedColumn<String>(
        'day_question_ids_json',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _reviewQuestionIdsJsonMeta =
      const VerificationMeta('reviewQuestionIdsJson');
  @override
  late final GeneratedColumn<String> reviewQuestionIdsJson =
      GeneratedColumn<String>(
        'review_question_ids_json',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _dayStartedAtMeta = const VerificationMeta(
    'dayStartedAt',
  );
  @override
  late final GeneratedColumn<DateTime> dayStartedAt = GeneratedColumn<DateTime>(
    'day_started_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    year,
    label,
    examType,
    totalQ,
    isLatest,
    sortOrder,
    status,
    day,
    attempt,
    avgScore,
    hanamaruDays,
    weekComplete,
    dayQuestionIdsJson,
    reviewQuestionIdsJson,
    dayStartedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exam_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExamSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    } else if (isInserting) {
      context.missing(_yearMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('exam_type')) {
      context.handle(
        _examTypeMeta,
        examType.isAcceptableOrUnknown(data['exam_type']!, _examTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_examTypeMeta);
    }
    if (data.containsKey('total_q')) {
      context.handle(
        _totalQMeta,
        totalQ.isAcceptableOrUnknown(data['total_q']!, _totalQMeta),
      );
    } else if (isInserting) {
      context.missing(_totalQMeta);
    }
    if (data.containsKey('is_latest')) {
      context.handle(
        _isLatestMeta,
        isLatest.isAcceptableOrUnknown(data['is_latest']!, _isLatestMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('day')) {
      context.handle(
        _dayMeta,
        day.isAcceptableOrUnknown(data['day']!, _dayMeta),
      );
    }
    if (data.containsKey('attempt')) {
      context.handle(
        _attemptMeta,
        attempt.isAcceptableOrUnknown(data['attempt']!, _attemptMeta),
      );
    }
    if (data.containsKey('avg_score')) {
      context.handle(
        _avgScoreMeta,
        avgScore.isAcceptableOrUnknown(data['avg_score']!, _avgScoreMeta),
      );
    }
    if (data.containsKey('hanamaru_days')) {
      context.handle(
        _hanamaruDaysMeta,
        hanamaruDays.isAcceptableOrUnknown(
          data['hanamaru_days']!,
          _hanamaruDaysMeta,
        ),
      );
    }
    if (data.containsKey('week_complete')) {
      context.handle(
        _weekCompleteMeta,
        weekComplete.isAcceptableOrUnknown(
          data['week_complete']!,
          _weekCompleteMeta,
        ),
      );
    }
    if (data.containsKey('day_question_ids_json')) {
      context.handle(
        _dayQuestionIdsJsonMeta,
        dayQuestionIdsJson.isAcceptableOrUnknown(
          data['day_question_ids_json']!,
          _dayQuestionIdsJsonMeta,
        ),
      );
    }
    if (data.containsKey('review_question_ids_json')) {
      context.handle(
        _reviewQuestionIdsJsonMeta,
        reviewQuestionIdsJson.isAcceptableOrUnknown(
          data['review_question_ids_json']!,
          _reviewQuestionIdsJsonMeta,
        ),
      );
    }
    if (data.containsKey('day_started_at')) {
      context.handle(
        _dayStartedAtMeta,
        dayStartedAt.isAcceptableOrUnknown(
          data['day_started_at']!,
          _dayStartedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExamSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExamSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}year'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      examType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exam_type'],
      )!,
      totalQ: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_q'],
      )!,
      isLatest: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_latest'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      day: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day'],
      )!,
      attempt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempt'],
      )!,
      avgScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}avg_score'],
      ),
      hanamaruDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hanamaru_days'],
      )!,
      weekComplete: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}week_complete'],
      )!,
      dayQuestionIdsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day_question_ids_json'],
      ),
      reviewQuestionIdsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}review_question_ids_json'],
      ),
      dayStartedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}day_started_at'],
      ),
    );
  }

  @override
  $ExamSessionsTable createAlias(String alias) {
    return $ExamSessionsTable(attachedDatabase, alias);
  }
}

class ExamSession extends DataClass implements Insertable<ExamSession> {
  final String id;
  final String year;
  final String label;
  final String examType;
  final int totalQ;
  final bool isLatest;
  final int sortOrder;
  final String status;
  final int day;
  final int attempt;
  final int? avgScore;
  final int hanamaruDays;
  final bool weekComplete;
  final String? dayQuestionIdsJson;
  final String? reviewQuestionIdsJson;
  final DateTime? dayStartedAt;
  const ExamSession({
    required this.id,
    required this.year,
    required this.label,
    required this.examType,
    required this.totalQ,
    required this.isLatest,
    required this.sortOrder,
    required this.status,
    required this.day,
    required this.attempt,
    this.avgScore,
    required this.hanamaruDays,
    required this.weekComplete,
    this.dayQuestionIdsJson,
    this.reviewQuestionIdsJson,
    this.dayStartedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['year'] = Variable<String>(year);
    map['label'] = Variable<String>(label);
    map['exam_type'] = Variable<String>(examType);
    map['total_q'] = Variable<int>(totalQ);
    map['is_latest'] = Variable<bool>(isLatest);
    map['sort_order'] = Variable<int>(sortOrder);
    map['status'] = Variable<String>(status);
    map['day'] = Variable<int>(day);
    map['attempt'] = Variable<int>(attempt);
    if (!nullToAbsent || avgScore != null) {
      map['avg_score'] = Variable<int>(avgScore);
    }
    map['hanamaru_days'] = Variable<int>(hanamaruDays);
    map['week_complete'] = Variable<bool>(weekComplete);
    if (!nullToAbsent || dayQuestionIdsJson != null) {
      map['day_question_ids_json'] = Variable<String>(dayQuestionIdsJson);
    }
    if (!nullToAbsent || reviewQuestionIdsJson != null) {
      map['review_question_ids_json'] = Variable<String>(reviewQuestionIdsJson);
    }
    if (!nullToAbsent || dayStartedAt != null) {
      map['day_started_at'] = Variable<DateTime>(dayStartedAt);
    }
    return map;
  }

  ExamSessionsCompanion toCompanion(bool nullToAbsent) {
    return ExamSessionsCompanion(
      id: Value(id),
      year: Value(year),
      label: Value(label),
      examType: Value(examType),
      totalQ: Value(totalQ),
      isLatest: Value(isLatest),
      sortOrder: Value(sortOrder),
      status: Value(status),
      day: Value(day),
      attempt: Value(attempt),
      avgScore: avgScore == null && nullToAbsent
          ? const Value.absent()
          : Value(avgScore),
      hanamaruDays: Value(hanamaruDays),
      weekComplete: Value(weekComplete),
      dayQuestionIdsJson: dayQuestionIdsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(dayQuestionIdsJson),
      reviewQuestionIdsJson: reviewQuestionIdsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(reviewQuestionIdsJson),
      dayStartedAt: dayStartedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(dayStartedAt),
    );
  }

  factory ExamSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExamSession(
      id: serializer.fromJson<String>(json['id']),
      year: serializer.fromJson<String>(json['year']),
      label: serializer.fromJson<String>(json['label']),
      examType: serializer.fromJson<String>(json['examType']),
      totalQ: serializer.fromJson<int>(json['totalQ']),
      isLatest: serializer.fromJson<bool>(json['isLatest']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      status: serializer.fromJson<String>(json['status']),
      day: serializer.fromJson<int>(json['day']),
      attempt: serializer.fromJson<int>(json['attempt']),
      avgScore: serializer.fromJson<int?>(json['avgScore']),
      hanamaruDays: serializer.fromJson<int>(json['hanamaruDays']),
      weekComplete: serializer.fromJson<bool>(json['weekComplete']),
      dayQuestionIdsJson: serializer.fromJson<String?>(
        json['dayQuestionIdsJson'],
      ),
      reviewQuestionIdsJson: serializer.fromJson<String?>(
        json['reviewQuestionIdsJson'],
      ),
      dayStartedAt: serializer.fromJson<DateTime?>(json['dayStartedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'year': serializer.toJson<String>(year),
      'label': serializer.toJson<String>(label),
      'examType': serializer.toJson<String>(examType),
      'totalQ': serializer.toJson<int>(totalQ),
      'isLatest': serializer.toJson<bool>(isLatest),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'status': serializer.toJson<String>(status),
      'day': serializer.toJson<int>(day),
      'attempt': serializer.toJson<int>(attempt),
      'avgScore': serializer.toJson<int?>(avgScore),
      'hanamaruDays': serializer.toJson<int>(hanamaruDays),
      'weekComplete': serializer.toJson<bool>(weekComplete),
      'dayQuestionIdsJson': serializer.toJson<String?>(dayQuestionIdsJson),
      'reviewQuestionIdsJson': serializer.toJson<String?>(
        reviewQuestionIdsJson,
      ),
      'dayStartedAt': serializer.toJson<DateTime?>(dayStartedAt),
    };
  }

  ExamSession copyWith({
    String? id,
    String? year,
    String? label,
    String? examType,
    int? totalQ,
    bool? isLatest,
    int? sortOrder,
    String? status,
    int? day,
    int? attempt,
    Value<int?> avgScore = const Value.absent(),
    int? hanamaruDays,
    bool? weekComplete,
    Value<String?> dayQuestionIdsJson = const Value.absent(),
    Value<String?> reviewQuestionIdsJson = const Value.absent(),
    Value<DateTime?> dayStartedAt = const Value.absent(),
  }) => ExamSession(
    id: id ?? this.id,
    year: year ?? this.year,
    label: label ?? this.label,
    examType: examType ?? this.examType,
    totalQ: totalQ ?? this.totalQ,
    isLatest: isLatest ?? this.isLatest,
    sortOrder: sortOrder ?? this.sortOrder,
    status: status ?? this.status,
    day: day ?? this.day,
    attempt: attempt ?? this.attempt,
    avgScore: avgScore.present ? avgScore.value : this.avgScore,
    hanamaruDays: hanamaruDays ?? this.hanamaruDays,
    weekComplete: weekComplete ?? this.weekComplete,
    dayQuestionIdsJson: dayQuestionIdsJson.present
        ? dayQuestionIdsJson.value
        : this.dayQuestionIdsJson,
    reviewQuestionIdsJson: reviewQuestionIdsJson.present
        ? reviewQuestionIdsJson.value
        : this.reviewQuestionIdsJson,
    dayStartedAt: dayStartedAt.present ? dayStartedAt.value : this.dayStartedAt,
  );
  ExamSession copyWithCompanion(ExamSessionsCompanion data) {
    return ExamSession(
      id: data.id.present ? data.id.value : this.id,
      year: data.year.present ? data.year.value : this.year,
      label: data.label.present ? data.label.value : this.label,
      examType: data.examType.present ? data.examType.value : this.examType,
      totalQ: data.totalQ.present ? data.totalQ.value : this.totalQ,
      isLatest: data.isLatest.present ? data.isLatest.value : this.isLatest,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      status: data.status.present ? data.status.value : this.status,
      day: data.day.present ? data.day.value : this.day,
      attempt: data.attempt.present ? data.attempt.value : this.attempt,
      avgScore: data.avgScore.present ? data.avgScore.value : this.avgScore,
      hanamaruDays: data.hanamaruDays.present
          ? data.hanamaruDays.value
          : this.hanamaruDays,
      weekComplete: data.weekComplete.present
          ? data.weekComplete.value
          : this.weekComplete,
      dayQuestionIdsJson: data.dayQuestionIdsJson.present
          ? data.dayQuestionIdsJson.value
          : this.dayQuestionIdsJson,
      reviewQuestionIdsJson: data.reviewQuestionIdsJson.present
          ? data.reviewQuestionIdsJson.value
          : this.reviewQuestionIdsJson,
      dayStartedAt: data.dayStartedAt.present
          ? data.dayStartedAt.value
          : this.dayStartedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExamSession(')
          ..write('id: $id, ')
          ..write('year: $year, ')
          ..write('label: $label, ')
          ..write('examType: $examType, ')
          ..write('totalQ: $totalQ, ')
          ..write('isLatest: $isLatest, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('status: $status, ')
          ..write('day: $day, ')
          ..write('attempt: $attempt, ')
          ..write('avgScore: $avgScore, ')
          ..write('hanamaruDays: $hanamaruDays, ')
          ..write('weekComplete: $weekComplete, ')
          ..write('dayQuestionIdsJson: $dayQuestionIdsJson, ')
          ..write('reviewQuestionIdsJson: $reviewQuestionIdsJson, ')
          ..write('dayStartedAt: $dayStartedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    year,
    label,
    examType,
    totalQ,
    isLatest,
    sortOrder,
    status,
    day,
    attempt,
    avgScore,
    hanamaruDays,
    weekComplete,
    dayQuestionIdsJson,
    reviewQuestionIdsJson,
    dayStartedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExamSession &&
          other.id == this.id &&
          other.year == this.year &&
          other.label == this.label &&
          other.examType == this.examType &&
          other.totalQ == this.totalQ &&
          other.isLatest == this.isLatest &&
          other.sortOrder == this.sortOrder &&
          other.status == this.status &&
          other.day == this.day &&
          other.attempt == this.attempt &&
          other.avgScore == this.avgScore &&
          other.hanamaruDays == this.hanamaruDays &&
          other.weekComplete == this.weekComplete &&
          other.dayQuestionIdsJson == this.dayQuestionIdsJson &&
          other.reviewQuestionIdsJson == this.reviewQuestionIdsJson &&
          other.dayStartedAt == this.dayStartedAt);
}

class ExamSessionsCompanion extends UpdateCompanion<ExamSession> {
  final Value<String> id;
  final Value<String> year;
  final Value<String> label;
  final Value<String> examType;
  final Value<int> totalQ;
  final Value<bool> isLatest;
  final Value<int> sortOrder;
  final Value<String> status;
  final Value<int> day;
  final Value<int> attempt;
  final Value<int?> avgScore;
  final Value<int> hanamaruDays;
  final Value<bool> weekComplete;
  final Value<String?> dayQuestionIdsJson;
  final Value<String?> reviewQuestionIdsJson;
  final Value<DateTime?> dayStartedAt;
  final Value<int> rowid;
  const ExamSessionsCompanion({
    this.id = const Value.absent(),
    this.year = const Value.absent(),
    this.label = const Value.absent(),
    this.examType = const Value.absent(),
    this.totalQ = const Value.absent(),
    this.isLatest = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.status = const Value.absent(),
    this.day = const Value.absent(),
    this.attempt = const Value.absent(),
    this.avgScore = const Value.absent(),
    this.hanamaruDays = const Value.absent(),
    this.weekComplete = const Value.absent(),
    this.dayQuestionIdsJson = const Value.absent(),
    this.reviewQuestionIdsJson = const Value.absent(),
    this.dayStartedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExamSessionsCompanion.insert({
    required String id,
    required String year,
    required String label,
    required String examType,
    required int totalQ,
    this.isLatest = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.status = const Value.absent(),
    this.day = const Value.absent(),
    this.attempt = const Value.absent(),
    this.avgScore = const Value.absent(),
    this.hanamaruDays = const Value.absent(),
    this.weekComplete = const Value.absent(),
    this.dayQuestionIdsJson = const Value.absent(),
    this.reviewQuestionIdsJson = const Value.absent(),
    this.dayStartedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       year = Value(year),
       label = Value(label),
       examType = Value(examType),
       totalQ = Value(totalQ);
  static Insertable<ExamSession> custom({
    Expression<String>? id,
    Expression<String>? year,
    Expression<String>? label,
    Expression<String>? examType,
    Expression<int>? totalQ,
    Expression<bool>? isLatest,
    Expression<int>? sortOrder,
    Expression<String>? status,
    Expression<int>? day,
    Expression<int>? attempt,
    Expression<int>? avgScore,
    Expression<int>? hanamaruDays,
    Expression<bool>? weekComplete,
    Expression<String>? dayQuestionIdsJson,
    Expression<String>? reviewQuestionIdsJson,
    Expression<DateTime>? dayStartedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (year != null) 'year': year,
      if (label != null) 'label': label,
      if (examType != null) 'exam_type': examType,
      if (totalQ != null) 'total_q': totalQ,
      if (isLatest != null) 'is_latest': isLatest,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (status != null) 'status': status,
      if (day != null) 'day': day,
      if (attempt != null) 'attempt': attempt,
      if (avgScore != null) 'avg_score': avgScore,
      if (hanamaruDays != null) 'hanamaru_days': hanamaruDays,
      if (weekComplete != null) 'week_complete': weekComplete,
      if (dayQuestionIdsJson != null)
        'day_question_ids_json': dayQuestionIdsJson,
      if (reviewQuestionIdsJson != null)
        'review_question_ids_json': reviewQuestionIdsJson,
      if (dayStartedAt != null) 'day_started_at': dayStartedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExamSessionsCompanion copyWith({
    Value<String>? id,
    Value<String>? year,
    Value<String>? label,
    Value<String>? examType,
    Value<int>? totalQ,
    Value<bool>? isLatest,
    Value<int>? sortOrder,
    Value<String>? status,
    Value<int>? day,
    Value<int>? attempt,
    Value<int?>? avgScore,
    Value<int>? hanamaruDays,
    Value<bool>? weekComplete,
    Value<String?>? dayQuestionIdsJson,
    Value<String?>? reviewQuestionIdsJson,
    Value<DateTime?>? dayStartedAt,
    Value<int>? rowid,
  }) {
    return ExamSessionsCompanion(
      id: id ?? this.id,
      year: year ?? this.year,
      label: label ?? this.label,
      examType: examType ?? this.examType,
      totalQ: totalQ ?? this.totalQ,
      isLatest: isLatest ?? this.isLatest,
      sortOrder: sortOrder ?? this.sortOrder,
      status: status ?? this.status,
      day: day ?? this.day,
      attempt: attempt ?? this.attempt,
      avgScore: avgScore ?? this.avgScore,
      hanamaruDays: hanamaruDays ?? this.hanamaruDays,
      weekComplete: weekComplete ?? this.weekComplete,
      dayQuestionIdsJson: dayQuestionIdsJson ?? this.dayQuestionIdsJson,
      reviewQuestionIdsJson:
          reviewQuestionIdsJson ?? this.reviewQuestionIdsJson,
      dayStartedAt: dayStartedAt ?? this.dayStartedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (year.present) {
      map['year'] = Variable<String>(year.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (examType.present) {
      map['exam_type'] = Variable<String>(examType.value);
    }
    if (totalQ.present) {
      map['total_q'] = Variable<int>(totalQ.value);
    }
    if (isLatest.present) {
      map['is_latest'] = Variable<bool>(isLatest.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (day.present) {
      map['day'] = Variable<int>(day.value);
    }
    if (attempt.present) {
      map['attempt'] = Variable<int>(attempt.value);
    }
    if (avgScore.present) {
      map['avg_score'] = Variable<int>(avgScore.value);
    }
    if (hanamaruDays.present) {
      map['hanamaru_days'] = Variable<int>(hanamaruDays.value);
    }
    if (weekComplete.present) {
      map['week_complete'] = Variable<bool>(weekComplete.value);
    }
    if (dayQuestionIdsJson.present) {
      map['day_question_ids_json'] = Variable<String>(dayQuestionIdsJson.value);
    }
    if (reviewQuestionIdsJson.present) {
      map['review_question_ids_json'] = Variable<String>(
        reviewQuestionIdsJson.value,
      );
    }
    if (dayStartedAt.present) {
      map['day_started_at'] = Variable<DateTime>(dayStartedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExamSessionsCompanion(')
          ..write('id: $id, ')
          ..write('year: $year, ')
          ..write('label: $label, ')
          ..write('examType: $examType, ')
          ..write('totalQ: $totalQ, ')
          ..write('isLatest: $isLatest, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('status: $status, ')
          ..write('day: $day, ')
          ..write('attempt: $attempt, ')
          ..write('avgScore: $avgScore, ')
          ..write('hanamaruDays: $hanamaruDays, ')
          ..write('weekComplete: $weekComplete, ')
          ..write('dayQuestionIdsJson: $dayQuestionIdsJson, ')
          ..write('reviewQuestionIdsJson: $reviewQuestionIdsJson, ')
          ..write('dayStartedAt: $dayStartedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DailyProgressTable extends DailyProgress
    with TableInfo<$DailyProgressTable, DailyProgressData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumn<int> day = GeneratedColumn<int>(
    'day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _attemptMeta = const VerificationMeta(
    'attempt',
  );
  @override
  late final GeneratedColumn<int> attempt = GeneratedColumn<int>(
    'attempt',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<int> score = GeneratedColumn<int>(
    'score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalQuestionsMeta = const VerificationMeta(
    'totalQuestions',
  );
  @override
  late final GeneratedColumn<int> totalQuestions = GeneratedColumn<int>(
    'total_questions',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hanamaruMeta = const VerificationMeta(
    'hanamaru',
  );
  @override
  late final GeneratedColumn<bool> hanamaru = GeneratedColumn<bool>(
    'hanamaru',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("hanamaru" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    day,
    attempt,
    score,
    totalQuestions,
    hanamaru,
    completedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_progress';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyProgressData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('day')) {
      context.handle(
        _dayMeta,
        day.isAcceptableOrUnknown(data['day']!, _dayMeta),
      );
    } else if (isInserting) {
      context.missing(_dayMeta);
    }
    if (data.containsKey('attempt')) {
      context.handle(
        _attemptMeta,
        attempt.isAcceptableOrUnknown(data['attempt']!, _attemptMeta),
      );
    } else if (isInserting) {
      context.missing(_attemptMeta);
    }
    if (data.containsKey('score')) {
      context.handle(
        _scoreMeta,
        score.isAcceptableOrUnknown(data['score']!, _scoreMeta),
      );
    } else if (isInserting) {
      context.missing(_scoreMeta);
    }
    if (data.containsKey('total_questions')) {
      context.handle(
        _totalQuestionsMeta,
        totalQuestions.isAcceptableOrUnknown(
          data['total_questions']!,
          _totalQuestionsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalQuestionsMeta);
    }
    if (data.containsKey('hanamaru')) {
      context.handle(
        _hanamaruMeta,
        hanamaru.isAcceptableOrUnknown(data['hanamaru']!, _hanamaruMeta),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_completedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DailyProgressData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyProgressData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      day: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day'],
      )!,
      attempt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempt'],
      )!,
      score: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}score'],
      )!,
      totalQuestions: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_questions'],
      )!,
      hanamaru: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}hanamaru'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      )!,
    );
  }

  @override
  $DailyProgressTable createAlias(String alias) {
    return $DailyProgressTable(attachedDatabase, alias);
  }
}

class DailyProgressData extends DataClass
    implements Insertable<DailyProgressData> {
  final int id;
  final String sessionId;
  final int day;
  final int attempt;
  final int score;
  final int totalQuestions;
  final bool hanamaru;
  final DateTime completedAt;
  const DailyProgressData({
    required this.id,
    required this.sessionId,
    required this.day,
    required this.attempt,
    required this.score,
    required this.totalQuestions,
    required this.hanamaru,
    required this.completedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_id'] = Variable<String>(sessionId);
    map['day'] = Variable<int>(day);
    map['attempt'] = Variable<int>(attempt);
    map['score'] = Variable<int>(score);
    map['total_questions'] = Variable<int>(totalQuestions);
    map['hanamaru'] = Variable<bool>(hanamaru);
    map['completed_at'] = Variable<DateTime>(completedAt);
    return map;
  }

  DailyProgressCompanion toCompanion(bool nullToAbsent) {
    return DailyProgressCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      day: Value(day),
      attempt: Value(attempt),
      score: Value(score),
      totalQuestions: Value(totalQuestions),
      hanamaru: Value(hanamaru),
      completedAt: Value(completedAt),
    );
  }

  factory DailyProgressData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyProgressData(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      day: serializer.fromJson<int>(json['day']),
      attempt: serializer.fromJson<int>(json['attempt']),
      score: serializer.fromJson<int>(json['score']),
      totalQuestions: serializer.fromJson<int>(json['totalQuestions']),
      hanamaru: serializer.fromJson<bool>(json['hanamaru']),
      completedAt: serializer.fromJson<DateTime>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<String>(sessionId),
      'day': serializer.toJson<int>(day),
      'attempt': serializer.toJson<int>(attempt),
      'score': serializer.toJson<int>(score),
      'totalQuestions': serializer.toJson<int>(totalQuestions),
      'hanamaru': serializer.toJson<bool>(hanamaru),
      'completedAt': serializer.toJson<DateTime>(completedAt),
    };
  }

  DailyProgressData copyWith({
    int? id,
    String? sessionId,
    int? day,
    int? attempt,
    int? score,
    int? totalQuestions,
    bool? hanamaru,
    DateTime? completedAt,
  }) => DailyProgressData(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    day: day ?? this.day,
    attempt: attempt ?? this.attempt,
    score: score ?? this.score,
    totalQuestions: totalQuestions ?? this.totalQuestions,
    hanamaru: hanamaru ?? this.hanamaru,
    completedAt: completedAt ?? this.completedAt,
  );
  DailyProgressData copyWithCompanion(DailyProgressCompanion data) {
    return DailyProgressData(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      day: data.day.present ? data.day.value : this.day,
      attempt: data.attempt.present ? data.attempt.value : this.attempt,
      score: data.score.present ? data.score.value : this.score,
      totalQuestions: data.totalQuestions.present
          ? data.totalQuestions.value
          : this.totalQuestions,
      hanamaru: data.hanamaru.present ? data.hanamaru.value : this.hanamaru,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyProgressData(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('day: $day, ')
          ..write('attempt: $attempt, ')
          ..write('score: $score, ')
          ..write('totalQuestions: $totalQuestions, ')
          ..write('hanamaru: $hanamaru, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sessionId,
    day,
    attempt,
    score,
    totalQuestions,
    hanamaru,
    completedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyProgressData &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.day == this.day &&
          other.attempt == this.attempt &&
          other.score == this.score &&
          other.totalQuestions == this.totalQuestions &&
          other.hanamaru == this.hanamaru &&
          other.completedAt == this.completedAt);
}

class DailyProgressCompanion extends UpdateCompanion<DailyProgressData> {
  final Value<int> id;
  final Value<String> sessionId;
  final Value<int> day;
  final Value<int> attempt;
  final Value<int> score;
  final Value<int> totalQuestions;
  final Value<bool> hanamaru;
  final Value<DateTime> completedAt;
  const DailyProgressCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.day = const Value.absent(),
    this.attempt = const Value.absent(),
    this.score = const Value.absent(),
    this.totalQuestions = const Value.absent(),
    this.hanamaru = const Value.absent(),
    this.completedAt = const Value.absent(),
  });
  DailyProgressCompanion.insert({
    this.id = const Value.absent(),
    required String sessionId,
    required int day,
    required int attempt,
    required int score,
    required int totalQuestions,
    this.hanamaru = const Value.absent(),
    required DateTime completedAt,
  }) : sessionId = Value(sessionId),
       day = Value(day),
       attempt = Value(attempt),
       score = Value(score),
       totalQuestions = Value(totalQuestions),
       completedAt = Value(completedAt);
  static Insertable<DailyProgressData> custom({
    Expression<int>? id,
    Expression<String>? sessionId,
    Expression<int>? day,
    Expression<int>? attempt,
    Expression<int>? score,
    Expression<int>? totalQuestions,
    Expression<bool>? hanamaru,
    Expression<DateTime>? completedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (day != null) 'day': day,
      if (attempt != null) 'attempt': attempt,
      if (score != null) 'score': score,
      if (totalQuestions != null) 'total_questions': totalQuestions,
      if (hanamaru != null) 'hanamaru': hanamaru,
      if (completedAt != null) 'completed_at': completedAt,
    });
  }

  DailyProgressCompanion copyWith({
    Value<int>? id,
    Value<String>? sessionId,
    Value<int>? day,
    Value<int>? attempt,
    Value<int>? score,
    Value<int>? totalQuestions,
    Value<bool>? hanamaru,
    Value<DateTime>? completedAt,
  }) {
    return DailyProgressCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      day: day ?? this.day,
      attempt: attempt ?? this.attempt,
      score: score ?? this.score,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      hanamaru: hanamaru ?? this.hanamaru,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (day.present) {
      map['day'] = Variable<int>(day.value);
    }
    if (attempt.present) {
      map['attempt'] = Variable<int>(attempt.value);
    }
    if (score.present) {
      map['score'] = Variable<int>(score.value);
    }
    if (totalQuestions.present) {
      map['total_questions'] = Variable<int>(totalQuestions.value);
    }
    if (hanamaru.present) {
      map['hanamaru'] = Variable<bool>(hanamaru.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyProgressCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('day: $day, ')
          ..write('attempt: $attempt, ')
          ..write('score: $score, ')
          ..write('totalQuestions: $totalQuestions, ')
          ..write('hanamaru: $hanamaru, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }
}

class $AnswerLogTable extends AnswerLog
    with TableInfo<$AnswerLogTable, AnswerLogData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AnswerLogTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _questionIdMeta = const VerificationMeta(
    'questionId',
  );
  @override
  late final GeneratedColumn<String> questionId = GeneratedColumn<String>(
    'question_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumn<int> day = GeneratedColumn<int>(
    'day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _attemptMeta = const VerificationMeta(
    'attempt',
  );
  @override
  late final GeneratedColumn<int> attempt = GeneratedColumn<int>(
    'attempt',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _chosenMeta = const VerificationMeta('chosen');
  @override
  late final GeneratedColumn<int> chosen = GeneratedColumn<int>(
    'chosen',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _correctMeta = const VerificationMeta(
    'correct',
  );
  @override
  late final GeneratedColumn<bool> correct = GeneratedColumn<bool>(
    'correct',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("correct" IN (0, 1))',
    ),
  );
  static const VerificationMeta _answeredAtMeta = const VerificationMeta(
    'answeredAt',
  );
  @override
  late final GeneratedColumn<DateTime> answeredAt = GeneratedColumn<DateTime>(
    'answered_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    questionId,
    sessionId,
    day,
    attempt,
    chosen,
    correct,
    answeredAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'answer_log';
  @override
  VerificationContext validateIntegrity(
    Insertable<AnswerLogData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('question_id')) {
      context.handle(
        _questionIdMeta,
        questionId.isAcceptableOrUnknown(data['question_id']!, _questionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_questionIdMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('day')) {
      context.handle(
        _dayMeta,
        day.isAcceptableOrUnknown(data['day']!, _dayMeta),
      );
    } else if (isInserting) {
      context.missing(_dayMeta);
    }
    if (data.containsKey('attempt')) {
      context.handle(
        _attemptMeta,
        attempt.isAcceptableOrUnknown(data['attempt']!, _attemptMeta),
      );
    } else if (isInserting) {
      context.missing(_attemptMeta);
    }
    if (data.containsKey('chosen')) {
      context.handle(
        _chosenMeta,
        chosen.isAcceptableOrUnknown(data['chosen']!, _chosenMeta),
      );
    } else if (isInserting) {
      context.missing(_chosenMeta);
    }
    if (data.containsKey('correct')) {
      context.handle(
        _correctMeta,
        correct.isAcceptableOrUnknown(data['correct']!, _correctMeta),
      );
    } else if (isInserting) {
      context.missing(_correctMeta);
    }
    if (data.containsKey('answered_at')) {
      context.handle(
        _answeredAtMeta,
        answeredAt.isAcceptableOrUnknown(data['answered_at']!, _answeredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_answeredAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AnswerLogData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AnswerLogData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      questionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}question_id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      day: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day'],
      )!,
      attempt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempt'],
      )!,
      chosen: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}chosen'],
      )!,
      correct: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}correct'],
      )!,
      answeredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}answered_at'],
      )!,
    );
  }

  @override
  $AnswerLogTable createAlias(String alias) {
    return $AnswerLogTable(attachedDatabase, alias);
  }
}

class AnswerLogData extends DataClass implements Insertable<AnswerLogData> {
  final int id;
  final String questionId;
  final String sessionId;
  final int day;
  final int attempt;
  final int chosen;
  final bool correct;
  final DateTime answeredAt;
  const AnswerLogData({
    required this.id,
    required this.questionId,
    required this.sessionId,
    required this.day,
    required this.attempt,
    required this.chosen,
    required this.correct,
    required this.answeredAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['question_id'] = Variable<String>(questionId);
    map['session_id'] = Variable<String>(sessionId);
    map['day'] = Variable<int>(day);
    map['attempt'] = Variable<int>(attempt);
    map['chosen'] = Variable<int>(chosen);
    map['correct'] = Variable<bool>(correct);
    map['answered_at'] = Variable<DateTime>(answeredAt);
    return map;
  }

  AnswerLogCompanion toCompanion(bool nullToAbsent) {
    return AnswerLogCompanion(
      id: Value(id),
      questionId: Value(questionId),
      sessionId: Value(sessionId),
      day: Value(day),
      attempt: Value(attempt),
      chosen: Value(chosen),
      correct: Value(correct),
      answeredAt: Value(answeredAt),
    );
  }

  factory AnswerLogData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AnswerLogData(
      id: serializer.fromJson<int>(json['id']),
      questionId: serializer.fromJson<String>(json['questionId']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      day: serializer.fromJson<int>(json['day']),
      attempt: serializer.fromJson<int>(json['attempt']),
      chosen: serializer.fromJson<int>(json['chosen']),
      correct: serializer.fromJson<bool>(json['correct']),
      answeredAt: serializer.fromJson<DateTime>(json['answeredAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'questionId': serializer.toJson<String>(questionId),
      'sessionId': serializer.toJson<String>(sessionId),
      'day': serializer.toJson<int>(day),
      'attempt': serializer.toJson<int>(attempt),
      'chosen': serializer.toJson<int>(chosen),
      'correct': serializer.toJson<bool>(correct),
      'answeredAt': serializer.toJson<DateTime>(answeredAt),
    };
  }

  AnswerLogData copyWith({
    int? id,
    String? questionId,
    String? sessionId,
    int? day,
    int? attempt,
    int? chosen,
    bool? correct,
    DateTime? answeredAt,
  }) => AnswerLogData(
    id: id ?? this.id,
    questionId: questionId ?? this.questionId,
    sessionId: sessionId ?? this.sessionId,
    day: day ?? this.day,
    attempt: attempt ?? this.attempt,
    chosen: chosen ?? this.chosen,
    correct: correct ?? this.correct,
    answeredAt: answeredAt ?? this.answeredAt,
  );
  AnswerLogData copyWithCompanion(AnswerLogCompanion data) {
    return AnswerLogData(
      id: data.id.present ? data.id.value : this.id,
      questionId: data.questionId.present
          ? data.questionId.value
          : this.questionId,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      day: data.day.present ? data.day.value : this.day,
      attempt: data.attempt.present ? data.attempt.value : this.attempt,
      chosen: data.chosen.present ? data.chosen.value : this.chosen,
      correct: data.correct.present ? data.correct.value : this.correct,
      answeredAt: data.answeredAt.present
          ? data.answeredAt.value
          : this.answeredAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AnswerLogData(')
          ..write('id: $id, ')
          ..write('questionId: $questionId, ')
          ..write('sessionId: $sessionId, ')
          ..write('day: $day, ')
          ..write('attempt: $attempt, ')
          ..write('chosen: $chosen, ')
          ..write('correct: $correct, ')
          ..write('answeredAt: $answeredAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    questionId,
    sessionId,
    day,
    attempt,
    chosen,
    correct,
    answeredAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AnswerLogData &&
          other.id == this.id &&
          other.questionId == this.questionId &&
          other.sessionId == this.sessionId &&
          other.day == this.day &&
          other.attempt == this.attempt &&
          other.chosen == this.chosen &&
          other.correct == this.correct &&
          other.answeredAt == this.answeredAt);
}

class AnswerLogCompanion extends UpdateCompanion<AnswerLogData> {
  final Value<int> id;
  final Value<String> questionId;
  final Value<String> sessionId;
  final Value<int> day;
  final Value<int> attempt;
  final Value<int> chosen;
  final Value<bool> correct;
  final Value<DateTime> answeredAt;
  const AnswerLogCompanion({
    this.id = const Value.absent(),
    this.questionId = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.day = const Value.absent(),
    this.attempt = const Value.absent(),
    this.chosen = const Value.absent(),
    this.correct = const Value.absent(),
    this.answeredAt = const Value.absent(),
  });
  AnswerLogCompanion.insert({
    this.id = const Value.absent(),
    required String questionId,
    required String sessionId,
    required int day,
    required int attempt,
    required int chosen,
    required bool correct,
    required DateTime answeredAt,
  }) : questionId = Value(questionId),
       sessionId = Value(sessionId),
       day = Value(day),
       attempt = Value(attempt),
       chosen = Value(chosen),
       correct = Value(correct),
       answeredAt = Value(answeredAt);
  static Insertable<AnswerLogData> custom({
    Expression<int>? id,
    Expression<String>? questionId,
    Expression<String>? sessionId,
    Expression<int>? day,
    Expression<int>? attempt,
    Expression<int>? chosen,
    Expression<bool>? correct,
    Expression<DateTime>? answeredAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (questionId != null) 'question_id': questionId,
      if (sessionId != null) 'session_id': sessionId,
      if (day != null) 'day': day,
      if (attempt != null) 'attempt': attempt,
      if (chosen != null) 'chosen': chosen,
      if (correct != null) 'correct': correct,
      if (answeredAt != null) 'answered_at': answeredAt,
    });
  }

  AnswerLogCompanion copyWith({
    Value<int>? id,
    Value<String>? questionId,
    Value<String>? sessionId,
    Value<int>? day,
    Value<int>? attempt,
    Value<int>? chosen,
    Value<bool>? correct,
    Value<DateTime>? answeredAt,
  }) {
    return AnswerLogCompanion(
      id: id ?? this.id,
      questionId: questionId ?? this.questionId,
      sessionId: sessionId ?? this.sessionId,
      day: day ?? this.day,
      attempt: attempt ?? this.attempt,
      chosen: chosen ?? this.chosen,
      correct: correct ?? this.correct,
      answeredAt: answeredAt ?? this.answeredAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (questionId.present) {
      map['question_id'] = Variable<String>(questionId.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (day.present) {
      map['day'] = Variable<int>(day.value);
    }
    if (attempt.present) {
      map['attempt'] = Variable<int>(attempt.value);
    }
    if (chosen.present) {
      map['chosen'] = Variable<int>(chosen.value);
    }
    if (correct.present) {
      map['correct'] = Variable<bool>(correct.value);
    }
    if (answeredAt.present) {
      map['answered_at'] = Variable<DateTime>(answeredAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AnswerLogCompanion(')
          ..write('id: $id, ')
          ..write('questionId: $questionId, ')
          ..write('sessionId: $sessionId, ')
          ..write('day: $day, ')
          ..write('attempt: $attempt, ')
          ..write('chosen: $chosen, ')
          ..write('correct: $correct, ')
          ..write('answeredAt: $answeredAt')
          ..write(')'))
        .toString();
  }
}

class $CalendarMarksTable extends CalendarMarks
    with TableInfo<$CalendarMarksTable, CalendarMark> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CalendarMarksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<int> score = GeneratedColumn<int>(
    'score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hanamaruMeta = const VerificationMeta(
    'hanamaru',
  );
  @override
  late final GeneratedColumn<bool> hanamaru = GeneratedColumn<bool>(
    'hanamaru',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("hanamaru" IN (0, 1))',
    ),
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, date, score, hanamaru, sessionId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'calendar_marks';
  @override
  VerificationContext validateIntegrity(
    Insertable<CalendarMark> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('score')) {
      context.handle(
        _scoreMeta,
        score.isAcceptableOrUnknown(data['score']!, _scoreMeta),
      );
    } else if (isInserting) {
      context.missing(_scoreMeta);
    }
    if (data.containsKey('hanamaru')) {
      context.handle(
        _hanamaruMeta,
        hanamaru.isAcceptableOrUnknown(data['hanamaru']!, _hanamaruMeta),
      );
    } else if (isInserting) {
      context.missing(_hanamaruMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {date},
  ];
  @override
  CalendarMark map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CalendarMark(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      score: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}score'],
      )!,
      hanamaru: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}hanamaru'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      ),
    );
  }

  @override
  $CalendarMarksTable createAlias(String alias) {
    return $CalendarMarksTable(attachedDatabase, alias);
  }
}

class CalendarMark extends DataClass implements Insertable<CalendarMark> {
  final int id;
  final DateTime date;
  final int score;
  final bool hanamaru;
  final String? sessionId;
  const CalendarMark({
    required this.id,
    required this.date,
    required this.score,
    required this.hanamaru,
    this.sessionId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['score'] = Variable<int>(score);
    map['hanamaru'] = Variable<bool>(hanamaru);
    if (!nullToAbsent || sessionId != null) {
      map['session_id'] = Variable<String>(sessionId);
    }
    return map;
  }

  CalendarMarksCompanion toCompanion(bool nullToAbsent) {
    return CalendarMarksCompanion(
      id: Value(id),
      date: Value(date),
      score: Value(score),
      hanamaru: Value(hanamaru),
      sessionId: sessionId == null && nullToAbsent
          ? const Value.absent()
          : Value(sessionId),
    );
  }

  factory CalendarMark.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CalendarMark(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      score: serializer.fromJson<int>(json['score']),
      hanamaru: serializer.fromJson<bool>(json['hanamaru']),
      sessionId: serializer.fromJson<String?>(json['sessionId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'score': serializer.toJson<int>(score),
      'hanamaru': serializer.toJson<bool>(hanamaru),
      'sessionId': serializer.toJson<String?>(sessionId),
    };
  }

  CalendarMark copyWith({
    int? id,
    DateTime? date,
    int? score,
    bool? hanamaru,
    Value<String?> sessionId = const Value.absent(),
  }) => CalendarMark(
    id: id ?? this.id,
    date: date ?? this.date,
    score: score ?? this.score,
    hanamaru: hanamaru ?? this.hanamaru,
    sessionId: sessionId.present ? sessionId.value : this.sessionId,
  );
  CalendarMark copyWithCompanion(CalendarMarksCompanion data) {
    return CalendarMark(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      score: data.score.present ? data.score.value : this.score,
      hanamaru: data.hanamaru.present ? data.hanamaru.value : this.hanamaru,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CalendarMark(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('score: $score, ')
          ..write('hanamaru: $hanamaru, ')
          ..write('sessionId: $sessionId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, score, hanamaru, sessionId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CalendarMark &&
          other.id == this.id &&
          other.date == this.date &&
          other.score == this.score &&
          other.hanamaru == this.hanamaru &&
          other.sessionId == this.sessionId);
}

class CalendarMarksCompanion extends UpdateCompanion<CalendarMark> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<int> score;
  final Value<bool> hanamaru;
  final Value<String?> sessionId;
  const CalendarMarksCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.score = const Value.absent(),
    this.hanamaru = const Value.absent(),
    this.sessionId = const Value.absent(),
  });
  CalendarMarksCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required int score,
    required bool hanamaru,
    this.sessionId = const Value.absent(),
  }) : date = Value(date),
       score = Value(score),
       hanamaru = Value(hanamaru);
  static Insertable<CalendarMark> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<int>? score,
    Expression<bool>? hanamaru,
    Expression<String>? sessionId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (score != null) 'score': score,
      if (hanamaru != null) 'hanamaru': hanamaru,
      if (sessionId != null) 'session_id': sessionId,
    });
  }

  CalendarMarksCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<int>? score,
    Value<bool>? hanamaru,
    Value<String?>? sessionId,
  }) {
    return CalendarMarksCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      score: score ?? this.score,
      hanamaru: hanamaru ?? this.hanamaru,
      sessionId: sessionId ?? this.sessionId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (score.present) {
      map['score'] = Variable<int>(score.value);
    }
    if (hanamaru.present) {
      map['hanamaru'] = Variable<bool>(hanamaru.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CalendarMarksCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('score: $score, ')
          ..write('hanamaru: $hanamaru, ')
          ..write('sessionId: $sessionId')
          ..write(')'))
        .toString();
  }
}

class $UserSettingsTable extends UserSettings
    with TableInfo<$UserSettingsTable, UserSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _examTypeMeta = const VerificationMeta(
    'examType',
  );
  @override
  late final GeneratedColumn<String> examType = GeneratedColumn<String>(
    'exam_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('type1'),
  );
  static const VerificationMeta _reminderTimeMeta = const VerificationMeta(
    'reminderTime',
  );
  @override
  late final GeneratedColumn<String> reminderTime = GeneratedColumn<String>(
    'reminder_time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('08:15'),
  );
  static const VerificationMeta _fontSizeMeta = const VerificationMeta(
    'fontSize',
  );
  @override
  late final GeneratedColumn<String> fontSize = GeneratedColumn<String>(
    'font_size',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('medium'),
  );
  static const VerificationMeta _purchasedMeta = const VerificationMeta(
    'purchased',
  );
  @override
  late final GeneratedColumn<bool> purchased = GeneratedColumn<bool>(
    'purchased',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("purchased" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _currentSessionIdMeta = const VerificationMeta(
    'currentSessionId',
  );
  @override
  late final GeneratedColumn<String> currentSessionId = GeneratedColumn<String>(
    'current_session_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _onboardingCompleteMeta =
      const VerificationMeta('onboardingComplete');
  @override
  late final GeneratedColumn<bool> onboardingComplete = GeneratedColumn<bool>(
    'onboarding_complete',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("onboarding_complete" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _notificationsEnabledMeta =
      const VerificationMeta('notificationsEnabled');
  @override
  late final GeneratedColumn<bool> notificationsEnabled = GeneratedColumn<bool>(
    'notifications_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("notifications_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _contentVersionMeta = const VerificationMeta(
    'contentVersion',
  );
  @override
  late final GeneratedColumn<int> contentVersion = GeneratedColumn<int>(
    'content_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    examType,
    reminderTime,
    fontSize,
    purchased,
    currentSessionId,
    onboardingComplete,
    notificationsEnabled,
    contentVersion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('exam_type')) {
      context.handle(
        _examTypeMeta,
        examType.isAcceptableOrUnknown(data['exam_type']!, _examTypeMeta),
      );
    }
    if (data.containsKey('reminder_time')) {
      context.handle(
        _reminderTimeMeta,
        reminderTime.isAcceptableOrUnknown(
          data['reminder_time']!,
          _reminderTimeMeta,
        ),
      );
    }
    if (data.containsKey('font_size')) {
      context.handle(
        _fontSizeMeta,
        fontSize.isAcceptableOrUnknown(data['font_size']!, _fontSizeMeta),
      );
    }
    if (data.containsKey('purchased')) {
      context.handle(
        _purchasedMeta,
        purchased.isAcceptableOrUnknown(data['purchased']!, _purchasedMeta),
      );
    }
    if (data.containsKey('current_session_id')) {
      context.handle(
        _currentSessionIdMeta,
        currentSessionId.isAcceptableOrUnknown(
          data['current_session_id']!,
          _currentSessionIdMeta,
        ),
      );
    }
    if (data.containsKey('onboarding_complete')) {
      context.handle(
        _onboardingCompleteMeta,
        onboardingComplete.isAcceptableOrUnknown(
          data['onboarding_complete']!,
          _onboardingCompleteMeta,
        ),
      );
    }
    if (data.containsKey('notifications_enabled')) {
      context.handle(
        _notificationsEnabledMeta,
        notificationsEnabled.isAcceptableOrUnknown(
          data['notifications_enabled']!,
          _notificationsEnabledMeta,
        ),
      );
    }
    if (data.containsKey('content_version')) {
      context.handle(
        _contentVersionMeta,
        contentVersion.isAcceptableOrUnknown(
          data['content_version']!,
          _contentVersionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserSetting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      examType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exam_type'],
      )!,
      reminderTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reminder_time'],
      )!,
      fontSize: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}font_size'],
      )!,
      purchased: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}purchased'],
      )!,
      currentSessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}current_session_id'],
      ),
      onboardingComplete: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}onboarding_complete'],
      )!,
      notificationsEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}notifications_enabled'],
      )!,
      contentVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}content_version'],
      )!,
    );
  }

  @override
  $UserSettingsTable createAlias(String alias) {
    return $UserSettingsTable(attachedDatabase, alias);
  }
}

class UserSetting extends DataClass implements Insertable<UserSetting> {
  final int id;
  final String examType;
  final String reminderTime;
  final String fontSize;
  final bool purchased;
  final String? currentSessionId;
  final bool onboardingComplete;
  final bool notificationsEnabled;
  final int contentVersion;
  const UserSetting({
    required this.id,
    required this.examType,
    required this.reminderTime,
    required this.fontSize,
    required this.purchased,
    this.currentSessionId,
    required this.onboardingComplete,
    required this.notificationsEnabled,
    required this.contentVersion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['exam_type'] = Variable<String>(examType);
    map['reminder_time'] = Variable<String>(reminderTime);
    map['font_size'] = Variable<String>(fontSize);
    map['purchased'] = Variable<bool>(purchased);
    if (!nullToAbsent || currentSessionId != null) {
      map['current_session_id'] = Variable<String>(currentSessionId);
    }
    map['onboarding_complete'] = Variable<bool>(onboardingComplete);
    map['notifications_enabled'] = Variable<bool>(notificationsEnabled);
    map['content_version'] = Variable<int>(contentVersion);
    return map;
  }

  UserSettingsCompanion toCompanion(bool nullToAbsent) {
    return UserSettingsCompanion(
      id: Value(id),
      examType: Value(examType),
      reminderTime: Value(reminderTime),
      fontSize: Value(fontSize),
      purchased: Value(purchased),
      currentSessionId: currentSessionId == null && nullToAbsent
          ? const Value.absent()
          : Value(currentSessionId),
      onboardingComplete: Value(onboardingComplete),
      notificationsEnabled: Value(notificationsEnabled),
      contentVersion: Value(contentVersion),
    );
  }

  factory UserSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserSetting(
      id: serializer.fromJson<int>(json['id']),
      examType: serializer.fromJson<String>(json['examType']),
      reminderTime: serializer.fromJson<String>(json['reminderTime']),
      fontSize: serializer.fromJson<String>(json['fontSize']),
      purchased: serializer.fromJson<bool>(json['purchased']),
      currentSessionId: serializer.fromJson<String?>(json['currentSessionId']),
      onboardingComplete: serializer.fromJson<bool>(json['onboardingComplete']),
      notificationsEnabled: serializer.fromJson<bool>(
        json['notificationsEnabled'],
      ),
      contentVersion: serializer.fromJson<int>(json['contentVersion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'examType': serializer.toJson<String>(examType),
      'reminderTime': serializer.toJson<String>(reminderTime),
      'fontSize': serializer.toJson<String>(fontSize),
      'purchased': serializer.toJson<bool>(purchased),
      'currentSessionId': serializer.toJson<String?>(currentSessionId),
      'onboardingComplete': serializer.toJson<bool>(onboardingComplete),
      'notificationsEnabled': serializer.toJson<bool>(notificationsEnabled),
      'contentVersion': serializer.toJson<int>(contentVersion),
    };
  }

  UserSetting copyWith({
    int? id,
    String? examType,
    String? reminderTime,
    String? fontSize,
    bool? purchased,
    Value<String?> currentSessionId = const Value.absent(),
    bool? onboardingComplete,
    bool? notificationsEnabled,
    int? contentVersion,
  }) => UserSetting(
    id: id ?? this.id,
    examType: examType ?? this.examType,
    reminderTime: reminderTime ?? this.reminderTime,
    fontSize: fontSize ?? this.fontSize,
    purchased: purchased ?? this.purchased,
    currentSessionId: currentSessionId.present
        ? currentSessionId.value
        : this.currentSessionId,
    onboardingComplete: onboardingComplete ?? this.onboardingComplete,
    notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    contentVersion: contentVersion ?? this.contentVersion,
  );
  UserSetting copyWithCompanion(UserSettingsCompanion data) {
    return UserSetting(
      id: data.id.present ? data.id.value : this.id,
      examType: data.examType.present ? data.examType.value : this.examType,
      reminderTime: data.reminderTime.present
          ? data.reminderTime.value
          : this.reminderTime,
      fontSize: data.fontSize.present ? data.fontSize.value : this.fontSize,
      purchased: data.purchased.present ? data.purchased.value : this.purchased,
      currentSessionId: data.currentSessionId.present
          ? data.currentSessionId.value
          : this.currentSessionId,
      onboardingComplete: data.onboardingComplete.present
          ? data.onboardingComplete.value
          : this.onboardingComplete,
      notificationsEnabled: data.notificationsEnabled.present
          ? data.notificationsEnabled.value
          : this.notificationsEnabled,
      contentVersion: data.contentVersion.present
          ? data.contentVersion.value
          : this.contentVersion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserSetting(')
          ..write('id: $id, ')
          ..write('examType: $examType, ')
          ..write('reminderTime: $reminderTime, ')
          ..write('fontSize: $fontSize, ')
          ..write('purchased: $purchased, ')
          ..write('currentSessionId: $currentSessionId, ')
          ..write('onboardingComplete: $onboardingComplete, ')
          ..write('notificationsEnabled: $notificationsEnabled, ')
          ..write('contentVersion: $contentVersion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    examType,
    reminderTime,
    fontSize,
    purchased,
    currentSessionId,
    onboardingComplete,
    notificationsEnabled,
    contentVersion,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserSetting &&
          other.id == this.id &&
          other.examType == this.examType &&
          other.reminderTime == this.reminderTime &&
          other.fontSize == this.fontSize &&
          other.purchased == this.purchased &&
          other.currentSessionId == this.currentSessionId &&
          other.onboardingComplete == this.onboardingComplete &&
          other.notificationsEnabled == this.notificationsEnabled &&
          other.contentVersion == this.contentVersion);
}

class UserSettingsCompanion extends UpdateCompanion<UserSetting> {
  final Value<int> id;
  final Value<String> examType;
  final Value<String> reminderTime;
  final Value<String> fontSize;
  final Value<bool> purchased;
  final Value<String?> currentSessionId;
  final Value<bool> onboardingComplete;
  final Value<bool> notificationsEnabled;
  final Value<int> contentVersion;
  const UserSettingsCompanion({
    this.id = const Value.absent(),
    this.examType = const Value.absent(),
    this.reminderTime = const Value.absent(),
    this.fontSize = const Value.absent(),
    this.purchased = const Value.absent(),
    this.currentSessionId = const Value.absent(),
    this.onboardingComplete = const Value.absent(),
    this.notificationsEnabled = const Value.absent(),
    this.contentVersion = const Value.absent(),
  });
  UserSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.examType = const Value.absent(),
    this.reminderTime = const Value.absent(),
    this.fontSize = const Value.absent(),
    this.purchased = const Value.absent(),
    this.currentSessionId = const Value.absent(),
    this.onboardingComplete = const Value.absent(),
    this.notificationsEnabled = const Value.absent(),
    this.contentVersion = const Value.absent(),
  });
  static Insertable<UserSetting> custom({
    Expression<int>? id,
    Expression<String>? examType,
    Expression<String>? reminderTime,
    Expression<String>? fontSize,
    Expression<bool>? purchased,
    Expression<String>? currentSessionId,
    Expression<bool>? onboardingComplete,
    Expression<bool>? notificationsEnabled,
    Expression<int>? contentVersion,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (examType != null) 'exam_type': examType,
      if (reminderTime != null) 'reminder_time': reminderTime,
      if (fontSize != null) 'font_size': fontSize,
      if (purchased != null) 'purchased': purchased,
      if (currentSessionId != null) 'current_session_id': currentSessionId,
      if (onboardingComplete != null) 'onboarding_complete': onboardingComplete,
      if (notificationsEnabled != null)
        'notifications_enabled': notificationsEnabled,
      if (contentVersion != null) 'content_version': contentVersion,
    });
  }

  UserSettingsCompanion copyWith({
    Value<int>? id,
    Value<String>? examType,
    Value<String>? reminderTime,
    Value<String>? fontSize,
    Value<bool>? purchased,
    Value<String?>? currentSessionId,
    Value<bool>? onboardingComplete,
    Value<bool>? notificationsEnabled,
    Value<int>? contentVersion,
  }) {
    return UserSettingsCompanion(
      id: id ?? this.id,
      examType: examType ?? this.examType,
      reminderTime: reminderTime ?? this.reminderTime,
      fontSize: fontSize ?? this.fontSize,
      purchased: purchased ?? this.purchased,
      currentSessionId: currentSessionId ?? this.currentSessionId,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      contentVersion: contentVersion ?? this.contentVersion,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (examType.present) {
      map['exam_type'] = Variable<String>(examType.value);
    }
    if (reminderTime.present) {
      map['reminder_time'] = Variable<String>(reminderTime.value);
    }
    if (fontSize.present) {
      map['font_size'] = Variable<String>(fontSize.value);
    }
    if (purchased.present) {
      map['purchased'] = Variable<bool>(purchased.value);
    }
    if (currentSessionId.present) {
      map['current_session_id'] = Variable<String>(currentSessionId.value);
    }
    if (onboardingComplete.present) {
      map['onboarding_complete'] = Variable<bool>(onboardingComplete.value);
    }
    if (notificationsEnabled.present) {
      map['notifications_enabled'] = Variable<bool>(notificationsEnabled.value);
    }
    if (contentVersion.present) {
      map['content_version'] = Variable<int>(contentVersion.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserSettingsCompanion(')
          ..write('id: $id, ')
          ..write('examType: $examType, ')
          ..write('reminderTime: $reminderTime, ')
          ..write('fontSize: $fontSize, ')
          ..write('purchased: $purchased, ')
          ..write('currentSessionId: $currentSessionId, ')
          ..write('onboardingComplete: $onboardingComplete, ')
          ..write('notificationsEnabled: $notificationsEnabled, ')
          ..write('contentVersion: $contentVersion')
          ..write(')'))
        .toString();
  }
}

class $RemindersTable extends Reminders
    with TableInfo<$RemindersTable, Reminder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RemindersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _timeMeta = const VerificationMeta('time');
  @override
  late final GeneratedColumn<String> time = GeneratedColumn<String>(
    'time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [id, time, enabled, label, sortOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminders';
  @override
  VerificationContext validateIntegrity(
    Insertable<Reminder> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('time')) {
      context.handle(
        _timeMeta,
        time.isAcceptableOrUnknown(data['time']!, _timeMeta),
      );
    } else if (isInserting) {
      context.missing(_timeMeta);
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Reminder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Reminder(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      time: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}time'],
      )!,
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $RemindersTable createAlias(String alias) {
    return $RemindersTable(attachedDatabase, alias);
  }
}

class Reminder extends DataClass implements Insertable<Reminder> {
  final int id;
  final String time;
  final bool enabled;
  final String? label;
  final int sortOrder;
  const Reminder({
    required this.id,
    required this.time,
    required this.enabled,
    this.label,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['time'] = Variable<String>(time);
    map['enabled'] = Variable<bool>(enabled);
    if (!nullToAbsent || label != null) {
      map['label'] = Variable<String>(label);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  RemindersCompanion toCompanion(bool nullToAbsent) {
    return RemindersCompanion(
      id: Value(id),
      time: Value(time),
      enabled: Value(enabled),
      label: label == null && nullToAbsent
          ? const Value.absent()
          : Value(label),
      sortOrder: Value(sortOrder),
    );
  }

  factory Reminder.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Reminder(
      id: serializer.fromJson<int>(json['id']),
      time: serializer.fromJson<String>(json['time']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      label: serializer.fromJson<String?>(json['label']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'time': serializer.toJson<String>(time),
      'enabled': serializer.toJson<bool>(enabled),
      'label': serializer.toJson<String?>(label),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  Reminder copyWith({
    int? id,
    String? time,
    bool? enabled,
    Value<String?> label = const Value.absent(),
    int? sortOrder,
  }) => Reminder(
    id: id ?? this.id,
    time: time ?? this.time,
    enabled: enabled ?? this.enabled,
    label: label.present ? label.value : this.label,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  Reminder copyWithCompanion(RemindersCompanion data) {
    return Reminder(
      id: data.id.present ? data.id.value : this.id,
      time: data.time.present ? data.time.value : this.time,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      label: data.label.present ? data.label.value : this.label,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Reminder(')
          ..write('id: $id, ')
          ..write('time: $time, ')
          ..write('enabled: $enabled, ')
          ..write('label: $label, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, time, enabled, label, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Reminder &&
          other.id == this.id &&
          other.time == this.time &&
          other.enabled == this.enabled &&
          other.label == this.label &&
          other.sortOrder == this.sortOrder);
}

class RemindersCompanion extends UpdateCompanion<Reminder> {
  final Value<int> id;
  final Value<String> time;
  final Value<bool> enabled;
  final Value<String?> label;
  final Value<int> sortOrder;
  const RemindersCompanion({
    this.id = const Value.absent(),
    this.time = const Value.absent(),
    this.enabled = const Value.absent(),
    this.label = const Value.absent(),
    this.sortOrder = const Value.absent(),
  });
  RemindersCompanion.insert({
    this.id = const Value.absent(),
    required String time,
    this.enabled = const Value.absent(),
    this.label = const Value.absent(),
    this.sortOrder = const Value.absent(),
  }) : time = Value(time);
  static Insertable<Reminder> custom({
    Expression<int>? id,
    Expression<String>? time,
    Expression<bool>? enabled,
    Expression<String>? label,
    Expression<int>? sortOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (time != null) 'time': time,
      if (enabled != null) 'enabled': enabled,
      if (label != null) 'label': label,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
  }

  RemindersCompanion copyWith({
    Value<int>? id,
    Value<String>? time,
    Value<bool>? enabled,
    Value<String?>? label,
    Value<int>? sortOrder,
  }) {
    return RemindersCompanion(
      id: id ?? this.id,
      time: time ?? this.time,
      enabled: enabled ?? this.enabled,
      label: label ?? this.label,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (time.present) {
      map['time'] = Variable<String>(time.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RemindersCompanion(')
          ..write('id: $id, ')
          ..write('time: $time, ')
          ..write('enabled: $enabled, ')
          ..write('label: $label, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $QuestionsTable questions = $QuestionsTable(this);
  late final $ExamSessionsTable examSessions = $ExamSessionsTable(this);
  late final $DailyProgressTable dailyProgress = $DailyProgressTable(this);
  late final $AnswerLogTable answerLog = $AnswerLogTable(this);
  late final $CalendarMarksTable calendarMarks = $CalendarMarksTable(this);
  late final $UserSettingsTable userSettings = $UserSettingsTable(this);
  late final $RemindersTable reminders = $RemindersTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    questions,
    examSessions,
    dailyProgress,
    answerLog,
    calendarMarks,
    userSettings,
    reminders,
  ];
}

typedef $$QuestionsTableCreateCompanionBuilder =
    QuestionsCompanion Function({
      required String id,
      required String examType,
      required String year,
      required String categoryKey,
      required String categoryName,
      required String number,
      required int numberInt,
      required String questionText,
      required String choicesJson,
      required int correctIndex,
      required String officialExplanation,
      Value<int> rowid,
    });
typedef $$QuestionsTableUpdateCompanionBuilder =
    QuestionsCompanion Function({
      Value<String> id,
      Value<String> examType,
      Value<String> year,
      Value<String> categoryKey,
      Value<String> categoryName,
      Value<String> number,
      Value<int> numberInt,
      Value<String> questionText,
      Value<String> choicesJson,
      Value<int> correctIndex,
      Value<String> officialExplanation,
      Value<int> rowid,
    });

class $$QuestionsTableFilterComposer
    extends Composer<_$AppDatabase, $QuestionsTable> {
  $$QuestionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get examType => $composableBuilder(
    column: $table.examType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryKey => $composableBuilder(
    column: $table.categoryKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryName => $composableBuilder(
    column: $table.categoryName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get numberInt => $composableBuilder(
    column: $table.numberInt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get questionText => $composableBuilder(
    column: $table.questionText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get choicesJson => $composableBuilder(
    column: $table.choicesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get correctIndex => $composableBuilder(
    column: $table.correctIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get officialExplanation => $composableBuilder(
    column: $table.officialExplanation,
    builder: (column) => ColumnFilters(column),
  );
}

class $$QuestionsTableOrderingComposer
    extends Composer<_$AppDatabase, $QuestionsTable> {
  $$QuestionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get examType => $composableBuilder(
    column: $table.examType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryKey => $composableBuilder(
    column: $table.categoryKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryName => $composableBuilder(
    column: $table.categoryName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get numberInt => $composableBuilder(
    column: $table.numberInt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get questionText => $composableBuilder(
    column: $table.questionText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get choicesJson => $composableBuilder(
    column: $table.choicesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get correctIndex => $composableBuilder(
    column: $table.correctIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get officialExplanation => $composableBuilder(
    column: $table.officialExplanation,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$QuestionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuestionsTable> {
  $$QuestionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get examType =>
      $composableBuilder(column: $table.examType, builder: (column) => column);

  GeneratedColumn<String> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<String> get categoryKey => $composableBuilder(
    column: $table.categoryKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get categoryName => $composableBuilder(
    column: $table.categoryName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get number =>
      $composableBuilder(column: $table.number, builder: (column) => column);

  GeneratedColumn<int> get numberInt =>
      $composableBuilder(column: $table.numberInt, builder: (column) => column);

  GeneratedColumn<String> get questionText => $composableBuilder(
    column: $table.questionText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get choicesJson => $composableBuilder(
    column: $table.choicesJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get correctIndex => $composableBuilder(
    column: $table.correctIndex,
    builder: (column) => column,
  );

  GeneratedColumn<String> get officialExplanation => $composableBuilder(
    column: $table.officialExplanation,
    builder: (column) => column,
  );
}

class $$QuestionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuestionsTable,
          Question,
          $$QuestionsTableFilterComposer,
          $$QuestionsTableOrderingComposer,
          $$QuestionsTableAnnotationComposer,
          $$QuestionsTableCreateCompanionBuilder,
          $$QuestionsTableUpdateCompanionBuilder,
          (Question, BaseReferences<_$AppDatabase, $QuestionsTable, Question>),
          Question,
          PrefetchHooks Function()
        > {
  $$QuestionsTableTableManager(_$AppDatabase db, $QuestionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuestionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuestionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuestionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> examType = const Value.absent(),
                Value<String> year = const Value.absent(),
                Value<String> categoryKey = const Value.absent(),
                Value<String> categoryName = const Value.absent(),
                Value<String> number = const Value.absent(),
                Value<int> numberInt = const Value.absent(),
                Value<String> questionText = const Value.absent(),
                Value<String> choicesJson = const Value.absent(),
                Value<int> correctIndex = const Value.absent(),
                Value<String> officialExplanation = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuestionsCompanion(
                id: id,
                examType: examType,
                year: year,
                categoryKey: categoryKey,
                categoryName: categoryName,
                number: number,
                numberInt: numberInt,
                questionText: questionText,
                choicesJson: choicesJson,
                correctIndex: correctIndex,
                officialExplanation: officialExplanation,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String examType,
                required String year,
                required String categoryKey,
                required String categoryName,
                required String number,
                required int numberInt,
                required String questionText,
                required String choicesJson,
                required int correctIndex,
                required String officialExplanation,
                Value<int> rowid = const Value.absent(),
              }) => QuestionsCompanion.insert(
                id: id,
                examType: examType,
                year: year,
                categoryKey: categoryKey,
                categoryName: categoryName,
                number: number,
                numberInt: numberInt,
                questionText: questionText,
                choicesJson: choicesJson,
                correctIndex: correctIndex,
                officialExplanation: officialExplanation,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$QuestionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuestionsTable,
      Question,
      $$QuestionsTableFilterComposer,
      $$QuestionsTableOrderingComposer,
      $$QuestionsTableAnnotationComposer,
      $$QuestionsTableCreateCompanionBuilder,
      $$QuestionsTableUpdateCompanionBuilder,
      (Question, BaseReferences<_$AppDatabase, $QuestionsTable, Question>),
      Question,
      PrefetchHooks Function()
    >;
typedef $$ExamSessionsTableCreateCompanionBuilder =
    ExamSessionsCompanion Function({
      required String id,
      required String year,
      required String label,
      required String examType,
      required int totalQ,
      Value<bool> isLatest,
      Value<int> sortOrder,
      Value<String> status,
      Value<int> day,
      Value<int> attempt,
      Value<int?> avgScore,
      Value<int> hanamaruDays,
      Value<bool> weekComplete,
      Value<String?> dayQuestionIdsJson,
      Value<String?> reviewQuestionIdsJson,
      Value<DateTime?> dayStartedAt,
      Value<int> rowid,
    });
typedef $$ExamSessionsTableUpdateCompanionBuilder =
    ExamSessionsCompanion Function({
      Value<String> id,
      Value<String> year,
      Value<String> label,
      Value<String> examType,
      Value<int> totalQ,
      Value<bool> isLatest,
      Value<int> sortOrder,
      Value<String> status,
      Value<int> day,
      Value<int> attempt,
      Value<int?> avgScore,
      Value<int> hanamaruDays,
      Value<bool> weekComplete,
      Value<String?> dayQuestionIdsJson,
      Value<String?> reviewQuestionIdsJson,
      Value<DateTime?> dayStartedAt,
      Value<int> rowid,
    });

class $$ExamSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $ExamSessionsTable> {
  $$ExamSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get examType => $composableBuilder(
    column: $table.examType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalQ => $composableBuilder(
    column: $table.totalQ,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isLatest => $composableBuilder(
    column: $table.isLatest,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attempt => $composableBuilder(
    column: $table.attempt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get avgScore => $composableBuilder(
    column: $table.avgScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hanamaruDays => $composableBuilder(
    column: $table.hanamaruDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get weekComplete => $composableBuilder(
    column: $table.weekComplete,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dayQuestionIdsJson => $composableBuilder(
    column: $table.dayQuestionIdsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reviewQuestionIdsJson => $composableBuilder(
    column: $table.reviewQuestionIdsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dayStartedAt => $composableBuilder(
    column: $table.dayStartedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ExamSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $ExamSessionsTable> {
  $$ExamSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get examType => $composableBuilder(
    column: $table.examType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalQ => $composableBuilder(
    column: $table.totalQ,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isLatest => $composableBuilder(
    column: $table.isLatest,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempt => $composableBuilder(
    column: $table.attempt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get avgScore => $composableBuilder(
    column: $table.avgScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hanamaruDays => $composableBuilder(
    column: $table.hanamaruDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get weekComplete => $composableBuilder(
    column: $table.weekComplete,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dayQuestionIdsJson => $composableBuilder(
    column: $table.dayQuestionIdsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reviewQuestionIdsJson => $composableBuilder(
    column: $table.reviewQuestionIdsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dayStartedAt => $composableBuilder(
    column: $table.dayStartedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExamSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExamSessionsTable> {
  $$ExamSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get examType =>
      $composableBuilder(column: $table.examType, builder: (column) => column);

  GeneratedColumn<int> get totalQ =>
      $composableBuilder(column: $table.totalQ, builder: (column) => column);

  GeneratedColumn<bool> get isLatest =>
      $composableBuilder(column: $table.isLatest, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);

  GeneratedColumn<int> get attempt =>
      $composableBuilder(column: $table.attempt, builder: (column) => column);

  GeneratedColumn<int> get avgScore =>
      $composableBuilder(column: $table.avgScore, builder: (column) => column);

  GeneratedColumn<int> get hanamaruDays => $composableBuilder(
    column: $table.hanamaruDays,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get weekComplete => $composableBuilder(
    column: $table.weekComplete,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dayQuestionIdsJson => $composableBuilder(
    column: $table.dayQuestionIdsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reviewQuestionIdsJson => $composableBuilder(
    column: $table.reviewQuestionIdsJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dayStartedAt => $composableBuilder(
    column: $table.dayStartedAt,
    builder: (column) => column,
  );
}

class $$ExamSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExamSessionsTable,
          ExamSession,
          $$ExamSessionsTableFilterComposer,
          $$ExamSessionsTableOrderingComposer,
          $$ExamSessionsTableAnnotationComposer,
          $$ExamSessionsTableCreateCompanionBuilder,
          $$ExamSessionsTableUpdateCompanionBuilder,
          (
            ExamSession,
            BaseReferences<_$AppDatabase, $ExamSessionsTable, ExamSession>,
          ),
          ExamSession,
          PrefetchHooks Function()
        > {
  $$ExamSessionsTableTableManager(_$AppDatabase db, $ExamSessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExamSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExamSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExamSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> year = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<String> examType = const Value.absent(),
                Value<int> totalQ = const Value.absent(),
                Value<bool> isLatest = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> day = const Value.absent(),
                Value<int> attempt = const Value.absent(),
                Value<int?> avgScore = const Value.absent(),
                Value<int> hanamaruDays = const Value.absent(),
                Value<bool> weekComplete = const Value.absent(),
                Value<String?> dayQuestionIdsJson = const Value.absent(),
                Value<String?> reviewQuestionIdsJson = const Value.absent(),
                Value<DateTime?> dayStartedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExamSessionsCompanion(
                id: id,
                year: year,
                label: label,
                examType: examType,
                totalQ: totalQ,
                isLatest: isLatest,
                sortOrder: sortOrder,
                status: status,
                day: day,
                attempt: attempt,
                avgScore: avgScore,
                hanamaruDays: hanamaruDays,
                weekComplete: weekComplete,
                dayQuestionIdsJson: dayQuestionIdsJson,
                reviewQuestionIdsJson: reviewQuestionIdsJson,
                dayStartedAt: dayStartedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String year,
                required String label,
                required String examType,
                required int totalQ,
                Value<bool> isLatest = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> day = const Value.absent(),
                Value<int> attempt = const Value.absent(),
                Value<int?> avgScore = const Value.absent(),
                Value<int> hanamaruDays = const Value.absent(),
                Value<bool> weekComplete = const Value.absent(),
                Value<String?> dayQuestionIdsJson = const Value.absent(),
                Value<String?> reviewQuestionIdsJson = const Value.absent(),
                Value<DateTime?> dayStartedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExamSessionsCompanion.insert(
                id: id,
                year: year,
                label: label,
                examType: examType,
                totalQ: totalQ,
                isLatest: isLatest,
                sortOrder: sortOrder,
                status: status,
                day: day,
                attempt: attempt,
                avgScore: avgScore,
                hanamaruDays: hanamaruDays,
                weekComplete: weekComplete,
                dayQuestionIdsJson: dayQuestionIdsJson,
                reviewQuestionIdsJson: reviewQuestionIdsJson,
                dayStartedAt: dayStartedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ExamSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExamSessionsTable,
      ExamSession,
      $$ExamSessionsTableFilterComposer,
      $$ExamSessionsTableOrderingComposer,
      $$ExamSessionsTableAnnotationComposer,
      $$ExamSessionsTableCreateCompanionBuilder,
      $$ExamSessionsTableUpdateCompanionBuilder,
      (
        ExamSession,
        BaseReferences<_$AppDatabase, $ExamSessionsTable, ExamSession>,
      ),
      ExamSession,
      PrefetchHooks Function()
    >;
typedef $$DailyProgressTableCreateCompanionBuilder =
    DailyProgressCompanion Function({
      Value<int> id,
      required String sessionId,
      required int day,
      required int attempt,
      required int score,
      required int totalQuestions,
      Value<bool> hanamaru,
      required DateTime completedAt,
    });
typedef $$DailyProgressTableUpdateCompanionBuilder =
    DailyProgressCompanion Function({
      Value<int> id,
      Value<String> sessionId,
      Value<int> day,
      Value<int> attempt,
      Value<int> score,
      Value<int> totalQuestions,
      Value<bool> hanamaru,
      Value<DateTime> completedAt,
    });

class $$DailyProgressTableFilterComposer
    extends Composer<_$AppDatabase, $DailyProgressTable> {
  $$DailyProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attempt => $composableBuilder(
    column: $table.attempt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalQuestions => $composableBuilder(
    column: $table.totalQuestions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hanamaru => $composableBuilder(
    column: $table.hanamaru,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DailyProgressTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyProgressTable> {
  $$DailyProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempt => $composableBuilder(
    column: $table.attempt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalQuestions => $composableBuilder(
    column: $table.totalQuestions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hanamaru => $composableBuilder(
    column: $table.hanamaru,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailyProgressTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyProgressTable> {
  $$DailyProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<int> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);

  GeneratedColumn<int> get attempt =>
      $composableBuilder(column: $table.attempt, builder: (column) => column);

  GeneratedColumn<int> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<int> get totalQuestions => $composableBuilder(
    column: $table.totalQuestions,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hanamaru =>
      $composableBuilder(column: $table.hanamaru, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );
}

class $$DailyProgressTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyProgressTable,
          DailyProgressData,
          $$DailyProgressTableFilterComposer,
          $$DailyProgressTableOrderingComposer,
          $$DailyProgressTableAnnotationComposer,
          $$DailyProgressTableCreateCompanionBuilder,
          $$DailyProgressTableUpdateCompanionBuilder,
          (
            DailyProgressData,
            BaseReferences<
              _$AppDatabase,
              $DailyProgressTable,
              DailyProgressData
            >,
          ),
          DailyProgressData,
          PrefetchHooks Function()
        > {
  $$DailyProgressTableTableManager(_$AppDatabase db, $DailyProgressTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyProgressTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<int> day = const Value.absent(),
                Value<int> attempt = const Value.absent(),
                Value<int> score = const Value.absent(),
                Value<int> totalQuestions = const Value.absent(),
                Value<bool> hanamaru = const Value.absent(),
                Value<DateTime> completedAt = const Value.absent(),
              }) => DailyProgressCompanion(
                id: id,
                sessionId: sessionId,
                day: day,
                attempt: attempt,
                score: score,
                totalQuestions: totalQuestions,
                hanamaru: hanamaru,
                completedAt: completedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String sessionId,
                required int day,
                required int attempt,
                required int score,
                required int totalQuestions,
                Value<bool> hanamaru = const Value.absent(),
                required DateTime completedAt,
              }) => DailyProgressCompanion.insert(
                id: id,
                sessionId: sessionId,
                day: day,
                attempt: attempt,
                score: score,
                totalQuestions: totalQuestions,
                hanamaru: hanamaru,
                completedAt: completedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DailyProgressTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyProgressTable,
      DailyProgressData,
      $$DailyProgressTableFilterComposer,
      $$DailyProgressTableOrderingComposer,
      $$DailyProgressTableAnnotationComposer,
      $$DailyProgressTableCreateCompanionBuilder,
      $$DailyProgressTableUpdateCompanionBuilder,
      (
        DailyProgressData,
        BaseReferences<_$AppDatabase, $DailyProgressTable, DailyProgressData>,
      ),
      DailyProgressData,
      PrefetchHooks Function()
    >;
typedef $$AnswerLogTableCreateCompanionBuilder =
    AnswerLogCompanion Function({
      Value<int> id,
      required String questionId,
      required String sessionId,
      required int day,
      required int attempt,
      required int chosen,
      required bool correct,
      required DateTime answeredAt,
    });
typedef $$AnswerLogTableUpdateCompanionBuilder =
    AnswerLogCompanion Function({
      Value<int> id,
      Value<String> questionId,
      Value<String> sessionId,
      Value<int> day,
      Value<int> attempt,
      Value<int> chosen,
      Value<bool> correct,
      Value<DateTime> answeredAt,
    });

class $$AnswerLogTableFilterComposer
    extends Composer<_$AppDatabase, $AnswerLogTable> {
  $$AnswerLogTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get questionId => $composableBuilder(
    column: $table.questionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attempt => $composableBuilder(
    column: $table.attempt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get chosen => $composableBuilder(
    column: $table.chosen,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get correct => $composableBuilder(
    column: $table.correct,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get answeredAt => $composableBuilder(
    column: $table.answeredAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AnswerLogTableOrderingComposer
    extends Composer<_$AppDatabase, $AnswerLogTable> {
  $$AnswerLogTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get questionId => $composableBuilder(
    column: $table.questionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempt => $composableBuilder(
    column: $table.attempt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get chosen => $composableBuilder(
    column: $table.chosen,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get correct => $composableBuilder(
    column: $table.correct,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get answeredAt => $composableBuilder(
    column: $table.answeredAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AnswerLogTableAnnotationComposer
    extends Composer<_$AppDatabase, $AnswerLogTable> {
  $$AnswerLogTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get questionId => $composableBuilder(
    column: $table.questionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<int> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);

  GeneratedColumn<int> get attempt =>
      $composableBuilder(column: $table.attempt, builder: (column) => column);

  GeneratedColumn<int> get chosen =>
      $composableBuilder(column: $table.chosen, builder: (column) => column);

  GeneratedColumn<bool> get correct =>
      $composableBuilder(column: $table.correct, builder: (column) => column);

  GeneratedColumn<DateTime> get answeredAt => $composableBuilder(
    column: $table.answeredAt,
    builder: (column) => column,
  );
}

class $$AnswerLogTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AnswerLogTable,
          AnswerLogData,
          $$AnswerLogTableFilterComposer,
          $$AnswerLogTableOrderingComposer,
          $$AnswerLogTableAnnotationComposer,
          $$AnswerLogTableCreateCompanionBuilder,
          $$AnswerLogTableUpdateCompanionBuilder,
          (
            AnswerLogData,
            BaseReferences<_$AppDatabase, $AnswerLogTable, AnswerLogData>,
          ),
          AnswerLogData,
          PrefetchHooks Function()
        > {
  $$AnswerLogTableTableManager(_$AppDatabase db, $AnswerLogTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AnswerLogTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AnswerLogTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AnswerLogTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> questionId = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<int> day = const Value.absent(),
                Value<int> attempt = const Value.absent(),
                Value<int> chosen = const Value.absent(),
                Value<bool> correct = const Value.absent(),
                Value<DateTime> answeredAt = const Value.absent(),
              }) => AnswerLogCompanion(
                id: id,
                questionId: questionId,
                sessionId: sessionId,
                day: day,
                attempt: attempt,
                chosen: chosen,
                correct: correct,
                answeredAt: answeredAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String questionId,
                required String sessionId,
                required int day,
                required int attempt,
                required int chosen,
                required bool correct,
                required DateTime answeredAt,
              }) => AnswerLogCompanion.insert(
                id: id,
                questionId: questionId,
                sessionId: sessionId,
                day: day,
                attempt: attempt,
                chosen: chosen,
                correct: correct,
                answeredAt: answeredAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AnswerLogTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AnswerLogTable,
      AnswerLogData,
      $$AnswerLogTableFilterComposer,
      $$AnswerLogTableOrderingComposer,
      $$AnswerLogTableAnnotationComposer,
      $$AnswerLogTableCreateCompanionBuilder,
      $$AnswerLogTableUpdateCompanionBuilder,
      (
        AnswerLogData,
        BaseReferences<_$AppDatabase, $AnswerLogTable, AnswerLogData>,
      ),
      AnswerLogData,
      PrefetchHooks Function()
    >;
typedef $$CalendarMarksTableCreateCompanionBuilder =
    CalendarMarksCompanion Function({
      Value<int> id,
      required DateTime date,
      required int score,
      required bool hanamaru,
      Value<String?> sessionId,
    });
typedef $$CalendarMarksTableUpdateCompanionBuilder =
    CalendarMarksCompanion Function({
      Value<int> id,
      Value<DateTime> date,
      Value<int> score,
      Value<bool> hanamaru,
      Value<String?> sessionId,
    });

class $$CalendarMarksTableFilterComposer
    extends Composer<_$AppDatabase, $CalendarMarksTable> {
  $$CalendarMarksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hanamaru => $composableBuilder(
    column: $table.hanamaru,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CalendarMarksTableOrderingComposer
    extends Composer<_$AppDatabase, $CalendarMarksTable> {
  $$CalendarMarksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hanamaru => $composableBuilder(
    column: $table.hanamaru,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CalendarMarksTableAnnotationComposer
    extends Composer<_$AppDatabase, $CalendarMarksTable> {
  $$CalendarMarksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<bool> get hanamaru =>
      $composableBuilder(column: $table.hanamaru, builder: (column) => column);

  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);
}

class $$CalendarMarksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CalendarMarksTable,
          CalendarMark,
          $$CalendarMarksTableFilterComposer,
          $$CalendarMarksTableOrderingComposer,
          $$CalendarMarksTableAnnotationComposer,
          $$CalendarMarksTableCreateCompanionBuilder,
          $$CalendarMarksTableUpdateCompanionBuilder,
          (
            CalendarMark,
            BaseReferences<_$AppDatabase, $CalendarMarksTable, CalendarMark>,
          ),
          CalendarMark,
          PrefetchHooks Function()
        > {
  $$CalendarMarksTableTableManager(_$AppDatabase db, $CalendarMarksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CalendarMarksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CalendarMarksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CalendarMarksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int> score = const Value.absent(),
                Value<bool> hanamaru = const Value.absent(),
                Value<String?> sessionId = const Value.absent(),
              }) => CalendarMarksCompanion(
                id: id,
                date: date,
                score: score,
                hanamaru: hanamaru,
                sessionId: sessionId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime date,
                required int score,
                required bool hanamaru,
                Value<String?> sessionId = const Value.absent(),
              }) => CalendarMarksCompanion.insert(
                id: id,
                date: date,
                score: score,
                hanamaru: hanamaru,
                sessionId: sessionId,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CalendarMarksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CalendarMarksTable,
      CalendarMark,
      $$CalendarMarksTableFilterComposer,
      $$CalendarMarksTableOrderingComposer,
      $$CalendarMarksTableAnnotationComposer,
      $$CalendarMarksTableCreateCompanionBuilder,
      $$CalendarMarksTableUpdateCompanionBuilder,
      (
        CalendarMark,
        BaseReferences<_$AppDatabase, $CalendarMarksTable, CalendarMark>,
      ),
      CalendarMark,
      PrefetchHooks Function()
    >;
typedef $$UserSettingsTableCreateCompanionBuilder =
    UserSettingsCompanion Function({
      Value<int> id,
      Value<String> examType,
      Value<String> reminderTime,
      Value<String> fontSize,
      Value<bool> purchased,
      Value<String?> currentSessionId,
      Value<bool> onboardingComplete,
      Value<bool> notificationsEnabled,
      Value<int> contentVersion,
    });
typedef $$UserSettingsTableUpdateCompanionBuilder =
    UserSettingsCompanion Function({
      Value<int> id,
      Value<String> examType,
      Value<String> reminderTime,
      Value<String> fontSize,
      Value<bool> purchased,
      Value<String?> currentSessionId,
      Value<bool> onboardingComplete,
      Value<bool> notificationsEnabled,
      Value<int> contentVersion,
    });

class $$UserSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $UserSettingsTable> {
  $$UserSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get examType => $composableBuilder(
    column: $table.examType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reminderTime => $composableBuilder(
    column: $table.reminderTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fontSize => $composableBuilder(
    column: $table.fontSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get purchased => $composableBuilder(
    column: $table.purchased,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currentSessionId => $composableBuilder(
    column: $table.currentSessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get onboardingComplete => $composableBuilder(
    column: $table.onboardingComplete,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get notificationsEnabled => $composableBuilder(
    column: $table.notificationsEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get contentVersion => $composableBuilder(
    column: $table.contentVersion,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $UserSettingsTable> {
  $$UserSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get examType => $composableBuilder(
    column: $table.examType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reminderTime => $composableBuilder(
    column: $table.reminderTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fontSize => $composableBuilder(
    column: $table.fontSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get purchased => $composableBuilder(
    column: $table.purchased,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currentSessionId => $composableBuilder(
    column: $table.currentSessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get onboardingComplete => $composableBuilder(
    column: $table.onboardingComplete,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get notificationsEnabled => $composableBuilder(
    column: $table.notificationsEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get contentVersion => $composableBuilder(
    column: $table.contentVersion,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserSettingsTable> {
  $$UserSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get examType =>
      $composableBuilder(column: $table.examType, builder: (column) => column);

  GeneratedColumn<String> get reminderTime => $composableBuilder(
    column: $table.reminderTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fontSize =>
      $composableBuilder(column: $table.fontSize, builder: (column) => column);

  GeneratedColumn<bool> get purchased =>
      $composableBuilder(column: $table.purchased, builder: (column) => column);

  GeneratedColumn<String> get currentSessionId => $composableBuilder(
    column: $table.currentSessionId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get onboardingComplete => $composableBuilder(
    column: $table.onboardingComplete,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get notificationsEnabled => $composableBuilder(
    column: $table.notificationsEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<int> get contentVersion => $composableBuilder(
    column: $table.contentVersion,
    builder: (column) => column,
  );
}

class $$UserSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserSettingsTable,
          UserSetting,
          $$UserSettingsTableFilterComposer,
          $$UserSettingsTableOrderingComposer,
          $$UserSettingsTableAnnotationComposer,
          $$UserSettingsTableCreateCompanionBuilder,
          $$UserSettingsTableUpdateCompanionBuilder,
          (
            UserSetting,
            BaseReferences<_$AppDatabase, $UserSettingsTable, UserSetting>,
          ),
          UserSetting,
          PrefetchHooks Function()
        > {
  $$UserSettingsTableTableManager(_$AppDatabase db, $UserSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> examType = const Value.absent(),
                Value<String> reminderTime = const Value.absent(),
                Value<String> fontSize = const Value.absent(),
                Value<bool> purchased = const Value.absent(),
                Value<String?> currentSessionId = const Value.absent(),
                Value<bool> onboardingComplete = const Value.absent(),
                Value<bool> notificationsEnabled = const Value.absent(),
                Value<int> contentVersion = const Value.absent(),
              }) => UserSettingsCompanion(
                id: id,
                examType: examType,
                reminderTime: reminderTime,
                fontSize: fontSize,
                purchased: purchased,
                currentSessionId: currentSessionId,
                onboardingComplete: onboardingComplete,
                notificationsEnabled: notificationsEnabled,
                contentVersion: contentVersion,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> examType = const Value.absent(),
                Value<String> reminderTime = const Value.absent(),
                Value<String> fontSize = const Value.absent(),
                Value<bool> purchased = const Value.absent(),
                Value<String?> currentSessionId = const Value.absent(),
                Value<bool> onboardingComplete = const Value.absent(),
                Value<bool> notificationsEnabled = const Value.absent(),
                Value<int> contentVersion = const Value.absent(),
              }) => UserSettingsCompanion.insert(
                id: id,
                examType: examType,
                reminderTime: reminderTime,
                fontSize: fontSize,
                purchased: purchased,
                currentSessionId: currentSessionId,
                onboardingComplete: onboardingComplete,
                notificationsEnabled: notificationsEnabled,
                contentVersion: contentVersion,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserSettingsTable,
      UserSetting,
      $$UserSettingsTableFilterComposer,
      $$UserSettingsTableOrderingComposer,
      $$UserSettingsTableAnnotationComposer,
      $$UserSettingsTableCreateCompanionBuilder,
      $$UserSettingsTableUpdateCompanionBuilder,
      (
        UserSetting,
        BaseReferences<_$AppDatabase, $UserSettingsTable, UserSetting>,
      ),
      UserSetting,
      PrefetchHooks Function()
    >;
typedef $$RemindersTableCreateCompanionBuilder =
    RemindersCompanion Function({
      Value<int> id,
      required String time,
      Value<bool> enabled,
      Value<String?> label,
      Value<int> sortOrder,
    });
typedef $$RemindersTableUpdateCompanionBuilder =
    RemindersCompanion Function({
      Value<int> id,
      Value<String> time,
      Value<bool> enabled,
      Value<String?> label,
      Value<int> sortOrder,
    });

class $$RemindersTableFilterComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RemindersTableOrderingComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RemindersTableAnnotationComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get time =>
      $composableBuilder(column: $table.time, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);
}

class $$RemindersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RemindersTable,
          Reminder,
          $$RemindersTableFilterComposer,
          $$RemindersTableOrderingComposer,
          $$RemindersTableAnnotationComposer,
          $$RemindersTableCreateCompanionBuilder,
          $$RemindersTableUpdateCompanionBuilder,
          (Reminder, BaseReferences<_$AppDatabase, $RemindersTable, Reminder>),
          Reminder,
          PrefetchHooks Function()
        > {
  $$RemindersTableTableManager(_$AppDatabase db, $RemindersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RemindersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RemindersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RemindersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> time = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<String?> label = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => RemindersCompanion(
                id: id,
                time: time,
                enabled: enabled,
                label: label,
                sortOrder: sortOrder,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String time,
                Value<bool> enabled = const Value.absent(),
                Value<String?> label = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => RemindersCompanion.insert(
                id: id,
                time: time,
                enabled: enabled,
                label: label,
                sortOrder: sortOrder,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RemindersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RemindersTable,
      Reminder,
      $$RemindersTableFilterComposer,
      $$RemindersTableOrderingComposer,
      $$RemindersTableAnnotationComposer,
      $$RemindersTableCreateCompanionBuilder,
      $$RemindersTableUpdateCompanionBuilder,
      (Reminder, BaseReferences<_$AppDatabase, $RemindersTable, Reminder>),
      Reminder,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$QuestionsTableTableManager get questions =>
      $$QuestionsTableTableManager(_db, _db.questions);
  $$ExamSessionsTableTableManager get examSessions =>
      $$ExamSessionsTableTableManager(_db, _db.examSessions);
  $$DailyProgressTableTableManager get dailyProgress =>
      $$DailyProgressTableTableManager(_db, _db.dailyProgress);
  $$AnswerLogTableTableManager get answerLog =>
      $$AnswerLogTableTableManager(_db, _db.answerLog);
  $$CalendarMarksTableTableManager get calendarMarks =>
      $$CalendarMarksTableTableManager(_db, _db.calendarMarks);
  $$UserSettingsTableTableManager get userSettings =>
      $$UserSettingsTableTableManager(_db, _db.userSettings);
  $$RemindersTableTableManager get reminders =>
      $$RemindersTableTableManager(_db, _db.reminders);
}
