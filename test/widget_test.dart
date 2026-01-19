import 'package:flutter_test/flutter_test.dart';

import 'package:rental_app/app.dart'; // <-- use your App widget

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const App());

    // Verify that "Home" or your welcome text is shown.
    expect(find.text("Welcome to Home Page"), findsOneWidget);
  });
}
