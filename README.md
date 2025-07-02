# TickerWatch - Real-time Stock Tracker

A Flutter application that displays real-time stock prices with anomaly detection using WebSocket connections.

## Features

- Real-time stock price updates via WebSocket
- Anomaly detection for unusual price movements
- Connection status indicator
- Clean Material Design 3 UI

## Setup and Running

### Prerequisites

- Flutter SDK (3.7.2 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extensions

### Running the Application

1. **Start the WebSocket Server** (Required for stock data):
   ```bash
   # Option 1: Use the provided script
   ./run_server.sh
   
   # Option 2: Run directly with Dart
   dart run server/stock_server.dart
   ```

2. **Run the Flutter App** (in a separate terminal):
   ```bash
   flutter run
   ```

### Server Details

- The WebSocket server runs on `ws://localhost:8080/ws`
- Provides mock stock data for popular stocks (AAPL, GOOGL, MSFT, etc.)
- Updates stock prices every 2 seconds with random variations
- Handles multiple client connections

### Troubleshooting

If you see "Connection refused" errors:
1. Make sure the WebSocket server is running first
2. Check that port 8080 is not being used by another application
3. Verify the server output shows "Stock server running on ws://localhost:8080/ws"

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/
│   └── stock.dart           # Stock data model
├── services/
│   └── websocket_service.dart # WebSocket connection handling
├── state/
│   └── stock_provider.dart  # State management with Riverpod
├── ui/
│   ├── connection_status_banner.dart # Connection status display
│   └── stock_list.dart      # Stock list UI
└── utils/
    └── anomaly_detector.dart # Anomaly detection logic

server/
└── stock_server.dart        # WebSocket server for mock data
```

## Dependencies

- `flutter_riverpod`: State management
- `web_socket_channel`: WebSocket communication

## Development

The app uses Riverpod for state management and provides real-time updates through WebSocket connections. The anomaly detector identifies unusual price movements and highlights them in the UI.
