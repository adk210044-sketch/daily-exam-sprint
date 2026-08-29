import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

/// 買い切り (非消耗型) 課金の商品ID。
/// App Store Connect / Google Play Console 側で、この文字列と一致する
/// 「アプリ内購入商品(Non-Consumable / 買い切り)」を作成しておくこと。
const String kUnlockAllProductId = 'unlock_all_exams';

/// 購入結果を呼び出し元に伝えるためのステータス。
enum PurchaseResult { success, pending, error, cancelled }

/// in_app_purchase パッケージのラッパー。
/// - 商品情報の取得
/// - 購入フローの開始
/// - 購入の復元 (restore)
/// - 購入完了イベントの監視
///
/// Web platform では in_app_purchase が対応していないため、
/// 全メソッドは no-op / 失敗として振る舞う (kIsWeb ガード)。
class PurchaseService {
  PurchaseService._();
  static final PurchaseService instance = PurchaseService._();

  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  bool _initialized = false;
  bool _storeAvailable = false;
  ProductDetails? _product;

  /// 購入 (または復元) が確定した時に呼ばれるコールバック。
  /// main.dart / AppState から登録し、DBの purchased フラグを立てる。
  void Function()? onPurchaseSuccess;

  /// エラー発生時に呼ばれるコールバック (UIへのSnackBar表示等に利用)。
  void Function(String message)? onPurchaseError;

  bool get storeAvailable => _storeAvailable;
  ProductDetails? get product => _product;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    if (kIsWeb) {
      // Web platform は in_app_purchase 非対応。常に無効。
      _storeAvailable = false;
      return;
    }

    _storeAvailable = await _iap.isAvailable();
    if (!_storeAvailable) return;

    // 購入イベントの監視を開始 (アプリ起動中は常時リスニング)
    _subscription = _iap.purchaseStream.listen(
      _handlePurchaseUpdates,
      onError: (Object error) {
        onPurchaseError?.call('購入処理中にエラーが発生しました: $error');
      },
    );

    await _loadProduct();
  }

  Future<void> _loadProduct() async {
    try {
      final response = await _iap.queryProductDetails({kUnlockAllProductId});
      if (response.error != null) {
        if (kDebugMode) {
          debugPrint('IAP queryProductDetails error: ${response.error}');
        }
        return;
      }
      if (response.productDetails.isNotEmpty) {
        _product = response.productDetails.first;
      }
      if (response.notFoundIDs.isNotEmpty && kDebugMode) {
        debugPrint('IAP product not found on store: ${response.notFoundIDs}');
      }
    } catch (e) {
      if (kDebugMode) debugPrint('IAP _loadProduct exception: $e');
    }
  }

  /// 購入を開始する。ストア側のUIが起動し、結果は purchaseStream 経由で
  /// 非同期に通知される (このメソッド自体は起動できたかのみを返す)。
  Future<bool> buy() async {
    if (kIsWeb || !_storeAvailable) {
      onPurchaseError?.call('この環境では購入機能を利用できません。');
      return false;
    }
    if (_product == null) {
      // 商品情報が未取得なら再取得を試みる
      await _loadProduct();
    }
    if (_product == null) {
      onPurchaseError?.call('商品情報を取得できませんでした。通信環境をご確認ください。');
      return false;
    }
    final purchaseParam = PurchaseParam(productDetails: _product!);
    try {
      return await _iap.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      onPurchaseError?.call('購入を開始できませんでした: $e');
      return false;
    }
  }

  /// 過去の購入を復元する (機種変更・再インストール時等)。
  Future<void> restore() async {
    if (kIsWeb || !_storeAvailable) {
      onPurchaseError?.call('この環境では復元機能を利用できません。');
      return;
    }
    try {
      await _iap.restorePurchases();
    } catch (e) {
      onPurchaseError?.call('復元に失敗しました: $e');
    }
  }

  void _handlePurchaseUpdates(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      switch (purchase.status) {
        case PurchaseStatus.pending:
          // 支払い承認待ち等。UIでローディング表示する場合はここで通知可能。
          break;
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          onPurchaseSuccess?.call();
          if (purchase.pendingCompletePurchase) {
            _iap.completePurchase(purchase);
          }
          break;
        case PurchaseStatus.error:
          onPurchaseError?.call(purchase.error?.message ?? '購入処理でエラーが発生しました。');
          if (purchase.pendingCompletePurchase) {
            _iap.completePurchase(purchase);
          }
          break;
        case PurchaseStatus.canceled:
          if (purchase.pendingCompletePurchase) {
            _iap.completePurchase(purchase);
          }
          break;
      }
    }
  }

  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    _initialized = false;
  }
}
