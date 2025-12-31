import 'package:flutter_test/flutter_test.dart';

import 'package:islamicnoteapp/main.dart';

void main() {
  testWidgets('App builds without crashing', (WidgetTester tester) async {
    // Build the app tanpa const
    await tester.pumpWidget(IslamicNoteApp());

    // Cek apakah halaman Home muncul dengan Text 'Home - Jadwal Sholat'
    expect(find.text('Home - Jadwal Sholat'), findsOneWidget);
  });
}
