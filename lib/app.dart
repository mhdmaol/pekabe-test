import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'pages/category_page/category_page.dart';

class PekabeApp extends StatefulWidget {
  const PekabeApp({super.key});
  @override
  State<PekabeApp> createState() => _PekabeAppState();
}

class _PekabeAppState extends State<PekabeApp> {
  bool _dark = false;
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'LillUziVert • Mobile Converter',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    darkTheme: AppTheme.dark,
    themeMode: _dark ? ThemeMode.dark : ThemeMode.light,
    home: CategoryPage(onToggleTheme: () => setState(() => _dark = !_dark)),
  );
}
