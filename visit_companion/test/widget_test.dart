import 'package:flutter_test/flutter_test.dart';
import 'package:visit_companion/app/app.dart';

void main() {
  testWidgets('Home shell renders', (WidgetTester tester) async {
    await tester.pumpWidget(const VisitCompanionApp());
    await tester.pumpAndSettle();

    expect(find.text('Visit Companion'), findsOneWidget);
    expect(find.text('Welcome back'), findsOneWidget);
  });
}
