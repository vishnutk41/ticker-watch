import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/stock.dart';
import '../services/websocket_service.dart';
import '../viewmodels/stock_viewmodel.dart';

// WebSocket Service Provider
final webSocketServiceProvider = Provider<WebSocketService>((ref) {
  return WebSocketService(ref);
});

// Stock ViewModel Provider
final stockViewModelProvider = StateNotifierProvider<StockViewModel, StockState>((ref) {
  final webSocketService = ref.read(webSocketServiceProvider);
  return StockViewModel(webSocketService);
});

// Derived providers for specific state parts
final connectionStatusProvider = Provider<String>((ref) {
  return ref.watch(stockViewModelProvider).connectionStatus;
});

final stocksProvider = Provider<Map<String, Stock>>((ref) {
  return ref.watch(stockViewModelProvider).stocks;
});

final stockListProvider = Provider<List<Stock>>((ref) {
  return ref.watch(stockViewModelProvider).stockList;
});

final isLoadingProvider = Provider<bool>((ref) {
  return ref.watch(stockViewModelProvider).isLoading;
});

final isConnectedProvider = Provider<bool>((ref) {
  return ref.watch(stockViewModelProvider).isConnected;
}); 