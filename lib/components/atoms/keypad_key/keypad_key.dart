import 'package:flutter/material.dart';

class KeypadKey extends StatelessWidget {
  const KeypadKey({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  @override
  Widget build(BuildContext context) => Semantics(
    label: label,
    button: true,
    child: Material(
      color: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF202C40)
          : const Color(0xFFF8F9FA),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(9),
        side: BorderSide(color: Theme.of(context).dividerColor),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(9),
        onTap: onPressed,
        child: Center(
          child: icon == null
              ? Text(
                  label,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                )
              : Icon(icon, size: 26),
        ),
      ),
    ),
  );
}
