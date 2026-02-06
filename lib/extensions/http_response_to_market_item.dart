import 'package:base_interactive_test_case/models/http_response_model.dart';
import 'package:base_interactive_test_case/models/market_item.dart';

extension HttpResponseToMarketItem on HttpResponseModel {
  MarketItem toMarketItem() {
    return MarketItem(
      symbol: symbol,
      lastPrice: double.parse(lastPrice),
      openPrice: double.parse(openPrice),
      highPrice: double.parse(highPrice),
      lowPrice: double.parse(lowPrice),
      volume: double.parse(volume),
      priceChange: double.parse(priceChange),
      priceChangePercent: double.parse(priceChangePercent),
    );
  }
}