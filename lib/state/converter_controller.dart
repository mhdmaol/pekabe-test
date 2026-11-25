import 'package:flutter/foundation.dart';

import '../domain/conversion_category.dart';
import '../domain/conversion_engine.dart';

class ConverterController extends ChangeNotifier {
  ConverterController(this.category)
    : from = category.units.first,
      to = category.units[1];
  ConversionCategory category;
  ConversionUnit from, to;
  String input = '1';
  double get value => double.tryParse(input) ?? 0;
  double get result => ConversionEngine.convert(value, category, from, to);
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
