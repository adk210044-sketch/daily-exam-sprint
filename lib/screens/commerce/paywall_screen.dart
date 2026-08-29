import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/zen_tokens.dart';
import '../../data/services/purchase_service.dart';
import '../../providers/app_state.dart';
import '../../widgets/enso_circle.dart';
import '../main/legal_text_screen.dart';
import 'purchased_screen.dart';

/// Paywall (ZenPaywall) — ¥780 買い切りの明快な提示。
class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  bool _processing = false;
  bool _hasNavigated = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 購入が非同期に確定した (ストアからのコールバック) 際に、
    // AppState.purchased が true になったら自動的に完了画面へ遷移する。
    final appState = context.watch<AppState>();
    if (appState.purchased && !_hasNavigated) {
      _hasNavigated = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const PurchasedScreen()),
        );
      });
    }
    if (appState.purchaseErrorMessage != null) {
      final message = appState.purchaseErrorMessage!;
      appState.clearPurchaseError();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() => _processing = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      });
    }
  }

  Future<void> _purchase(BuildContext context) async {
    if (_processing) return;
    setState(() => _processing = true);
    final started = await PurchaseService.instance.buy();
    // buy() が false を返した場合は onPurchaseError 経由でメッセージが来るため、
    // ここでは起動できなかった場合のみ念のためローディングを解除する。
    if (!started && mounted) {
      setState(() => _processing = false);
    }
  }

  Future<void> _restore(BuildContext context) async {
    if (_processing) return;
    setState(() => _processing = true);
    await PurchaseService.instance.restore();
    if (mounted) setState(() => _processing = false);
  }

  void _openTerms(BuildContext context) {
    openLegalUrl(
      context,
      url: kTermsOfServiceUrl,
      title: '利用規約',
      fallbackBody: kTermsOfServiceText,
    );
  }

  void _openPrivacy(BuildContext context) {
    openLegalUrl(
      context,
      url: kPrivacyPolicyUrl,
      title: 'プライバシーポリシー',
      fallbackBody: kPrivacyPolicyText,
    );
  }

  @override
  Widget build(BuildContext context) {
    const features = [
      (title: '全過去問 解放', sub: '令和1年〜令和6年・全11回 · 400問以上'),
      (title: '選べる過去問', sub: '未着手・挑戦中・完走が一目でわかる'),
      (title: 'おかわり機能', sub: 'Day1〜5から好きな回を選んで解き直せる'),
      (title: '学習データを引き継ぎ', sub: '苦手・花丸・連続記録は、購入後もそのまま'),
    ];

    return Scaffold(
      backgroundColor: ZenColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(
                      Icons.close,
                      size: 22,
                      color: ZenColors.inkSub,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Hero
                    Padding(
                      padding: const EdgeInsets.fromLTRB(28, 20, 28, 0),
                      child: Column(
                        children: [
                          SizedBox(
                            width: 92,
                            height: 92,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                const EnsoCircle(
                                  size: 92,
                                  color: ZenColors.accent,
                                  strokeBase: 5,
                                ),
                                const Text(
                                  '◎',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: ZenColors.accent,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            'UPGRADE',
                            style: ZenText.kicker(letterSpacing: 3.2),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '過去 11回分の\n試験を、あなたの手に。',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w500,
                              height: 1.5,
                              letterSpacing: 0.4,
                              color: ZenColors.ink,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            '一度だけの買い切り。広告なし、サブスクなし。',
                            style: TextStyle(
                              fontSize: 12,
                              color: ZenColors.inkSub,
                              height: 1.75,
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                    // Feature list
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                      child: Column(
                        children: List.generate(features.length, (i) {
                          final f = features[i];
                          final isLast = i == features.length - 1;
                          return Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              border: isLast
                                  ? null
                                  : const Border(
                                      bottom: BorderSide(
                                        color: ZenColors.line,
                                        width: 0.5,
                                      ),
                                    ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(top: 2),
                                  child: Icon(
                                    Icons.check_circle,
                                    size: 20,
                                    color: ZenColors.accent,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        f.title,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: ZenColors.ink,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        f.sub,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: ZenColors.inkSub,
                                          height: 1.6,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                    // Compare table
                    _CompareTable(
                      dailyCount: context.watch<AppState>().dailyQuestionCount,
                    ),
                  ],
                ),
              ),
            ),
            // CTA
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 4, 24, 16),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: ElevatedButton(
                      onPressed: _processing ? null : () => _purchase(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ZenColors.accent,
                        foregroundColor: ZenColors.accentInk,
                        disabledBackgroundColor: ZenColors.accent.withValues(
                          alpha: 0.6,
                        ),
                        elevation: 0,
                        padding: EdgeInsets.zero,
                        alignment: Alignment.center,
                        minimumSize: const Size(double.infinity, 58),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            ZenColors.radiusBtn,
                          ),
                        ),
                      ),
                      child: _processing
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.4,
                                color: ZenColors.accentInk,
                              ),
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  'すべての過去問を解放する',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                const SizedBox(
                                  height: 22,
                                  child: VerticalDivider(
                                    color: ZenColors.accentInk,
                                    thickness: 1,
                                    width: 1,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Text(
                                  PurchaseService.instance.product?.price ??
                                      '¥780',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: _processing ? null : () => _restore(context),
                        child: const Text(
                          '復元',
                          style: TextStyle(
                            fontSize: 11,
                            color: ZenColors.inkMute,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      const Text(
                        '  ·  ',
                        style: TextStyle(
                          fontSize: 11,
                          color: ZenColors.inkMute,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _openTerms(context),
                        child: const Text(
                          '利用規約',
                          style: TextStyle(
                            fontSize: 11,
                            color: ZenColors.inkMute,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      const Text(
                        '  ·  ',
                        style: TextStyle(
                          fontSize: 11,
                          color: ZenColors.inkMute,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _openPrivacy(context),
                        child: const Text(
                          'プライバシー',
                          style: TextStyle(
                            fontSize: 11,
                            color: ZenColors.inkMute,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CompareTable extends StatelessWidget {
  final int dailyCount;
  const _CompareTable({required this.dailyCount});

  @override
  Widget build(BuildContext context) {
    final rows = [
      (label: '過去問', free: '直近2回分', paid: '全11回分'),
      (label: '解く回を選ぶ', free: 'no', paid: 'yes'),
      (label: '苦手復習', free: '$dailyCount問まで', paid: '問題数 無制限'),
      (label: 'おかわり機能', free: 'no', paid: 'yes'),
      (label: '広告', free: 'あり', paid: 'なし'),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
      child: Container(
        decoration: BoxDecoration(
          color: ZenColors.card,
          border: Border.all(color: ZenColors.line),
          borderRadius: BorderRadius.circular(ZenColors.radiusCard),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            // Header row
            Container(
              color: ZenColors.bgSub,
              child: Row(
                children: [
                  Expanded(
                    flex: 13,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      child: Text(
                        'COMPARE',
                        style: ZenText.kicker(letterSpacing: 1.4),
                      ),
                    ),
                  ),
                  const Expanded(
                    flex: 10,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        '無料',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          color: ZenColors.inkSub,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 10,
                    child: Container(
                      color: ZenColors.accent,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: const Text(
                        '有料',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          color: ZenColors.accentInk,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ...List.generate(rows.length, (i) {
              final r = rows[i];
              final isLast = i == rows.length - 1;
              return Container(
                decoration: BoxDecoration(
                  border: isLast
                      ? null
                      : const Border(
                          bottom: BorderSide(color: ZenColors.line, width: 0.5),
                        ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 13,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 11,
                        ),
                        child: Text(
                          r.label,
                          style: const TextStyle(
                            fontSize: 12,
                            color: ZenColors.ink,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 10,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 11),
                        child: _cell(r.free, isPaid: false),
                      ),
                    ),
                    Expanded(
                      flex: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 11),
                        color: ZenColors.accentSoft.withValues(alpha: 0.4),
                        child: _cell(r.paid, isPaid: true),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _cell(String value, {required bool isPaid}) {
    if (value == 'yes') {
      return Center(
        child: Icon(
          Icons.check,
          size: 16,
          color: isPaid ? ZenColors.accent : ZenColors.inkSub,
        ),
      );
    }
    if (value == 'no') {
      return const Center(
        child: Text(
          '—',
          style: TextStyle(fontSize: 14, color: ZenColors.inkMute),
        ),
      );
    }
    return Center(
      child: Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 11,
          color: isPaid ? ZenColors.accentDeep : ZenColors.inkSub,
          fontWeight: isPaid ? FontWeight.w600 : FontWeight.w400,
          height: 1.4,
        ),
      ),
    );
  }
}
