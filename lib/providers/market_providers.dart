import 'package:base_interactive_test_case/models/market_item.dart';
import 'package:base_interactive_test_case/presentations/status/market_status.dart';
import 'package:base_interactive_test_case/repositories/market_repository.dart';
import 'package:flutter/material.dart';

class MarketProviders extends ChangeNotifier {
  final MarketRepository repository;

  MarketProviders(this.repository);

  MarketStatus status = MarketStatus.idle;
  String? errorMessage;
  
  final Map<String, MarketItem> _marketMap = {};

  List<String> get symbols => _marketMap.keys.toList();

  MarketItem? getItem(String symbol) => _marketMap[symbol];

  Future<void> loadInitialData() async {
    status = MarketStatus.loading;
    errorMessage = null;
    notifyListeners();

    try {
      print('Fetching initial market data...');
      final items = await repository.fetchInitialMarketData();

      for (final item in items) {
        _marketMap[item.symbol] = item;
      }

      status = MarketStatus.success;
    } catch (e) {
      status = MarketStatus.error;
      errorMessage = e.toString();
      print('Error loading initial data: $errorMessage');
    }

    notifyListeners();
    print('Initial data loaded: ${_marketMap.length} items');
  }

  void updateFromStream(
    String symbol, {
    required double lastPrice,
    required double high,
    required double low,
    required double volume,
  }) {
    final item = _marketMap[symbol];
    if (item == null) return;

    final hasChanged =
        item.lastPrice != lastPrice ||
        item.highPrice != high ||
        item.lowPrice != low ||
        item.volume != volume;

    if (!hasChanged) return;

    item.updateFromStream(
      newLastPrice: lastPrice,
      newHigh: high,
      newLow: low,
      newVolume: volume,
    );

    notifyListeners();
  }
}
