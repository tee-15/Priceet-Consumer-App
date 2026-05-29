import 'package:flutter_test/flutter_test.dart';
import 'package:priceet/main.dart';

void main() {
  testWidgets('App renders splash screen initially', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const PriceetApp());

    // Verify that the splash screen tagline text renders.
    expect(find.text('Priceet always finds the best deal for you.'), findsOneWidget);

    // Let the navigation timer complete to avoid pending timer exception.
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
  });
}
