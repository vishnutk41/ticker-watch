import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

class StockServer {
  final int port;
  final List<WebSocket> _clients = [];
  final Random _random = Random();
  Timer? _timer;

  StockServer({this.port = 8080});

  void start() {
    HttpServer.bind('0.0.0.0', port).then((server) {
      print('Stock server running on ws://0.0.0.0:$port/ws');
      print('For Android emulator, use: ws://192.168.150.74:$port/ws');
      
      server.listen((HttpRequest request) {
        if (WebSocketTransformer.isUpgradeRequest(request)) {
          WebSocketTransformer.upgrade(request).then((WebSocket ws) {
            _handleWebSocket(ws);
          });
        } else {
          request.response.statusCode = HttpStatus.badRequest;
          request.response.close();
        }
      });
    }).catchError((error) {
      print('Failed to start server: $error');
    });
  }

  void _handleWebSocket(WebSocket ws) {
    _clients.add(ws);
    print('Client connected. Total clients: ${_clients.length}');

    ws.listen(
      (data) {
        // Handle incoming messages if needed
        print('Received: $data');
      },
      onError: (error) {
        print('WebSocket error: $error');
        _removeClient(ws);
      },
      onDone: () {
        print('Client disconnected');
        _removeClient(ws);
      },
    );

    // Start sending stock data to this client
    _startSendingData();
  }

  void _removeClient(WebSocket ws) {
    _clients.remove(ws);
    print('Client removed. Total clients: ${_clients.length}');
    
    if (_clients.isEmpty) {
      _stopSendingData();
    }
  }

  void _startSendingData() {
    if (_timer != null) return; // Already sending data
    
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _sendStockData();
    });
  }

  void _stopSendingData() {
    _timer?.cancel();
    _timer = null;
  }

  void _sendStockData() {
    if (_clients.isEmpty) return;

    final stocks = [
      {'ticker': 'AAPL', 'price': _generatePrice(150.0)},
      {'ticker': 'GOOGL', 'price': _generatePrice(2800.0)},
      {'ticker': 'MSFT', 'price': _generatePrice(300.0)},
      {'ticker': 'AMZN', 'price': _generatePrice(3300.0)},
      {'ticker': 'TSLA', 'price': _generatePrice(800.0)},
      {'ticker': 'META', 'price': _generatePrice(350.0)},
      {'ticker': 'NVDA', 'price': _generatePrice(500.0)},
      {'ticker': 'NFLX', 'price': _generatePrice(600.0)},
    ];

    final data = jsonEncode(stocks);
    
    // Send to all connected clients
    for (final client in List.from(_clients)) {
      try {
        client.add(data);
      } catch (e) {
        print('Error sending to client: $e');
        _removeClient(client);
      }
    }
  }

  double _generatePrice(double basePrice) {
    // Generate a price with some random variation
    final variation = (_random.nextDouble() - 0.5) * 0.1; // ±5% variation
    return (basePrice * (1 + variation)).roundToDouble();
  }

  void stop() {
    _stopSendingData();
    for (final client in _clients) {
      client.close();
    }
    _clients.clear();
  }
}

void main() {
  final server = StockServer();
  
  // Handle graceful shutdown
  ProcessSignal.sigint.watch().listen((_) {
    print('\nShutting down server...');
    server.stop();
    exit(0);
  });

  server.start();
} 