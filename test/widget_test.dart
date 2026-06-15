import 'package:flutter_test/flutter_test.dart';
import 'package:streamvault/app.dart';

void main() {
  testWidgets('App renders smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const StreamVaultApp());
    expect(find.byType(StreamVaultApp), findsOneWidget);
  });
}
