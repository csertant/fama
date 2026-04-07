import 'package:fama/data/services/connectivity_service/connectivity_service.dart';

class MockConnectivityService extends ConnectivityService {
  @override
  Future<void> refreshConnectionStatus() async {
    // Do nothing, keep the default status
  }

  @override
  bool get isOnline => true;
  @override
  bool get isOffline => false;
}
