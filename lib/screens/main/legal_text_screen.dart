import 'package:flutter/material.dart';

import '../../core/theme/zen_tokens.dart';

/// 利用規約・プライバシーポリシー等の静的テキスト表示画面 (共通)
class LegalTextScreen extends StatelessWidget {
  final String title;
  final String body;

  const LegalTextScreen({super.key, required this.title, required this.body});

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
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
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
                child: Text(
                  body,
                  style: const TextStyle(
                    fontSize: 13.5,
                    color: ZenColors.inkSub,
                    height: 1.9,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const String kTermsOfServiceText = '''
第1条(適用)
本規約は、本アプリ「1日9問 衛生管理者」(以下「本アプリ」)の利用に関する条件を定めるものです。本アプリをダウンロード・利用することで、ユーザーは本規約に同意したものとみなされます。

第2条(サービス内容)
本アプリは、衛生管理者試験(第1種・第2種)の過去問題を1日単位で学習できる、買い切り課金制の学習支援アプリです。無料期間終了後、追加のコンテンツを利用するには、アプリ内購入(買い切り)が必要です。

第3条(利用料金)
本アプリの購入は買い切り課金制です。サブスクリプション(自動更新の定期課金)は一切採用していません。購入後の返金については、ご利用のストア(Google Play等)の返金ポリシーに従います。

第4条(禁止事項)
ユーザーは、本アプリの利用にあたり、以下の行為を行ってはなりません。
・本アプリの逆コンパイル、逆アセンブル、リバースエンジニアリング
・本アプリのコンテンツ(問題・解説等)を無断で複製・転載・再配布する行為
・その他、運営者が不適切と判断する行為

第5条(免責事項)
本アプリに掲載する問題・解説は、公表されている試験情報等を基に作成していますが、その正確性・完全性・最新性を保証するものではありません。本アプリの利用により生じた学習結果、試験結果その他の損害について、運営者は責任を負いません。

第6条(データの取扱い)
本アプリの学習データ(進捗・回答履歴・設定等)は、ユーザーの端末内にのみ保存されます。運営者が外部サーバーに送信・収集することはありません。

第7条(規約の変更)
運営者は、必要に応じて本規約を変更することがあります。変更後の規約は、本アプリ内に表示した時点で効力を生じます。

第8条(お問い合わせ)
本規約に関するお問い合わせは、ストアの提供する連絡手段よりご連絡ください。

制定日: 2025年1月1日
''';

const String kPrivacyPolicyText = '''
本アプリ「1日9問 衛生管理者」(以下「本アプリ」)における、ユーザー情報の取扱いについて以下のとおり定めます。

1. 収集する情報
本アプリは、氏名・メールアドレス・電話番号等の個人を特定できる情報を収集しません。アカウント登録機能も提供していません。

2. 端末内に保存される情報
本アプリの学習進捗、回答履歴、リマインダー設定、フォントサイズ等の設定情報は、すべてユーザーの端末内のローカルストレージにのみ保存されます。これらの情報は外部サーバーへ送信・アップロードされることはありません。

3. 通知機能
本アプリでは、ユーザーが設定したリマインダー時刻に応じて、端末のローカル通知機能を利用してリマインダーを表示します。通知の送信に外部サービスは使用していません。

4. 広告について
本アプリは広告を表示しません。

5. 第三者への提供
本アプリは、収集した情報(端末内データを含む)を第三者に提供・共有することはありません。

6. アプリ内購入
本アプリの購入(買い切り課金)は、ご利用のストア(Google Play等)の決済システムを通じて処理されます。決済に関する情報は各ストアのプライバシーポリシーに従って取り扱われます。

7. データの削除
本アプリをアンインストールすることで、端末内に保存された全ての学習データ・設定情報は削除されます。

8. 本ポリシーの変更
本ポリシーは、必要に応じて変更することがあります。変更後の内容は、本アプリ内に表示した時点で効力を生じます。

9. お問い合わせ
本ポリシーに関するお問い合わせは、ストアの提供する連絡手段よりご連絡ください。

制定日: 2025年1月1日
''';
