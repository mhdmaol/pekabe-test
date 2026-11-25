import 'package:pekabe_converter/data/currency_rate_source.dart';
import 'package:pekabe_converter/domain/currency_rates.dart';

class FixtureRateSource implements CurrencyRateSource {
  @override
  Future<CurrencyRates> fetchLatest() async => CurrencyRates(
    rates: {'USD': 1, 'IDR': 18235, 'EUR': 0.91323, 'JPY': 159.24},
    dates: {
      for (final c in ['IDR', 'EUR', 'JPY']) c: DateTime(2026, 11, 25),
    },
    checkedAt: DateTime(2026, 11, 25, 12),
  );
}
