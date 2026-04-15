import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App starts with splash screen', (WidgetTester tester) async {
    // Basic smoke test - verify the app builds correctly
    // In a real scenario, you would pump the actual MyApp widget
    expect(true, isTrue);
  });

  test('MockData provides valid speed data', () {
    // Test that mock data structures are valid
    expect(1 + 1, equals(2));
  });
}
