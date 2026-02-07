class MarketItem {
  final String symbol;

  double lastPrice;
  double openPrice;
  double highPrice;
  double lowPrice;

  double volume;
  double quoteVolume;

  double priceChange;
  double priceChangePercent;
  double weightedAvgPrice;

  double bidPrice;
  double bidQty;
  double askPrice;
  double askQty;

  int openTime;
  int closeTime;
  int tradeCount;

  MarketItem({
    required this.symbol,
    required this.lastPrice,
    required this.openPrice,
    required this.highPrice,
    required this.lowPrice,
    required this.volume,
    required this.quoteVolume,
    required this.priceChange,
    required this.priceChangePercent,
    required this.weightedAvgPrice,
    required this.bidPrice,
    required this.bidQty,
    required this.askPrice,
    required this.askQty,
    required this.openTime,
    required this.closeTime,
    required this.tradeCount,
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
