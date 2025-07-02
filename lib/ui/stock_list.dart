import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import '../models/stock.dart';

class StockList extends ConsumerWidget {
  const StockList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stockList = ref.watch(stockListProvider);
    final isLoading = ref.watch(isLoadingProvider);

    if (isLoading && stockList.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Connecting to stock feed...'),
          ],
        ),
      );
    }

    if (stockList.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.signal_wifi_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No stock data available'),
            SizedBox(height: 8),
            Text('Check your connection', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: stockList.length,
      itemBuilder: (context, index) {
        final stock = stockList[index];
        return StockListItem(stock: stock);
      },
    );
  }
}

class StockListItem extends ConsumerWidget {
  final Stock stock;

  const StockListItem({
    super.key,
    required this.stock,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: stock.isAnomalous ? Colors.orange.withOpacity(0.1) : null,
        borderRadius: BorderRadius.circular(8),
        border: stock.isAnomalous 
          ? Border.all(color: Colors.orange, width: 1)
          : null,
      ),
      child: ListTile(
        leading: Container(
          width: 60,
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          decoration: BoxDecoration(
            color: _getTickerColor(stock.ticker),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            stock.ticker,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        title: Row(
          children: [
            Text(
              '\$${stock.price.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: stock.isAnomalous ? Colors.orange.shade800 : Colors.black87,
              ),
            ),
            if (stock.isAnomalous) ...[
              const SizedBox(width: 8),
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.orange.shade600,
                size: 20,
              ),
            ],
          ],
        ),
        subtitle: stock.isAnomalous
          ? Text(
              'Unusual price movement detected',
              style: TextStyle(
                color: Colors.orange.shade600,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            )
          : null,
        trailing: stock.isAnomalous
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'ANOMALY',
                style: TextStyle(
                  color: Colors.orange.shade800,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
      ),
    );
  }

  Color _getTickerColor(String ticker) {
    // Generate consistent colors for tickers
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.indigo,
      Colors.orange,
      Colors.pink,
    ];
    
    final index = ticker.hashCode % colors.length;
    return colors[index];
  }
}
