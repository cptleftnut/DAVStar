import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:davstar/providers/app_provider.dart';
import 'package:davstar/main.dart';

void main() {
  testWidgets('DAVSTar app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AppProvider(),
        child: const DavStarApp(),
      ),
    );

    expect(find.text('Tarot-læsning'), findsOneWidget);
    expect(find.text('Tarot'), findsOneWidget);
    expect(find.text('Astrologi'), findsOneWidget);
    expect(find.text('Horoskop'), findsOneWidget);
    expect(find.text('Historik'), findsOneWidget);
  });
}
