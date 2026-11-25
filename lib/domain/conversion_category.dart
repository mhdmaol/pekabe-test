import 'package:flutter/material.dart';

enum ConversionKind { currency, length, mass, temperature, volume, time, speed }

class ConversionUnit {
  const ConversionUnit(this.symbol, this.name, this.factor);
  final String symbol;
  final String name;

  /// Base units per unit; for currency this means USD per unit.
  final double factor;
}

class ConversionCategory {
  const ConversionCategory({
    required this.kind,
    required this.title,
    required this.subtitle,
    required this.symbol,
    required this.tag,
    required this.color,
    required this.tint,
    required this.units,
  });
  final ConversionKind kind;
  final String title, subtitle, symbol, tag;
  final Color color, tint;
  final List<ConversionUnit> units;
}

abstract final class ConversionCatalog {
  static const currency = ConversionCategory(
    kind: ConversionKind.currency,
    title: 'Mata Uang',
    subtitle: 'USD, IDR, EUR, JPY',
    symbol: r'$',
    tag: 'AKTIF',
    color: Color(0xFF2563EB),
    tint: Color(0xFFEFF6FF),
    units: [
      ConversionUnit('USD', 'Dolar Amerika', 1),
      ConversionUnit('IDR', 'Rupiah Indonesia', 1 / 18000),
      ConversionUnit('EUR', 'Euro', 1.08),
      ConversionUnit('JPY', 'Yen Jepang', 0.0067),
    ],
  );
  static const length = ConversionCategory(
    kind: ConversionKind.length,
    title: 'Satuan Ukuran',
    subtitle: 'cm, m, km, inch, ft',
    symbol: 'cm',
    tag: 'Metrik',
    color: Color(0xFF00AF46),
    tint: Color(0xFFEFFCF4),
    units: [
      ConversionUnit('cm', 'Sentimeter', 0.01),
      ConversionUnit('m', 'Meter', 1),
      ConversionUnit('km', 'Kilometer', 1000),
      ConversionUnit('inch', 'Inci', 0.0254),
      ConversionUnit('ft', 'Kaki', 0.3048),
    ],
  );
  static const mass = ConversionCategory(
    kind: ConversionKind.mass,
    title: 'Satuan Berat',
    subtitle: 'kg, gram, lbs, oz',
    symbol: 'kg',
    tag: 'Massa',
    color: Color(0xFF9333FF),
    tint: Color(0xFFFAF4FF),
    units: [
      ConversionUnit('kg', 'Kilogram', 1),
      ConversionUnit('gram', 'Gram', 0.001),
      ConversionUnit('lbs', 'Pon', 0.45359237),
      ConversionUnit('oz', 'Ons (avoirdupois)', 0.028349523125),
    ],
  );
  static const temperature = ConversionCategory(
    kind: ConversionKind.temperature,
    title: 'Satuan Suhu',
    subtitle: 'Celsius, F, Kelvin',
    symbol: '°C',
    tag: 'Thermal',
    color: Color(0xFFFA5400),
    tint: Color(0xFFFFF7ED),
    units: [
      ConversionUnit('°C', 'Celsius', 1),
      ConversionUnit('°F', 'Fahrenheit', 1),
      ConversionUnit('K', 'Kelvin', 1),
    ],
  );
  static const volume = ConversionCategory(
    kind: ConversionKind.volume,
    title: 'Satuan Volume',
    subtitle: 'Liter, ml, galon',
    symbol: 'L',
    tag: 'Cairan',
    color: Color(0xFF0891B2),
    tint: Color(0xFFECFDFF),
    units: [
      ConversionUnit('L', 'Liter', 1),
      ConversionUnit('ml', 'Mililiter', 0.001),
      ConversionUnit('gal', 'Galon AS', 3.785411784),
    ],
  );
  static const time = ConversionCategory(
    kind: ConversionKind.time,
    title: 'Waktu & Speed',
    subtitle: 'Jam, menit, km/h',
    symbol: '•••',
    tag: 'Waktu',
    color: Color(0xFFEC187D),
    tint: Color(0xFFFDF2F8),
    units: [
      ConversionUnit('jam', 'Jam', 3600),
      ConversionUnit('menit', 'Menit', 60),
      ConversionUnit('detik', 'Detik', 1),
    ],
  );
  static const speed = ConversionCategory(
    kind: ConversionKind.speed,
    title: 'Kecepatan',
    subtitle: 'km/h, m/s, mph',
    symbol: '•••',
    tag: 'Speed',
    color: Color(0xFFEC187D),
    tint: Color(0xFFFDF2F8),
    units: [
      ConversionUnit('km/h', 'Kilometer per jam', 1 / 3.6),
      ConversionUnit('m/s', 'Meter per detik', 1),
      ConversionUnit('mph', 'Mil per jam', 0.44704),
    ],
  );
  static const categories = [currency, length, mass, temperature, volume, time];
}
