import 'package:flutter/material.dart';
import '../models/stock.dart';

class PriceChangeIndicator extends StatelessWidget {
  final Stock stock;
  final Stock? previousStock;

  const PriceChangeIndicator({
    super.key,
    required this.stock,
    this.previousStock,
  });

  @override
  Widget build(BuildContext context) {
    if (previousStock == null) {
      return Text(
        '\$${stock.price.toStringAsFixed(2)}',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      );
    }

    final priceChange = stock.price - previousStock!.price;
    final priceChangePercent = (priceChange / previousStock!.price) * 100;
    final isPositive = priceChange >= 0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '\$${stock.price.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: stock.isAnomalous ? Colors.orange.shade800 : Colors.black87,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: isPositive ? Colors.green.shade100 : Colors.red.shade100,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isPositive ? Icons.trending_up : Icons.trending_down,
                size: 12,
                color: isPositive ? Colors.green.shade700 : Colors.red.shade700,
              ),
              const SizedBox(width: 2),
              Text(
                '${isPositive ? '+' : ''}${priceChangePercent.toStringAsFixed(2)}%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isPositive ? Colors.green.shade700 : Colors.red.shade700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
} 