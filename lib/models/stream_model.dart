class StreamModel {
  final String symbol;
  final String lastPrice;
  final String highPrice;
  final String lowPrice;
  final String volume;

  StreamModel({
    required this.symbol,
    required this.lastPrice,
    required this.highPrice,
    required this.lowPrice,
    required this.volume,
  });

  factory StreamModel.fromJson(Map<String, dynamic> json) {
    return StreamModel(
      symbol: json['s'],
      lastPrice: json['c'],
      highPrice: json['h'],
      lowPrice: json['l'],
      volume: json['v'],
    );
  }
}
