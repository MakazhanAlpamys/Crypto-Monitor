import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crypto_tracker/main.dart';

void main() {
  testWidgets('App should build without errors', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: CryptoApp(),
      ),
    );

    // Verify that the app builds successfully
    expect(find.byType(CryptoApp), findsOneWidget);
  });
}
