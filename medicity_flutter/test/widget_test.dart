import 'package:flutter_test/flutter_test.dart';
import 'package:medicity_flutter/main.dart';

void main() {
  testWidgets('La app muestra Medicity', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Medicity'), findsOneWidget);
  });
}
