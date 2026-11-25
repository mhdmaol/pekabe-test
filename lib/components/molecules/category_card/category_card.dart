import 'package:flutter/material.dart';

import '../../../domain/conversion_category.dart';
import '../../atoms/unit_badge/unit_badge.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.category,
    required this.onTap,
    this.compact = false,
  });
  final ConversionCategory category;
  final VoidCallback onTap;
  final bool compact;
  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: dark ? const Color(0xFF42516A) : const Color(0xFF454545),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  UnitBadge(
                    symbol: category.symbol,
                    color: category.color,
                    background: category.tint,
                  ),
                  if (compact) ...[
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: category.kind == ConversionKind.currency
                            ? const Color(0xFFDBEAFE)
                            : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        category.tag,
                        style: TextStyle(
                          fontSize: 9,
                          color: category.kind == ConversionKind.currency
                              ? category.color
                              : const Color(0xFF687D9C),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 9),
              Text(
                category.title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: category.kind == ConversionKind.currency
                      ? category.color
                      : null,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                category.subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: dark
                      ? const Color(0xFFACBCD4)
                      : const Color(0xFF687D9C),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
