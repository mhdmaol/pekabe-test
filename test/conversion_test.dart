import 'package:flutter_test/flutter_test.dart';
import 'package:pekabe_converter/domain/conversion_category.dart';
import 'package:pekabe_converter/domain/conversion_engine.dart';
import 'package:pekabe_converter/state/converter_controller.dart';

void main() {
  double convert(ConversionCategory c, double value, String from, String to) =>
      ConversionEngine.convert(
        value,
        c,
        c.units.firstWhere((u) => u.symbol == from),
        c.units.firstWhere((u) => u.symbol == to),
      );
  test('Known unit conversions including affine temperatures', () {
    expect(
      convert(ConversionCatalog.length, 1, 'inch', 'cm'),
      closeTo(2.54, 0.0001),
    );
    expect(
      convert(ConversionCatalog.mass, 1, 'lbs', 'kg'),
      closeTo(0.45359237, 0.000001),
    );
    expect(
      convert(ConversionCatalog.volume, 1, 'gal', 'L'),
      closeTo(3.785411784, 0.000001),
    );
    expect(convert(ConversionCatalog.time, 2, 'jam', 'menit'), 120);
    expect(
      convert(ConversionCatalog.speed, 36, 'km/h', 'm/s'),
      closeTo(10, 0.00001),
    );
    expect(convert(ConversionCatalog.temperature, 32, '°F', '°C'), 0);
    expect(convert(ConversionCatalog.temperature, -40, '°C', '°F'), -40);
    expect(convert(ConversionCatalog.temperature, 0, '°C', 'K'), 273.15);
  });
  test('Every pair round trips', () {
    for (final c in [
      ...ConversionCatalog.categories.where(
        (c) => c.kind != ConversionKind.currency,
      ),
      ConversionCatalog.speed,
    ]) {
      for (final from in c.units) {
        for (final to in c.units) {
          final result = ConversionEngine.convert(123.456, c, from, to);
          expect(
            ConversionEngine.convert(result, c, to, from),
            closeTo(123.456, 1e-8),
          );
        }
      }
    }
  });
  test('Indonesian numeric display', () {
    expect(ConversionEngine.format(18000), '18.000');
    expect(ConversionEngine.format(-1234.56), '-1.234,56');
    expect(ConversionEngine.format(0), '0');
    expect(ConversionEngine.format(0.00000001), '1,00000e-8');
  });
  test('Input editing, sign, decimal guard, precision cap and reverse', () {
    final c = ConverterController(ConversionCatalog.temperature);
    addTearDown(c.dispose);
    c.enter('clear');
    c.enter('.');
    c.enter('.');
    c.enter('5');
    expect(c.input, '0.5');
    c.enter('sign');
    expect(c.value, -0.5);
    c.enter('backspace');
    c.enter('backspace');
    c.enter('backspace');
    expect(c.input, '0');
    c.enter('clear');
    for (var i = 0; i < 20; i++) {
      c.enter('9');
    }
    expect(c.input.length, 12);
    c.swap();
    expect(c.from.symbol, '°F');
    expect(c.to.symbol, '°C');
    c.setCategory(ConversionCatalog.speed);
    expect(c.from.symbol, 'km/h');
  });
}
