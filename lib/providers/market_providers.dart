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

  List<String>? _filteredSymbols;

  List<String> get symbols => _filteredSymbols ?? _marketMap.keys.toList();

  MarketItem? getItem(String symbol) => _marketMap[symbol];

  Future<void> loadInitialData() async {
    status = MarketStatus.loading;
    errorMessage = null;
    notifyListeners();

    try {
      final items = await repository.fetchInitialMarketData();

      for (final item in items) {
        _marketMap[item.symbol] = item;
      }

      status = MarketStatus.success;
    } catch (e) {
      status = MarketStatus.error;
      errorMessage = e.toString();
    }

    notifyListeners();
  }

  Future<void> refreshData() async {
    await loadInitialData();
    if (status == MarketStatus.success) {
      await connectWebSocket();
    }
  }

  Future<void> connectWebSocket() async {

    webSocketStatus = WebSocketStatus.loading;
    errorMessageWebSocket = null;
    notifyListeners();

    try {
      repository.connectWebSocket(this);
      webSocketStatus = WebSocketStatus.connected;
    } catch (e) {
      webSocketStatus = WebSocketStatus.error;
      errorMessageWebSocket = e.toString();
    }

    notifyListeners();
  }

  Future<void> disconnectWebSocket() async {

    webSocketStatus = WebSocketStatus.loading;
    errorMessageWebSocket = null;
    notifyListeners();

    try {
      repository.disconnectWebSocket(this);
      webSocketStatus = WebSocketStatus.disconnected;
    } catch (e) {
      webSocketStatus = WebSocketStatus.error;
      errorMessageWebSocket = e.toString();
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

  void search(String query) {
    if (query.isEmpty) {
      _filteredSymbols = null;
    } else {
      _filteredSymbols = _marketMap.keys
          .where((symbol) => symbol.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  void clearSearch() {
    _filteredSymbols = null;
    notifyListeners();
  }

  void setErrorWebSocket(String message) {
    webSocketStatus = WebSocketStatus.error;
    errorMessageWebSocket = message;
    notifyListeners();
  }

  void setDisconnectingWebSocket() {
    webSocketStatus = WebSocketStatus.disconnected;
    notifyListeners();
  }

  void setConnectedWebSocket() {
    webSocketStatus = WebSocketStatus.connected;
    notifyListeners();
  }
}
