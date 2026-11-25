import 'package:flutter/material.dart';

import '../../../domain/conversion_category.dart';
import '../../atoms/value_input/value_input.dart';

class ConversionField extends StatelessWidget {
  const ConversionField({
    super.key,
    required this.units,
    required this.selected,
    required this.value,
    required this.onChanged,
    this.isResult = false,
  });
  final List<ConversionUnit> units;
  final ConversionUnit selected;
  final String value;
  final ValueChanged<ConversionUnit> onChanged;
  final bool isResult;
  @override
  Widget build(BuildContext context) => Container(
    height: 66,
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      color: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF202C40)
          : const Color(0xFFF5F5F5),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(
        color: Theme.of(context).dividerColor.withValues(alpha: 0.12),
      ),
    ),
    child: Row(
      children: [
        DropdownButtonHideUnderline(
          child: DropdownButton<ConversionUnit>(
            value: selected,
            borderRadius: BorderRadius.circular(12),
            icon: const Icon(Icons.keyboard_arrow_down),
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontSize: 23,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            selectedItemBuilder: (context) => units
                .map(
                  (unit) => Align(
                    alignment: Alignment.centerLeft,
                    child: Text(unit.symbol),
                  ),
                )
                .toList(),
            items: units
                .map(
                  (unit) => DropdownMenuItem(
                    value: unit,
                    child: Text(unit.symbol, semanticsLabel: unit.name),
                  ),
                )
                .toList(),
            onChanged: (unit) {
              if (unit != null) onChanged(unit);
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ValueInput(value: value, isResult: isResult),
        ),
      ],
    ),
  );
}
