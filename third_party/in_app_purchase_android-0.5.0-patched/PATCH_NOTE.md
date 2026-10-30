# パッチについて

このディレクトリは pub.dev 公式パッケージ `in_app_purchase_android` の
**バージョン 0.5.0** のソースをそのまま取り込み、`pubspec.yaml` の
`environment.sdk` 制約だけを `^3.10.0` → `^3.9.0` に緩和したものです。

## なぜ必要か

- Google Play は 2026年11月1日までに Google Play Billing Library
  **8.0.0 以降**への対応を全アプリに要求している。
- `in_app_purchase_android` は **0.5.0** で初めて Billing Library を
  7.1.1 → **8.0.0** に更新した（それ以前の 0.4.0+10 / 0.4.0+11 は
  7.1.1 のまま）。
- しかし 0.5.0 は Dart SDK `^3.10.0` を要求しており、本サンドボックス
  環境は Dart **3.9.2** 固定のため、公式パッケージをそのまま使うと
  `flutter build` が
  `The language version 3.10 specified for the package
  'in_app_purchase_android' is too high` で失敗する。
- 0.5.0 の実装自体（Kotlin/Java側のネイティブコード、Dart API）は
  3.9 環境でも問題なくコンパイル・動作することを確認済み
  （実際に `flutter analyze` / `flutter build appbundle --release`
  の両方が成功し、生成された AAB 内の `billing.properties` で
  `billing_client=8.0.0` を確認済み）。
- そのため、言語バージョン制約の数字だけを緩和したローカルコピーを
  `dependency_overrides` で読み込ませている。

## 変更点

- `pubspec.yaml` の1箇所のみ変更:
  ```diff
  environment:
  -  sdk: ^3.10.0
  +  sdk: ^3.9.0
  ```
  それ以外のコード・ロジックは pub.dev 公開版 0.5.0 と完全に同一。

## 今後について

- Flutter/Dart SDKを 3.10 以上にアップグレードできるようになったら、
  このパッチは不要になる。その際は `pubspec.yaml` の
  `dependency_overrides` セクションを削除し、
  `in_app_purchase_android` を pub.dev 公式の最新版に任せてよい。
- このディレクトリ自体も削除して問題ない。
