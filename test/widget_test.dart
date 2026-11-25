import 'package:flutter_test/flutter_test.dart';
import 'package:laundry_hub/counter_logic.dart';
import 'package:laundry_hub/main.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  group('parseInput', () {
    test('positive and negative integers become AddCommand', () {
      expect(
        parseInput('5'),
        isA<AddCommand>().having((c) => c.value, 'value', 5),
      );
      expect(
        parseInput(' -3 '),
        isA<AddCommand>().having((c) => c.value, 'value', -3),
      );
    });

    test('exact phrase becomes ResetCommand', () {
      expect(parseInput('Avada Kedavra'), isA<ResetCommand>());
    });

    test('anything else is InvalidCommand', () {
      for (final input in ['', 'abc', '2.5', '0x10', '1 2', 'avada kedavra']) {
        expect(parseInput(input), isA<InvalidCommand>(), reason: input);
      }
    });
  });

  testWidgets('counter adds, ignores invalid input and resets', (tester) async {
    await tester.pumpWidget(const MyApp());
    final field = find.byKey(const Key('inputField'));
    final button = find.byKey(const Key('applyButton'));

    expect(find.text('0'), findsOneWidget);

    await tester.enterText(field, '7');
    await tester.tap(button);
    await tester.pump();
    expect(find.text('7'), findsOneWidget);

    await tester.enterText(field, 'abc');
    await tester.tap(button);
    await tester.pump();
    expect(find.text('7'), findsOneWidget);
    expect(find.byType(SnackBar), findsOneWidget);

    await tester.enterText(field, 'Avada Kedavra');
    await tester.tap(button);
    await tester.pump();
    expect(find.text('0'), findsOneWidget);
  });
}
