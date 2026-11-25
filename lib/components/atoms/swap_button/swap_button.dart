import 'package:flutter/material.dart';

class SwapButton extends StatelessWidget {
  const SwapButton({super.key, required this.onPressed});
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) => IconButton.filled(
    onPressed: onPressed,
    tooltip: 'Tukar satuan',
    style: IconButton.styleFrom(
      backgroundColor: Theme.of(context).colorScheme.primary,
      minimumSize: const Size(48, 48),
    ),
    icon: const Icon(Icons.swap_vert, size: 32, color: Colors.white),
  );
}
