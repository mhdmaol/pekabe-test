import 'package:flutter/material.dart';

import '../../../state/converter_controller.dart';

class CurrencyRateStatus extends StatelessWidget {
  const CurrencyRateStatus({super.key, required this.controller});
  final ConverterController controller;
  static String _date(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: controller,
    builder: (context, _) {
      final snapshot = controller.currencyRates;
      final dates = snapshot?.dates.values.toList()?..sort();
      final dateLabel = dates == null || dates.isEmpty
          ? ''
          : dates.first == dates.last
          ? _date(dates.first)
          : '${_date(dates.first)} – ${_date(dates.last)}';
      final checked = snapshot?.checkedAt.toLocal();
      return Column(
        children: [
          if (controller.isLoadingRates) ...[
            const SizedBox(
              height: 16,
              width: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(height: 8),
            const Text('Memperbarui kurs…'),
          ],
          if (controller.rateError != null)
            Text(controller.rateError!, textAlign: TextAlign.center),
          if (snapshot != null) ...[
            Text(
              'Frankfurter • Kurs referensi\nTanggal kurs: $dateLabel',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              'Diperiksa: ${_date(checked!)} ${checked.hour.toString().padLeft(2, '0')}:${checked.minute.toString().padLeft(2, '0')}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
          TextButton.icon(
            onPressed: controller.isLoadingRates
                ? null
                : controller.refreshRates,
            icon: const Icon(Icons.refresh, size: 18),
            label: Text(
              controller.rateError != null ? 'Coba lagi' : 'Perbarui kurs',
            ),
          ),
        ],
      );
    },
  );
}
