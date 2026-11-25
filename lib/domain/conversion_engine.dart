import 'conversion_category.dart';

abstract final class ConversionEngine {
  static double convert(
    double value,
    ConversionCategory category,
    ConversionUnit from,
    ConversionUnit to,
  ) {
    if (category.kind == ConversionKind.currency) {
      throw ArgumentError(
        'Use an API CurrencyRates snapshot for currency conversion',
      );
    }
    if (category.kind != ConversionKind.temperature) {
      return value * from.factor / to.factor;
    }
    final celsius = switch (from.symbol) {
      '°F' => (value - 32) * 5 / 9,
      'K' => value - 273.15,
      _ => value,
    };
    return switch (to.symbol) {
      '°F' => celsius * 9 / 5 + 32,
      'K' => celsius + 273.15,
      _ => celsius,
    };
  }

  /// Indonesian display formatting; input remains a canonical decimal string.
  static String format(double value) {
    if (!value.isFinite) return '—';
    if (value == 0) return '0';
    if (value.abs() >= 1e15 || value.abs() < 0.000001) {
      return value.toStringAsExponential(5).replaceAll('.', ',');
    }
    final parts = value.toStringAsFixed(6).split('.');
    final fraction = parts[1].replaceFirst(RegExp(r'0+$'), '');
    final integer = parts[0].replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
    return fraction.isEmpty ? integer : '$integer,$fraction';
  }
}
