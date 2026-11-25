import 'package:flutter/material.dart';

import '../../../domain/conversion_category.dart';
import '../../molecules/category_card/category_card.dart';

class CategoryGrid extends StatelessWidget {
  const CategoryGrid({super.key, required this.onSelected});
  final ValueChanged<ConversionCategory> onSelected;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final columns = constraints.maxWidth >= 720
          ? 3
          : constraints.maxWidth >= 480
          ? 2
          : 1;
      final compact = columns > 1;
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: ConversionCatalog.categories.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          mainAxisSpacing: 14,
          crossAxisSpacing: 12,
          mainAxisExtent: compact ? 126 : 122,
        ),
        itemBuilder: (context, index) {
          final category = ConversionCatalog.categories[index];
          return CategoryCard(
            category: category,
            compact: compact,
            onTap: () => onSelected(category),
          );
        },
      );
    },
  );
}
