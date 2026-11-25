/// One validated USD-based API snapshot. Values are quote units per USD.
class CurrencyRates {
  CurrencyRates({
    required Map<String, double> rates,
    required Map<String, DateTime> dates,
    required this.checkedAt,
  }) : rates = Map.unmodifiable(rates),
       dates = Map.unmodifiable(dates);
  final Map<String, double> rates;
  final Map<String, DateTime> dates;
  final DateTime checkedAt;
  double convert(double amount, String from, String to) =>
      amount / rates[from]! * rates[to]!;
}
