// 基本的な起動確認テスト (Splash 画面が表示されることを確認)
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/main.dart';

void main() {
  testWidgets('App boots and shows splash', (WidgetTester tester) async {
    await tester.pumpWidget(const ZenHabitApp());
    await tester.pump();

    // Splash 画面のキーワードが表示されていることを確認
    expect(find.text('1日9問'), findsOneWidget);
  });
}
