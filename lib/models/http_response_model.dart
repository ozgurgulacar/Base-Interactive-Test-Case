class HttpResponseModel {
  final String symbol;
  final String lastPrice;
  final String openPrice;
  final String highPrice;
  final String lowPrice;
  final String volume;
  final String priceChange;
  final String priceChangePercent;

  HttpResponseModel({
    required this.symbol,
    required this.lastPrice,
    required this.openPrice,
    required this.highPrice,
    required this.lowPrice,
    required this.volume,
    required this.priceChange,
    required this.priceChangePercent,
  });

  factory HttpResponseModel.fromJson(Map<String, dynamic> json) {
    return HttpResponseModel(
      symbol: json['symbol'],
      lastPrice: json['lastPrice'],
      openPrice: json['openPrice'],
      highPrice: json['highPrice'],
      lowPrice: json['lowPrice'],
      volume: json['volume'],
      priceChange: json['priceChange'],
      priceChangePercent: json['priceChangePercent'],
    );
  }
}