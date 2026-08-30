import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'core/theme/zen_tokens.dart';
import 'data/database/app_database.dart';
import 'data/services/ad_service.dart';
import 'firebase_options.dart';
import 'providers/app_state.dart';
import 'providers/quiz_session_provider.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 解説の誤り報告機能 (Firestore) 用。失敗してもアプリ起動は継続する。
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    if (kDebugMode) {
      debugPrint('Firebase初期化に失敗しました: $e');
    }
  }
  // 日本語日付フォーマット (DateFormat('...', 'ja_JP')) を使うために必須
  await initializeDateFormatting('ja_JP');
  // 無料版ユーザー向けバナー広告の初期化 (Web platformではno-op)
  await AdService.instance.init();
  runApp(const ZenHabitApp());
}

class ZenHabitApp extends StatelessWidget {
  const ZenHabitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AppDatabase>(
          create: (_) => AppDatabase(),
          dispose: (_, db) => db.close(),
        ),
        ChangeNotifierProvider<AppState>(
          create: (context) => AppState(context.read<AppDatabase>())..init(),
        ),
        ChangeNotifierProvider<QuizSessionProvider>(
          create: (context) {
            final appState = context.read<AppState>();
            return QuizSessionProvider(appState.examRepo, appState.reviewRepo);
          },
        ),
      ],
      child: Consumer<AppState>(
        builder: (context, appState, _) {
          return MaterialApp(
            title: '衛生管理者 1日9問',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              useMaterial3: true,
              scaffoldBackgroundColor: ZenColors.bg,
              colorScheme: ColorScheme.fromSeed(
                seedColor: ZenColors.accent,
                brightness: Brightness.light,
              ).copyWith(primary: ZenColors.accent, surface: ZenColors.bg),
              fontFamily: 'Roboto',
              textTheme: const TextTheme().apply(
                bodyColor: ZenColors.ink,
                displayColor: ZenColors.ink,
              ),
              cardTheme: CardThemeData(
                color: ZenColors.card,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ZenColors.radiusCard),
                ),
              ),
              dialogTheme: DialogThemeData(backgroundColor: ZenColors.card),
            ),
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: TextScaler.linear(appState.textScale)),
                child: child!,
              );
            },
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
