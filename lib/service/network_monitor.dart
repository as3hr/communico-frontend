import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkMonitor {
  final _connectivity = Connectivity();
  StreamController<bool>? _controller;

  Stream<bool> get onConnectivityChanged => _monitorNetwork();

  Stream<bool> _monitorNetwork() {
    _controller ??= StreamController<bool>.broadcast(
      onListen: () => _startListening(),
      onCancel: () => _stopListening(),
    );

    return _controller!.stream;
  }

  void _startListening() {
    _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      _checkStatus(result);
    });
  }

  void _stopListening() {
    _controller?.close();
    _controller = null;
  }

  void _checkStatus(List<ConnectivityResult> result) {
    final hasConnection = result.first != ConnectivityResult.none;
    _controller?.add(hasConnection);
  }

  Future<bool> checkConnection() async {
    final result = await _connectivity.checkConnectivity();
    return result.first != ConnectivityResult.none;
  }

  void dispose() {
    _stopListening();
  }
}
