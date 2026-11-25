import 'package:flutter/material.dart';

class UnitBadge extends StatelessWidget {
  const UnitBadge({
    super.key,
    required this.symbol,
    required this.color,
    required this.background,
  });
  final String symbol;
  final Color color, background;
  @override
  Widget build(BuildContext context) => Container(
    width: 42,
    height: 42,
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(13),
    ),
    alignment: Alignment.center,
    child: Text(
      symbol,
      style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.w800),
    ),
  );
}
