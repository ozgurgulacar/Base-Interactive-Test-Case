import 'dart:convert';
import 'dart:io';
import 'package:base_interactive_test_case/presentations/status/web_socket_status.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:base_interactive_test_case/providers/market_providers.dart';

class BinanceWSService {
  final String wsUrl = 'wss://stream.binance.com:9443/ws/!miniTicker@arr';
  late WebSocketChannel? _channel;

  int _reconnectAttempts = 0;
  bool _manuallyDisconnected = false;

  void connect(MarketProviders marketProvider) async {
    _manuallyDisconnected = false;

    try {
      final socket = await WebSocket.connect(wsUrl);
      _channel = IOWebSocketChannel(socket);
    } catch (e) {
      marketProvider.setErrorWebSocket(
        'No internet connection. Will attempt to reconnect automatically within 5 seconds',
      );

      _reconnect(marketProvider);
      return;
    }

    _channel?.stream.listen(
      (message) {
        try {
          final List<dynamic> data = jsonDecode(message);
          _reconnectAttempts = 0;

          for (var item in data) {
            final symbol = item['s'];
            final lastPrice = double.tryParse(item['c'] ?? '0') ?? 0;
            final high = double.tryParse(item['h'] ?? '0') ?? 0;
            final low = double.tryParse(item['l'] ?? '0') ?? 0;
            final volume = double.tryParse(item['v'] ?? '0') ?? 0;

            if (symbol == null) {
              continue;
            }

            marketProvider.updateFromStream(
              symbol,
              lastPrice: lastPrice,
              high: high,
              low: low,
              volume: volume,
            );
          }
        } catch (e) {
          marketProvider.setErrorWebSocket(
            'Live data error: Will attempt to reconnect automatically within 5 seconds',
          );
          marketProvider.webSocketStatus = WebSocketStatus.error;
          marketProvider.notifyListeners();
        }
      },
      onDone: () {
        if (_manuallyDisconnected) {
          return;
        }
        _reconnect(marketProvider);
      },
      onError: (error) {
        if (_manuallyDisconnected) {
          return;
        }

        marketProvider.setErrorWebSocket(
          'Live connection error: Will attempt to reconnect automatically within 5 seconds',
        );
        marketProvider.webSocketStatus = WebSocketStatus.error;
        marketProvider.notifyListeners();

        _reconnect(marketProvider);
      },
    );
  }

  void _reconnect(MarketProviders marketProvider) async {
    if (_reconnectAttempts >= 5) {
      disconnect(marketProvider);
      return;
    }

    _reconnectAttempts++;

    try {
      await _channel?.sink.close();
    } catch (_) {}

    await Future.delayed(const Duration(seconds: 5));
    connect(marketProvider);
  }

  void disconnect(MarketProviders marketProvider) async {
    try {
      _manuallyDisconnected = true;
      _reconnectAttempts = 0;
      try {
        await _channel?.sink.close();
      } catch (_) {}

      marketProvider.webSocketStatus = WebSocketStatus.disconnected;
      marketProvider.notifyListeners();
    } catch (e) {
      marketProvider.setErrorWebSocket('Error disconnecting WebSocket: ');
      marketProvider.notifyListeners();
    }
  }
}
