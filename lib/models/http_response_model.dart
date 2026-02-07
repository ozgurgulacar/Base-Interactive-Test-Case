class HttpResponseModel {
  final String symbol;

  final String lastPrice;
  final String openPrice;
  final String highPrice;
  final String lowPrice;
  final String volume;
  final String quoteVolume;
  final String priceChange;
  final String priceChangePercent;
  final String weightedAvgPrice;
  final String bidPrice;
  final String bidQty;
  final String askPrice;
  final String askQty;

  final int openTime;
  final int closeTime;
  final int tradeCount;

  HttpResponseModel({
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

  factory HttpResponseModel.fromJson(Map<String, dynamic> json) {
    return HttpResponseModel(
      symbol: json['symbol']?.toString() ?? "0",
      lastPrice: json['lastPrice']?.toString() ?? "0",
      openPrice: json['openPrice']?.toString() ?? "0",
      highPrice: json['highPrice']?.toString() ?? "0",
      lowPrice: json['lowPrice']?.toString() ?? "0",
      volume: json['volume']?.toString() ?? "0",
      quoteVolume: json['quoteVolume']?.toString() ?? "0",
      priceChange: json['priceChange']?.toString() ?? "0",
      priceChangePercent: json['priceChangePercent']?.toString() ?? "0",
      weightedAvgPrice: json['weightedAvgPrice']?.toString() ?? "0",
      bidPrice: json['bidPrice']?.toString() ?? "0",
      bidQty: json['bidQty']?.toString() ?? "0",
      askPrice: json['askPrice']?.toString() ?? "0",
      askQty: json['askQty']?.toString() ?? "0",
      openTime: int.tryParse(json['openTime']?.toString() ?? "0") ?? 0,
      closeTime: int.tryParse(json['closeTime']?.toString() ?? "0") ?? 0,
      tradeCount: int.tryParse(json['tradeCount']?.toString() ?? "0") ?? 0,
    );
  }
}
