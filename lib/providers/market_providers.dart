import 'package:base_interactive_test_case/models/market_item.dart';
import 'package:base_interactive_test_case/presentations/status/market_status.dart';
import 'package:base_interactive_test_case/presentations/status/web_socket_status.dart';
import 'package:base_interactive_test_case/repositories/market_repository.dart';
import 'package:flutter/material.dart';

class MarketProviders extends ChangeNotifier {
  final MarketRepository repository;

  MarketProviders(this.repository);

  MarketStatus status = MarketStatus.idle;
  WebSocketStatus webSocketStatus = WebSocketStatus.idle;
  String? errorMessage;
  String? errorMessageWebSocket;

  final Map<String, MarketItem> _marketMap = {};

  List<String> get symbols => _marketMap.keys.toList();

  MarketItem? getItem(String symbol) => _marketMap[symbol];

  void setErrorWebSocket(String message) {
    webSocketStatus = WebSocketStatus.error;
    errorMessageWebSocket = message;
    notifyListeners();
  }

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

  Future<void> refreshData() async {
    await loadInitialData();
    if (status == MarketStatus.success) {
      await connectWebSocket();
    }
  }

  Future<void> connectWebSocket() async {
    print('Connecting to WebSocket...');

    webSocketStatus = WebSocketStatus.loading;
    errorMessageWebSocket = null;
    notifyListeners();

    try {
      repository.connectWebSocket(this);
      webSocketStatus = WebSocketStatus.connected;
    } catch (e) {
      webSocketStatus = WebSocketStatus.error;
      errorMessageWebSocket = e.toString();
      print('Error connecting to WebSocket: $errorMessageWebSocket');
    }

    notifyListeners();
  }

  Future<void> disconnectWebSocket() async {
    print('Disconnecting from WebSocket...');

    webSocketStatus = WebSocketStatus.loading;
    errorMessageWebSocket = null;
    notifyListeners();

    try {
      repository.disconnectWebSocket(this);
      webSocketStatus = WebSocketStatus.disconnected;
    } catch (e) {
      webSocketStatus = WebSocketStatus.error;
      errorMessageWebSocket = e.toString();
      print('Error disconnecting from WebSocket: $errorMessageWebSocket');
    }

    notifyListeners();
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
