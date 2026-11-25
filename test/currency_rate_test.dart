import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:pekabe_converter/data/currency_rate_source.dart';
import 'package:pekabe_converter/domain/conversion_category.dart';
import 'package:pekabe_converter/domain/currency_rates.dart';
import 'package:pekabe_converter/pages/converter_page/converter_page.dart';
import 'package:pekabe_converter/state/converter_controller.dart';

import 'support/rate_fixture.dart';

class PendingSource implements CurrencyRateSource {
  Completer<CurrencyRates> pending = Completer();
  int calls = 0;
  @override
  Future<CurrencyRates> fetchLatest() {
    calls++;
    return pending.future;
  }
}

List<Map<String, Object>> rows() => [
  {'base': 'USD', 'quote': 'IDR', 'date': '2026-11-25', 'rate': 18235},
  {'base': 'USD', 'quote': 'EUR', 'date': '2026-11-24', 'rate': 0.91323},
  {'base': 'USD', 'quote': 'JPY', 'date': '2026-11-25', 'rate': 159.24},
];
void main() {
  test('API query, decoding, dates, cross currency and reverse', () async {
    final source = FrankfurterRateSource(
      clientFactory: () => MockClient((request) async {
        expect(request.url.scheme, 'https');
        expect(request.url.queryParameters['base'], 'USD');
        expect(request.url.queryParameters['quotes'], 'IDR,EUR,JPY');
        return http.Response(jsonEncode(rows()), 200);
      }),
    );
    final snapshot = await source.fetchLatest();
    expect(snapshot.convert(1, 'USD', 'IDR'), 18235);
    expect(snapshot.convert(18235, 'IDR', 'USD'), 1);
    expect(
      snapshot.convert(2, 'EUR', 'JPY'),
      closeTo(2 / 0.91323 * 159.24, 1e-8),
    );
    expect(snapshot.dates['EUR'], DateTime(2026, 11, 24));
  });
  test('Reject HTTP errors, malformed, incomplete, nonpositive and invalid dated data', () async {
    final cases = <(int, String)>[
      (503, 'unavailable'),
      (200, 'invalid'),
      (200, '{}'),
      (200, '[]'),
    ];
    for (final change in [
      (Map<String, Object> row) => row['rate'] = 0,
      (Map<String, Object> row) => row['rate'] = -1,
      (Map<String, Object> row) => row['date'] = '2026-02-31',
      (Map<String, Object> row) => row['base'] = 'EUR',
    ]) {
      final data = rows();
      change(data.first);
      cases.add((200, jsonEncode(data)));
    }
    final duplicates = rows()..add(rows().first);
    cases.add((200, jsonEncode(duplicates)));
    for (final item in cases) {
      final source = FrankfurterRateSource(
        clientFactory: () =>
            MockClient((_) async => http.Response(item.$2, item.$1)),
      );
      await expectLater(source.fetchLatest(), throwsA(anything));
    }
  });
  test('Network timeout is bounded', () async {
    final source = FrankfurterRateSource(
      timeout: const Duration(milliseconds: 5),
      clientFactory: () => MockClient((_) => Completer<http.Response>().future),
    );
    await expectLater(source.fetchLatest(), throwsA(isA<TimeoutException>()));
  });
  test('Loading guard, failure, retry, last good rates, disposal', () async {
    final source = PendingSource();
    final controller = ConverterController(
      ConversionCatalog.currency,
      rateSource: source,
    );
    expect(controller.result.isNaN, isTrue);
    final first = controller.refreshRates();
    expect(controller.isLoadingRates, isTrue);
    await controller.refreshRates();
    expect(source.calls, 1);
    source.pending.completeError(Exception('offline'));
    await first;
    expect(controller.result.isNaN, isTrue);
    expect(controller.rateError, isNotNull);
    source.pending = Completer();
    final retry = controller.refreshRates();
    source.pending.complete(await FixtureRateSource().fetchLatest());
    await retry;
    expect(controller.result, 18235);
    expect(controller.rateError, isNull);
    controller.selectFrom(ConversionCatalog.currency.units[2]);
    controller.selectTo(ConversionCatalog.currency.units[3]);
    expect(controller.result, closeTo(159.24 / 0.91323, 1e-8));
    source.pending = Completer();
    final failure = controller.refreshRates();
    source.pending.completeError(Exception('offline'));
    await failure;
    expect(controller.result.isFinite, isTrue);
    expect(controller.rateError, contains('kurs terakhir'));
    source.pending = Completer();
    final late = controller.refreshRates();
    controller.dispose();
    source.pending.complete(await FixtureRateSource().fetchLatest());
    await late;
  });
  testWidgets(
    'Loading and retry UI, refreshed value, resume fetch and safe exit',
    (tester) async {
      tester.view.physicalSize = const Size(390, 1100);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final source = PendingSource();
      await tester.pumpWidget(
        MaterialApp(
          home: ConverterPage(
            category: ConversionCatalog.currency,
            rateSource: source,
          ),
        ),
      );
      expect(find.text('Memperbarui kurs…'), findsOneWidget);
      expect(find.text('—'), findsOneWidget);
      source.pending.completeError(Exception('offline'));
      await tester.pumpAndSettle();
      expect(find.text('Coba lagi'), findsOneWidget);
      source.pending = Completer();
      await tester.tap(find.text('Coba lagi'));
      await tester.pump();
      source.pending.complete(await FixtureRateSource().fetchLatest());
      await tester.pumpAndSettle();
      expect(find.text('18.235'), findsOneWidget);
      expect(find.textContaining('25/11/2026'), findsNWidgets(2));
      source.pending = Completer();
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pump();
      expect(source.calls, 3);
      await tester.pumpWidget(const SizedBox());
      source.pending.complete(await FixtureRateSource().fetchLatest());
      await tester.pump();
      expect(tester.takeException(), isNull);
    },
  );
}
