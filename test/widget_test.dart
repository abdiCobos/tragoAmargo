import 'package:flutter_test/flutter_test.dart';
import 'package:hablando_de_cafe/app.dart';

void main() {
  testWidgets('App launches without errors', (WidgetTester tester) async {
    await tester.pumpWidget(const TragoAmargoApp());
    expect(find.text('Trago Amargo'), findsOneWidget);
  });
}
