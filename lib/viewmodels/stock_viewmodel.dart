import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/stock.dart';
import '../services/websocket_service.dart';
import '../utils/anomaly_detector.dart';

// ViewModel for stock management
class StockViewModel extends StateNotifier<StockState> {
  final WebSocketService _webSocketService;
  final AnomalyDetector _anomalyDetector = AnomalyDetector();

  StockViewModel(this._webSocketService) : super(StockState.initial()) {
    _initializeWebSocket();
  }

  void _initializeWebSocket() {
    _webSocketService.onMessage = _handleStockData;
    _webSocketService.onStatus = _handleConnectionStatus;
    _webSocketService.connect();
  }

  void _handleConnectionStatus(String status) {
    state = state.copyWith(
      connectionStatus: status,
      isLoading: status == "Connecting",
    );
  }

  void _handleStockData(String data) {
    try {
      final parsed = jsonDecode(data);
      if (parsed is! List) return;

      final Map<String, Stock> newStocks = {};
      
      for (var entry in parsed) {
        if (entry['ticker'] == null || entry['price'] == null) continue;
        
        final ticker = entry['ticker'];
        final price = double.tryParse(entry['price'].toString());
        if (price == null) continue;

        final previousStock = state.stocks[ticker];
        final previousPrice = previousStock?.price ?? price;
        final isAnomaly = _anomalyDetector.isAnomalous(ticker, previousPrice, price);

        newStocks[ticker] = Stock(
          ticker: ticker,
          price: price,
          isAnomalous: isAnomaly,
        );
      }

      state = state.copyWith(
        stocks: newStocks,
        lastUpdate: DateTime.now(),
      );
    } catch (error) {
      // Handle JSON parsing errors silently
      print('Error parsing stock data: $error');
    }
  }

  void reconnect() {
    _webSocketService.connect();
  }

  void disconnect() {
    _webSocketService.disconnect();
  }

  @override
  void dispose() {
    _webSocketService.disconnect();
    super.dispose();
  }
}

// State class for the ViewModel
class StockState {
  final Map<String, Stock> stocks;
  final String connectionStatus;
  final bool isLoading;
  final DateTime? lastUpdate;
  final String? error;

  const StockState({
    required this.stocks,
    required this.connectionStatus,
    required this.isLoading,
    this.lastUpdate,
    this.error,
  });

  factory StockState.initial() {
    return const StockState(
      stocks: {},
      connectionStatus: "Connecting",
      isLoading: true,
    );
  }

  StockState copyWith({
    Map<String, Stock>? stocks,
    String? connectionStatus,
    bool? isLoading,
    DateTime? lastUpdate,
    String? error,
  }) {
    return StockState(
      stocks: stocks ?? this.stocks,
      connectionStatus: connectionStatus ?? this.connectionStatus,
      isLoading: isLoading ?? this.isLoading,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      error: error ?? this.error,
    );
  }

  bool get isConnected => connectionStatus.contains("Connected");
  bool get isConnecting => connectionStatus.contains("Connecting");
  bool get isReconnecting => connectionStatus.contains("Reconnecting");
  
  List<Stock> get stockList => stocks.values.toList();
  int get stockCount => stocks.length;
} 