import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../models/quiz_question.dart';

/// 解説の誤り報告 (ErrorReport) — Firestore `error_reports` コレクションへ送信
///
/// ユーザーのメールアドレス等の個人情報は一切収集しない。
/// 送信失敗時は例外を投げるが、UI側でハンドリングして
/// アプリの動作自体には影響を与えない。
class ErrorReportService {
  ErrorReportService._();
  static final ErrorReportService instance = ErrorReportService._();

  Future<void> submitReport({
    required QuizQuestion question,
    required String category,
  }) async {
    try {
      String appVersion = '';
      try {
        final info = await PackageInfo.fromPlatform();
        appVersion = '${info.version}+${info.buildNumber}';
      } catch (_) {
        appVersion = 'unknown';
      }

      await FirebaseFirestore.instance.collection('error_reports').add({
        'question_id': question.id,
        'exam_type': question.examType,
        'year': question.year,
        'number': question.number,
        'category_name': question.categoryName,
        'report_category': category,
        'app_version': appVersion,
        'created_at': FieldValue.serverTimestamp(),
        'status': 'new',
      });
    } catch (e) {
      if (kDebugMode) {
        debugPrint('誤り報告の送信に失敗しました: $e');
      }
      rethrow;
    }
  }
}
