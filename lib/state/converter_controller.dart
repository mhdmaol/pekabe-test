import 'package:flutter/foundation.dart';

import '../domain/conversion_category.dart';
import '../domain/currency_rates.dart';
import '../data/currency_rate_source.dart';
import '../domain/conversion_engine.dart';

class ConverterController extends ChangeNotifier {
  ConverterController(this.category, {CurrencyRateSource? rateSource})
    : _rateSource = rateSource ?? FrankfurterRateSource(),
      from = category.units.first,
      to = category.units[1];
  ConversionCategory category;
  ConversionUnit from, to;
  String input = '1';
  double get value => double.tryParse(input) ?? 0;
  final CurrencyRateSource _rateSource;
  CurrencyRates? currencyRates;
  bool isLoadingRates = false;
  String? rateError;
  bool _disposed = false;
  double get result => category.kind == ConversionKind.currency
      ? currencyRates?.convert(value, from.symbol, to.symbol) ?? double.nan
      : ConversionEngine.convert(value, category, from, to);

  Future<void> refreshRates() async {
    if (_disposed ||
        isLoadingRates ||
        category.kind != ConversionKind.currency) {
      return;
    }
    isLoadingRates = true;
    rateError = null;
    notifyListeners();
    try {
      final snapshot = await _rateSource.fetchLatest();
      if (!_disposed) currencyRates = snapshot;
    } catch (_) {
      if (!_disposed) {
        rateError = currencyRates == null
            ? 'Kurs belum tersedia. Periksa koneksi lalu coba lagi.'
            : 'Pembaruan gagal. Menggunakan kurs terakhir yang berhasil dimuat.';
      }
    } finally {
      if (!_disposed) {
        isLoadingRates = false;
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  String get displayInput => input.replaceAll('.', ',');
  void enter(String key) {
    if (key == 'backspace') {
      input = input.length <= 1 || (input.length == 2 && input.startsWith('-'))
          ? '0'
          : input.substring(0, input.length - 1);
    } else if (key == 'clear') {
      input = '0';
    } else if (key == 'sign') {
      if (value != 0) {
        input = input.startsWith('-') ? input.substring(1) : '-$input';
      }
    } else if (key == '.') {
      if (!input.contains('.')) input += '.';
    } else if (RegExp(r'^\d$').hasMatch(key) &&
        input.replaceAll(RegExp(r'[-.]'), '').length < 12) {
      input = input == '0' ? key : input + key;
    }
    notifyListeners();
  }

  void selectFrom(ConversionUnit unit) {
    from = unit;
    notifyListeners();
  }

  void selectTo(ConversionUnit unit) {
    to = unit;
    notifyListeners();
  }

  /// Reverse the unit pair while preserving the entered source amount.
  void swap() {
    final old = from;
    from = to;
    to = old;
    notifyListeners();
  }

  void setCategory(ConversionCategory next) {
    category = next;
    from = next.units.first;
    to = next.units[1];
    notifyListeners();
  }
}
