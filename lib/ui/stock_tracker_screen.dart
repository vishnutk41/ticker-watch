import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import 'stock_list.dart';
import 'connection_status_banner.dart';

class StockTrackerScreen extends ConsumerWidget {
  const StockTrackerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stockState = ref.watch(stockViewModelProvider);
    final viewModel = ref.read(stockViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('TickerWatch'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: Icon(
              stockState.isConnected ? Icons.refresh : Icons.wifi_off,
            ),
            onPressed: stockState.isConnected 
              ? null 
              : () => viewModel.reconnect(),
            tooltip: stockState.isConnected 
              ? 'Connected' 
              : 'Reconnect',
          ),
        ],
      ),
      body: Column(
        children: [
          const ConnectionStatusBanner(),
          if (stockState.lastUpdate != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              color: Colors.grey.shade100,
              child: Text(
                'Last update: ${_formatDateTime(stockState.lastUpdate!)}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          Expanded(child: StockList()),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
  }
} 