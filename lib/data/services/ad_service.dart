import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// AdMob バナー広告の広告ユニットID。
///
/// ⚠️ 現在は Google公式の「テスト広告ユニットID」です。
/// 本番リリース前に、AdMobコンソール (https://apps.admob.com/) で
/// 作成した実際の広告ユニットIDに置き換えてください。
/// テストIDのまま本番公開すると、実際の広告は配信されません
/// (テスト広告が表示され続けるため収益は発生しません)。
class AdUnitIds {
  // Android バナー広告 テストユニットID (Google公式)
  static const String androidBannerTest =
      'ca-app-pub-3940256099942544/6300978111';

  static String get banner {
    // 現状Androidのみサポート。Web/iOS等はAdService側でガードする。
    return androidBannerTest;
  }
}

/// google_mobile_ads のラッパー。
///
/// - 無料版ユーザーにのみバナー広告を表示する (有料版購入者には一切表示しない)
/// - Web platform では google_mobile_ads が対応していないため no-op
/// - 「広告は最小限」の方針に基づき、全画面広告(インタースティシャル)は使用せず
///   バナー広告のみを画面下部に控えめに表示する
class AdService {
  AdService._();
  static final AdService instance = AdService._();

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;
    if (kIsWeb) return; // Web platform は非対応
    try {
      await MobileAds.instance.initialize();
    } catch (e) {
      if (kDebugMode) debugPrint('AdService.init failed: $e');
    }
  }

  /// バナー広告をロードする。呼び出し側で dispose() を管理すること。
  /// Web platform や広告初期化前は null を返す。
  BannerAd? createBannerAd({
    required AdSize size,
    required void Function(Ad ad) onLoaded,
    void Function(Ad ad, LoadAdError error)? onFailed,
  }) {
    if (kIsWeb) return null;
    return BannerAd(
      adUnitId: AdUnitIds.banner,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: onLoaded,
        onAdFailedToLoad: (ad, error) {
          if (kDebugMode) debugPrint('Banner ad failed to load: $error');
          ad.dispose();
          onFailed?.call(ad, error);
        },
      ),
    )..load();
  }
}
