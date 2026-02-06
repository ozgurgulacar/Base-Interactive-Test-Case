class MarketItem {
  final String symbol;

  double lastPrice;
  double openPrice;
  double highPrice;
  double lowPrice;
  double volume;

  double priceChange;
  double priceChangePercent;

  MarketItem({
    required this.symbol,
    required this.lastPrice,
    required this.openPrice,
    required this.highPrice,
    required this.lowPrice,
    required this.volume,
    required this.priceChange,
    required this.priceChangePercent,
  });

  void updateFromStream({
    required double newLastPrice,
    required double newHigh,
    required double newLow,
    required double newVolume,
  }) {
    lastPrice = newLastPrice;
    highPrice = newHigh;
    lowPrice = newLow;
    volume = newVolume;

    priceChange = lastPrice - openPrice;
    priceChangePercent = (priceChange / openPrice) * 100;
  }
}
