import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pekabe_converter/app.dart';
import 'package:pekabe_converter/components/organisms/converter_panel/converter_panel.dart';

void main() {
  testWidgets('Capture review previews', (tester) async {
    tester.view.physicalSize = const Size(390, 920);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final fonts = FontLoader('Roboto')
      ..addFont(rootBundle.load('assets/fonts/roboto-regular.ttf'))
      ..addFont(rootBundle.load('assets/fonts/roboto-bold.ttf'));
    await fonts.load();
    await (FontLoader(
      'MaterialIcons',
    )..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'))).load();
    final key = GlobalKey();
    await tester.pumpWidget(
      RepaintBoundary(key: key, child: const PekabeApp()),
    );
    await tester.pumpAndSettle();
    Future<void> capture(String name) async {
      await tester.runAsync(() async {
        final boundary =
            key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
        final image = await boundary.toImage(pixelRatio: 2);
        final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
        await Directory('previews').create(recursive: true);
        await File('previews/$name.png')
            .writeAsBytes(bytes!.buffer.asUint8List());
        image.dispose();
      });
    }

    await capture('categories_mobile');
    await tester.tap(find.text('Mata Uang'));
    await tester.pumpAndSettle();
    await capture('currency_mobile');
    await tester.tap(find.byTooltip('Kembali'));
    await tester.pumpAndSettle();
    for (final config in [
      ('Satuan Ukuran', 'km', 'cm', '2', 'length_mobile'),
      ('Satuan Berat', 'kg', 'gram', '5', 'mass_mobile'),
    ]) {
      await tester.ensureVisible(find.text(config.$1));
      await tester.tap(find.text(config.$1));
      await tester.pumpAndSettle();
      final controller = tester
          .widget<ConverterPanel>(find.byType(ConverterPanel))
          .controller;
      controller.selectFrom(
        controller.category.units.firstWhere((u) => u.symbol == config.$2),
      );
      controller.selectTo(
        controller.category.units.firstWhere((u) => u.symbol == config.$3),
      );
      controller.enter('clear');
      controller.enter(config.$4);
      await tester.pumpAndSettle();
      await capture(config.$5);
      await tester.tap(find.byTooltip('Kembali'));
      await tester.pumpAndSettle();
    }
    tester.view.physicalSize = const Size(1024, 768);
    await tester.pumpAndSettle();
    await capture('categories_desktop');
    expect(tester.takeException(), isNull);
  }, skip: !const bool.fromEnvironment('CAPTURE_PREVIEWS'));
}
