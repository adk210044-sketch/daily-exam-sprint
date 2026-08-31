import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/zen_tokens.dart';

/// 試験実施機関・所管官庁の公式情報源URL
const String kExamAuthorityUrl = 'https://www.exam.or.jp/';
const String kMhlwUrl =
    'https://www.mhlw.go.jp/stf/seisakunitsuite/bunya/koyou_roudou/roudoukijun/anzen/anzeneisei22/index.html';

/// 本アプリについて(免責事項・公式情報源リンク)画面。
///
/// Google Play の「誤解を与える表現に関するポリシー」対応として、
/// 政府関連の情報(国家資格試験)を扱うアプリには
/// (1) 公式情報源への明確でアクセス可能なURLリンク
/// (2) 政府機関を代表しない旨の免責条項
/// の両方を、見やすい形でアプリ内に記載する必要があるための画面。
class DisclaimerScreen extends StatelessWidget {
  const DisclaimerScreen({super.key});

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ZenColors.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 20, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Padding(
                      padding: EdgeInsets.only(top: 2, right: 8),
                      child: Icon(
                        Icons.arrow_back,
                        size: 22,
                        color: ZenColors.inkSub,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      '本アプリについて',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: ZenColors.ink,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 0.5, color: ZenColors.line),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '「衛生管理者 1日9問」は、労働安全衛生法に基づく国家資格「衛生管理者」試験の学習を支援する、民間企業が提供する過去問学習アプリです。',
                      style: TextStyle(
                        fontSize: 13.5,
                        color: ZenColors.inkSub,
                        height: 1.9,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: ZenColors.card,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: ZenColors.line),
                      ),
                      child: const Text(
                        '本アプリは政府機関・地方公共団体および試験実施団体を代表するものではなく、これらの機関とは一切関係がありません。本アプリの開発・運営は、当社が独自に行っています。',
                        style: TextStyle(
                          fontSize: 13,
                          color: ZenColors.ink,
                          height: 1.8,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      '試験に関する公式情報',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: ZenColors.ink,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '試験の実施要項・受験資格・試験日程・合格発表・免許申請手続きなど、試験に関する公式な情報は、必ず以下の公式情報源でご確認ください。',
                      style: TextStyle(
                        fontSize: 13.5,
                        color: ZenColors.inkSub,
                        height: 1.9,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _officialLinkTile(
                      label: '試験実施機関',
                      name: '公益財団法人 安全衛生技術試験協会',
                      url: kExamAuthorityUrl,
                      onTap: () => _openUrl(kExamAuthorityUrl),
                    ),
                    const SizedBox(height: 10),
                    _officialLinkTile(
                      label: '所管官庁(労働安全衛生法関係)',
                      name: '厚生労働省',
                      url: kMhlwUrl,
                      onTap: () => _openUrl(kMhlwUrl),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      '収録問題について',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: ZenColors.ink,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '本アプリに収録している問題は、上記試験実施機関が公表した過去の試験問題(公表問題)を基に、当社が独自に解説を作成したものです。問題文・法令等の内容は出題当時のものであり、その後の法改正等により現在の内容と異なる場合があります。最新の法令・制度については、上記公式情報源や関連法令をご確認ください。',
                      style: TextStyle(
                        fontSize: 13.5,
                        color: ZenColors.inkSub,
                        height: 1.9,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _officialLinkTile({
    required String label,
    required String name,
    required String url,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: ZenColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ZenColors.line),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 11,
                      color: ZenColors.inkMute,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: ZenColors.ink,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    url,
                    style: const TextStyle(
                      fontSize: 11,
                      color: ZenColors.accent,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.open_in_new,
              size: 16,
              color: ZenColors.inkMute,
            ),
          ],
        ),
      ),
    );
  }
}
