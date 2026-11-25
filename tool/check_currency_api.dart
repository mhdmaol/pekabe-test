import 'dart:io';

import 'package:pekabe_converter/data/currency_rate_source.dart';

Future<void> main() async {
  final rates = await FrankfurterRateSource().fetchLatest();
  for (final code in ['IDR', 'EUR', 'JPY']) {
    stdout.writeln(
      '1 USD = ${rates.convert(1, 'USD', code)} $code; date: ${rates.dates[code]!.toIso8601String().substring(0, 10)}',
    );
  }
}
