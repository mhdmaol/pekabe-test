import 'dart:convert';

import 'package:http/http.dart' as http;

import '../domain/currency_rates.dart';

abstract interface class CurrencyRateSource {
  Future<CurrencyRates> fetchLatest();
}

class FrankfurterRateSource implements CurrencyRateSource {
  FrankfurterRateSource({
    http.Client Function()? clientFactory,
    this.timeout = const Duration(seconds: 12),
  }) : _clientFactory = clientFactory ?? http.Client.new;
  final http.Client Function() _clientFactory;
  final Duration timeout;
  static final endpoint = Uri.https('api.frankfurter.dev', '/v2/rates', {
    'base': 'USD',
    'quotes': 'IDR,EUR,JPY',
  });

  @override
  Future<CurrencyRates> fetchLatest() async {
    final client = _clientFactory();
    try {
      final response = await client.get(endpoint).timeout(timeout);
      if (response.statusCode != 200) {
        throw StateError('Currency API HTTP ${response.statusCode}');
      }
      final json = jsonDecode(response.body);
      if (json is! List) throw const FormatException('Expected rate rows');
      final rates = <String, double>{'USD': 1};
      final dates = <String, DateTime>{};
      for (final code in ['IDR', 'EUR', 'JPY']) {
        final rows = json
            .where((row) => row is Map && row['quote'] == code)
            .toList();
        if (rows.length != 1) {
          throw FormatException('Missing or duplicate $code');
        }
        final row = rows.single as Map;
        final rate = row['rate'];
        final date = row['date'];
        if (row['base'] != 'USD' ||
            rate is! num ||
            !rate.isFinite ||
            rate <= 0 ||
            date is! String ||
            !RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(date)) {
          throw FormatException('Invalid $code rate');
        }
        final parsed = DateTime.tryParse(date);
        if (parsed == null ||
            parsed.toIso8601String().substring(0, 10) != date) {
          throw FormatException('Invalid $code date');
        }
        rates[code] = rate.toDouble();
        dates[code] = parsed;
      }
      return CurrencyRates(
        rates: rates,
        dates: dates,
        checkedAt: DateTime.now(),
      );
    } finally {
      client.close();
    }
  }
}
