#!/bin/bash

echo "Starting Stock WebSocket Server..."
echo "Server will run on ws://localhost:8080/ws"
echo "Press Ctrl+C to stop the server"
echo ""

# Run the Dart server
dart run server/stock_server.dart 