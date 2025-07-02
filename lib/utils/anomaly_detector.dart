class AnomalyDetector {
  final Map<String, double> _lastPrices = {};

  bool isAnomalous(String ticker, double prevPrice, double newPrice) {
    _lastPrices[ticker] = newPrice;

    if (prevPrice == 0) return false;
    final dropPercent = (prevPrice - newPrice) / prevPrice;
    return dropPercent > 0.90;
  }
}
