class Stock {
  final String ticker;
  final double price;
  final bool isAnomalous;

  Stock({
    required this.ticker,
    required this.price,
    this.isAnomalous = false,
  });

  Stock copyWith({
    double? price,
    bool? isAnomalous,
  }) {
    return Stock(
      ticker: ticker,
      price: price ?? this.price,
      isAnomalous: isAnomalous ?? this.isAnomalous,
    );
  }
}
