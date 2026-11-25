import 'dart:async';

import 'package:flutter/material.dart';

import '../../data/currency_rate_source.dart';
import '../../components/molecules/currency_rate_status/currency_rate_status.dart';

import '../../components/organisms/converter_panel/converter_panel.dart';
import '../../components/templates/converter_layout/converter_layout.dart';
import '../../domain/conversion_category.dart';
import '../../state/converter_controller.dart';

class ConverterPage extends StatefulWidget {
  const ConverterPage({super.key, required this.category, this.rateSource});
  final CurrencyRateSource? rateSource;
  final ConversionCategory category;
  @override
  State<ConverterPage> createState() => _ConverterPageState();
}

class _ConverterPageState extends State<ConverterPage>
    with WidgetsBindingObserver {
  late final ConverterController controller = ConverterController(
    widget.category,
    rateSource: widget.rateSource,
  );
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    unawaited(controller.refreshRates());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(controller.refreshRates());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Theme(
    data: Theme.of(context).copyWith(
      colorScheme: Theme.of(context).colorScheme.copyWith(
        primary: widget.category.color,
        onPrimary: Colors.white,
        secondary: widget.category.color,
        secondaryContainer: widget.category.tint,
        onSecondaryContainer: widget.category.color,
      ),
    ),
    child: ConverterLayout(
      title: widget.category.title,
      child: Column(
        children: [
          if (widget.category.kind == ConversionKind.time)
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(value: false, label: Text('Waktu')),
                  ButtonSegment(value: true, label: Text('Kecepatan')),
                ],
                selected: {controller.category.kind == ConversionKind.speed},
                onSelectionChanged: (selection) => setState(
                  () => controller.setCategory(
                    selection.first
                        ? ConversionCatalog.speed
                        : ConversionCatalog.time,
                  ),
                ),
              ),
            ),
          ConverterPanel(controller: controller),
          if (widget.category.kind == ConversionKind.currency)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: CurrencyRateStatus(controller: controller),
            ),
        ],
      ),
    ),
  );
}
