
import 'package:flutter/material.dart';
import 'package:tickerwatch/models/stock.dart';



class StockRow extends StatefulWidget {
  final Stock stock;
  const StockRow({required this.stock});

  @override
  State<StockRow> createState() => StockRowState();
}

class StockRowState extends State<StockRow> {
  Color? flashColor;

  @override
  void didUpdateWidget(covariant StockRow oldWidget) {
    if (widget.stock.price > oldWidget.stock.price) {
      flashColor = Colors.green;
    } else if (widget.stock.price < oldWidget.stock.price) {
      flashColor = Colors.red;
    }

    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) setState(() => flashColor = null);
    });

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final stock = widget.stock;

    return ListTile(
      leading: Text(stock.ticker, style: const TextStyle(fontSize: 18)),
      title: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            color: flashColor,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              '\$${stock.price.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 18,
                color: stock.isAnomalous ? Colors.orange : Colors.black,
                fontWeight: stock.isAnomalous ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          if (stock.isAnomalous)
            const Padding(
              padding: EdgeInsets.only(left: 8),
              child: Icon(Icons.warning_amber, color: Colors.orange),
            )
        ],
      ),
    );
  }
}
