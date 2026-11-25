import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pekabe_converter/app.dart';
import 'package:pekabe_converter/components/molecules/category_card/category_card.dart';
import 'package:pekabe_converter/components/molecules/conversion_field/conversion_field.dart';

void main() {
  testWidgets('Category navigation, keypad, unit selection, swap and reset', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const PekabeApp());
    expect(find.byType(CategoryCard), findsNWidgets(6));
    await tester.tap(find.text('Mata Uang'));
    await tester.pumpAndSettle();
    expect(find.text('18.000'), findsOneWidget);
    await tester.tap(find.text('2'));
    await tester.pump();
    expect(find.text('216.000'), findsOneWidget);
    await tester.tap(find.byTooltip('Tukar satuan'));
    await tester.pump();
    expect(
      tester
          .widget<ConversionField>(find.byType(ConversionField).first)
          .selected
          .symbol,
      'IDR',
    );
    await tester.tap(find.text('Reset'));
    await tester.pump();
    expect(
      tester.widget<ConversionField>(find.byType(ConversionField).first).value,
      '0',
    );
    await tester.tap(find.byType(DropdownButtonHideUnderline).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('EUR').last);
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<ConversionField>(find.byType(ConversionField).first)
          .selected
          .symbol,
      'EUR',
    );
    await tester.tap(find.byTooltip('Kembali'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Ganti tema'));
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.byType(CategoryCard).first)).brightness,
      Brightness.dark,
    );
    expect(tester.takeException(), isNull);
  });
  for (final size in [
    const Size(320, 568),
    const Size(390, 844),
    const Size(1024, 768),
  ]) {
    testWidgets('All categories without overflow at $size', (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(const PekabeApp());
      for (final title in [
        'Mata Uang',
        'Satuan Ukuran',
        'Satuan Berat',
        'Satuan Suhu',
        'Satuan Volume',
        'Waktu & Speed',
      ]) {
        await tester.ensureVisible(find.text(title));
        await tester.tap(find.text(title));
        await tester.pumpAndSettle();
        expect(find.byType(ConversionField), findsNWidgets(2));
        expect(tester.takeException(), isNull);
        await tester.tap(find.byTooltip('Kembali'));
        await tester.pumpAndSettle();
      }
    });
  }
}
