import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart' hide AppState;
import 'package:provider/provider.dart';

import '../core/theme/zen_tokens.dart';
import '../data/services/ad_service.dart';
import '../providers/app_state.dart';

/// 無料版ユーザーにのみ表示するバナー広告ウィジェット。
///
/// - 有料版購入済みユーザー ([AppState.purchased] == true) には何も表示しない
///   (高さ0、レイアウトへの影響なし)
/// - Web platform では google_mobile_ads が非対応のため何も表示しない
/// - 広告のロードに失敗した場合も何も表示しない (エラーで画面が壊れないように)
class AdBannerWidget extends StatefulWidget {
  const AdBannerWidget({super.key});

  @override
  State<AdBannerWidget> createState() => _AdBannerWidgetState();
}

class _AdBannerWidgetState extends State<AdBannerWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  bool _requested = false;

  void _loadAd() {
    if (_requested || kIsWeb) return;
    _requested = true;
    final ad = AdService.instance.createBannerAd(
      size: AdSize.banner,
      onLoaded: (_) {
        if (!mounted) return;
        setState(() => _isLoaded = true);
      },
      onFailed: (_, _) {
        if (!mounted) return;
        setState(() {
          _isLoaded = false;
          _bannerAd = null;
        });
      },
    );
    _bannerAd = ad;
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final purchased = context.watch<AppState>().purchased;
    if (purchased || kIsWeb) {
      // 有料版ユーザー or Web platform には広告を表示しない
      return const SizedBox.shrink();
    }

    if (!_requested) {
      // build後にロード開始 (build中にsetStateを避けるため次フレームで実行)
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadAd());
    }

    final ad = _bannerAd;
    if (!_isLoaded || ad == null) {
      return const SizedBox.shrink();
    }

    return Container(
      width: ad.size.width.toDouble(),
      height: ad.size.height.toDouble(),
      alignment: Alignment.center,
      color: ZenColors.bg,
      child: AdWidget(ad: ad),
    );
  }
}
