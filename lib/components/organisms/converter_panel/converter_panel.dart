import 'package:flutter/material.dart';

import '../../../domain/conversion_engine.dart';
import '../../../state/converter_controller.dart';
import '../../atoms/swap_button/swap_button.dart';
import '../../molecules/conversion_field/conversion_field.dart';
import '../numeric_keypad/numeric_keypad.dart';

class ConverterPanel extends StatelessWidget {
  const ConverterPanel({super.key, required this.controller});
  final ConverterController controller;
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: controller,
    builder: (context, _) => Column(
      children: [
        ConversionField(
          units: controller.category.units,
          selected: controller.from,
          value: controller.displayInput,
          onChanged: controller.selectFrom,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: SwapButton(onPressed: controller.swap),
        ),
        ConversionField(
          units: controller.category.units,
          selected: controller.to,
          value: ConversionEngine.format(controller.result),
          onChanged: controller.selectTo,
          isResult: true,
        ),
        const SizedBox(height: 42),
        NumericKeypad(onKey: controller.enter),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => controller.enter('clear'),
                child: const Text('Reset'),
              ),
              TextButton(
                onPressed: () => controller.enter('sign'),
                child: const Text('+ / −', semanticsLabel: 'Ubah tanda nilai'),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
