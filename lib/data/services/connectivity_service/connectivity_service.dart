import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

enum ConnectionStatus { online, offline, unknown }

class ConnectivityService extends ChangeNotifier {
  ConnectivityService() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(
      _updateConnectionStatus,
    );
    unawaited(refreshConnectionStatus());
  }

  ConnectionStatus _connectionStatus = ConnectionStatus.unknown;
  ConnectionStatus get connectionStatus => _connectionStatus;

  bool get isOnline => _connectionStatus == ConnectionStatus.online;
  bool get isOffline => _connectionStatus == ConnectionStatus.offline;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  Future<void> refreshConnectionStatus() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    _updateConnectionStatus(connectivityResult);
  }

  void _updateConnectionStatus(List<ConnectivityResult> result) {
    if (result.contains(ConnectivityResult.mobile) ||
        result.contains(ConnectivityResult.wifi) ||
        result.contains(ConnectivityResult.ethernet) ||
        result.contains(ConnectivityResult.satellite) ||
        result.contains(ConnectivityResult.vpn)) {
      _connectionStatus = ConnectionStatus.online;
    } else if (result.contains(ConnectivityResult.none)) {
      _connectionStatus = ConnectionStatus.offline;
    } else {
      _connectionStatus = ConnectionStatus.unknown;
    }
    notifyListeners();
  }

  @override
  Future<void> dispose() async {
    await _connectivitySubscription?.cancel();
    super.dispose();
  }
}
