import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../atoms/keypad_key/keypad_key.dart';

class NumericKeypad extends StatelessWidget {
  const NumericKeypad({super.key, required this.onKey});
  final ValueChanged<String> onKey;
  static const keys = ['7', '8', '9'];
  @override
  Widget build(BuildContext context) => CallbackShortcuts(
    bindings: {
      for (final digit in [
        '0',
        '1',
        '2',
        '3',
        '4',
        '5',
        '6',
        '7',
        '8',
        '9',
        '.',
      ])
        SingleActivator(
          LogicalKeyboardKey.findKeyByKeyId(digit.codeUnitAt(0))!,
        ): () =>
            onKey(digit),
      const SingleActivator(LogicalKeyboardKey.backspace): () =>
          onKey('backspace'),
      const SingleActivator(LogicalKeyboardKey.delete): () => onKey('clear'),
    },
    child: Focus(
      autofocus: true,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final gap = width < 300 ? 20.0 : 38.0;
          final height = ((width - gap * 2) / 3).clamp(58.0, 76.0);
          return GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            mainAxisSpacing: 14,
            crossAxisSpacing: gap,
            childAspectRatio: ((width - gap * 2) / 3) / height,
            children:
                [
                      '1',
                      '2',
                      '3',
                      '4',
                      '5',
                      '6',
                      '7',
                      '8',
                      '9',
                      '.',
                      '0',
                      'backspace',
                    ]
                    .map(
                      (key) => KeypadKey(
                        label: key == 'backspace' ? 'Hapus digit' : key,
                        icon: key == 'backspace'
                            ? Icons.backspace_outlined
                            : null,
                        onPressed: () => onKey(key),
                      ),
                    )
                    .toList(),
          );
        },
      ),
    ),
  );
}
