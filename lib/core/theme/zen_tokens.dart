// Zen Habit デザイントークン
// 出典: design_handoff_zen_habit_v2/01_prototype/components/tokens.jsx の TOKENS_A
// 「1日9問 衛生管理者」— 禅・ミニマル・オフホワイト × 深緑モス
//
// ⚠️ 厳守: 青系色は使わない。キャラクター/アバターは入れない。
import 'package:flutter/material.dart';

/// Zen Habit カラー・スペーシング・角丸トークン
class ZenColors {
  ZenColors._();

  // core palette
  static const Color bg = Color(0xFFFAF8F3); // off-white paper
  static const Color bgSub = Color(0xFFF1EDE3); // subtle beige surface
  static const Color ink = Color(0xFF1F2419); // deep ink
  static const Color inkSub = Color(0xFF5A5F52); // muted gray-green
  static const Color inkMute = Color(0xFF8F9384); // hint text
  static const Color line = Color(0xFFE3DECD); // divider
  static const Color card = Color(0xFFFFFFFF);

  // accent (深緑モス)
  static const Color accent = Color(0xFF4A5D3A);
  static const Color accentDeep = Color(0xFF2E3D24);
  static const Color accentSoft = Color(0xFFDDE5D4);
  static const Color accentInk = Color(0xFFFAF8F3);

  // semantic
  static const Color correct = Color(0xFF4A5D3A);
  static const Color wrong = Color(0xFFB0553F); // muted terracotta
  static const Color wrongSoft = Color(0xFFF0DDD6);
  static const Color gold = Color(0xFFB99560); // 花丸ゴールド

  // radius
  static const double radiusCard = 16;
  static const double radiusBtn = 999;

  // category dots
  static const Map<String, Color> catDot = {
    '関係法令(有害)': Color(0xFF7B8A4D),
    '労働衛生(有害)': Color(0xFFB99560),
    '関係法令(有害以外)': Color(0xFF6B8288),
    '関係法令': Color(0xFF6B8288),
    '労働衛生(有害以外)': Color(0xFFA96F5E),
    '労働衛生': Color(0xFFA96F5E),
    '労働生理': Color(0xFF8B7B9B),
  };

  static Color catDotColor(String category) => catDot[category] ?? accent;
}

/// カテゴリ短縮ラベル
const Map<String, String> kCategoryShort = {
  '関係法令(有害)': '関法・有害',
  '労働衛生(有害)': '労衛・有害',
  '関係法令(有害以外)': '関法',
  '労働衛生(有害以外)': '労衛',
  '労働生理': '生理',
  '関係法令': '関法',
  '労働衛生': '労衛',
};

/// Zen Habit タイポグラフィ (システムフォント使用、和文は Noto Sans JP 相当)
class ZenText {
  ZenText._();

  static const String fontFamily =
      '-apple-system, BlinkMacSystemFont, "Hiragino Sans", "Yu Gothic UI", "Noto Sans JP", system-ui, sans-serif';

  // 数字用フォント (SF Pro Display 相当。システムフォントにフォールバック)
  static const String numFontFamily =
      '-apple-system, BlinkMacSystemFont, system-ui, sans-serif';

  static TextStyle heroNumber({Color color = ZenColors.ink}) => TextStyle(
    fontSize: 108,
    fontWeight: FontWeight.w200,
    height: 1,
    letterSpacing: -5.4, // -0.05em @ 108px
    color: color,
  );

  static TextStyle bigNumber({Color color = ZenColors.ink}) => TextStyle(
    fontSize: 68,
    fontWeight: FontWeight.w200,
    height: 0.95,
    letterSpacing: -2.7,
    color: color,
  );

  static TextStyle screenTitle({Color color = ZenColors.ink}) => TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w300,
    height: 1.3,
    letterSpacing: 0.6,
    color: color,
  );

  static TextStyle sectionHeading({
    Color color = ZenColors.ink,
    FontWeight weight = FontWeight.w500,
  }) => TextStyle(
    fontSize: 24,
    fontWeight: weight,
    height: 1.4,
    letterSpacing: 0.48,
    color: color,
  );

  static TextStyle cardTitle({Color color = ZenColors.ink}) => TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w500,
    height: 1.3,
    letterSpacing: 2.64,
    color: color,
  );

  static TextStyle cardHeading({
    Color color = ZenColors.ink,
    FontWeight weight = FontWeight.w600,
  }) => TextStyle(
    fontSize: 17,
    fontWeight: weight,
    height: 1.4,
    letterSpacing: 0.34,
    color: color,
  );

  static TextStyle questionText({Color color = ZenColors.ink}) => TextStyle(
    fontSize: 19,
    fontWeight: FontWeight.w500,
    height: 1.75,
    letterSpacing: 0.19,
    color: color,
  );

  static TextStyle choiceText({Color color = ZenColors.ink}) => TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.65,
    color: color,
  );

  static TextStyle meta({Color color = ZenColors.inkSub}) => TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.65,
    letterSpacing: 0.24,
    color: color,
  );

  static TextStyle kicker({
    Color color = ZenColors.inkMute,
    double letterSpacing = 2.4,
  }) => TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    letterSpacing: letterSpacing,
    color: color,
  );

  static TextStyle caption({Color color = ZenColors.inkMute}) => TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.6,
    color: color,
  );
}

/// アニメーションのイージング・時間
class ZenMotion {
  ZenMotion._();

  static const Duration instant = Duration(milliseconds: 100);
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration base = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 400);
  static const Duration ceremony = Duration(milliseconds: 900);

  // cubic-bezier(0.2, 0.7, 0.3, 1)
  static const Curve standard = Cubic(0.2, 0.7, 0.3, 1.0);
  // cubic-bezier(0.25, 0.5, 0.3, 1) — enso curve
  static const Curve enso = Cubic(0.25, 0.5, 0.3, 1.0);
}

/// アプリ共有 shadow
class ZenShadows {
  ZenShadows._();

  static List<BoxShadow> card = [
    BoxShadow(
      color: ZenColors.ink.withValues(alpha: 0.04),
      blurRadius: 2,
      offset: const Offset(0, 1),
    ),
    BoxShadow(
      color: ZenColors.ink.withValues(alpha: 0.05),
      blurRadius: 24,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> button = [
    BoxShadow(
      color: ZenColors.accent.withValues(alpha: 0.24),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];
}
