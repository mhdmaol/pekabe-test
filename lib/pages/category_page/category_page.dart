import 'package:flutter/material.dart';

import '../../components/organisms/category_grid/category_grid.dart';
import '../../core/theme/app_theme.dart';
import '../converter_page/converter_page.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key, required this.onToggleTheme});
  final VoidCallback onToggleTheme;
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.page),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.swap_horiz,
                        size: 23,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LillUziVert',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          'Mobile Converter',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    IconButton.outlined(
                      onPressed: onToggleTheme,
                      tooltip: 'Ganti tema',
                      style: IconButton.styleFrom(
                        minimumSize: const Size(34, 34),
                        padding: const EdgeInsets.all(6),
                        side: const BorderSide(color: Color(0xFFDCE5F1)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                      ),
                      icon: const Icon(Icons.brightness_6_outlined, size: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                const Text(
                  'Pilih Kategori Satuan',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 3),
                Text(
                  'Ketuk tombol kotak untuk beralih mode konversi',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? const Color(0xFFACBCD4)
                        : AppColors.muted,
                  ),
                ),
                const SizedBox(height: 16),
                CategoryGrid(
                  onSelected: (category) => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => ConverterPage(category: category),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
