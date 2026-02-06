import 'package:base_interactive_test_case/extensions/http_response_to_market_item.dart';
import 'package:base_interactive_test_case/models/market_item.dart';
import 'package:base_interactive_test_case/services/binance_http_service.dart';

class MarketRepository {
  final BinanceHttpService _httpService;

  MarketRepository(this._httpService);

  Future<List<MarketItem>> fetchInitialMarketData() async {
    final response = await _httpService.fetch24hTickers();

    return response
        .map((e) => e.toMarketItem())
        .toList();
  }
}
