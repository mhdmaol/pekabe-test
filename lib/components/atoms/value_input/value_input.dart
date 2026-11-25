import 'package:flutter/material.dart';

class ValueInput extends StatelessWidget {
  const ValueInput({super.key, required this.value, this.isResult = false});
  final String value;
  final bool isResult;
  @override
  Widget build(BuildContext context) => Semantics(
    label: isResult ? 'Hasil konversi' : 'Nilai masukan',
    value: value,
    child: Align(
      alignment: Alignment.centerRight,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          value,
          maxLines: 1,
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w700,
            color: isResult
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    ),
  );
}
