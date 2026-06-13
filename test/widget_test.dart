import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:k24_mvp/main.dart';

void main() {
  testWidgets('App launches with splash route', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: K24App(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(K24App), findsOneWidget);
  });
}
