import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityHelper {
  final Function(bool) onConnectivityChanged;

  ConnectivityHelper({required this.onConnectivityChanged});

  void initConnectivityListener() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        onConnectivityChanged(false);
      } else {
        onConnectivityChanged(true);
      }
    });
  }
}
