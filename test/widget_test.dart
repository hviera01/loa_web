import 'package:flutter_test/flutter_test.dart';
import 'package:love_web/main.dart';

void main() {
  testWidgets('app boots', (WidgetTester tester) async {
    await tester.pumpWidget(const LoveApp());
    await tester.pump();
  });
}
