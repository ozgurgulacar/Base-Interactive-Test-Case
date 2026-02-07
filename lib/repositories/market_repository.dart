import 'package:base_interactive_test_case/extensions/http_response_to_market_item.dart';
import 'package:base_interactive_test_case/models/market_item.dart';
import 'package:base_interactive_test_case/providers/market_providers.dart';
import 'package:base_interactive_test_case/services/binance_http_service.dart';
import 'package:base_interactive_test_case/services/binance_ws_service.dart';

class MarketRepository {
  final BinanceHttpService _httpService;
  final BinanceWSService _wsService = BinanceWSService();

  MarketRepository(this._httpService);

  Future<List<MarketItem>> fetchInitialMarketData() async {
    final response = await _httpService.fetch24hTickers();

    return response
        .map((e) => e.toMarketItem())
        .toList();
  }

  void connectWebSocket(MarketProviders marketProvider) {
    _wsService.connect(marketProvider);
  }

  void disconnectWebSocket(MarketProviders marketProvider) {
    _wsService.disconnect(marketProvider);
  }
}
