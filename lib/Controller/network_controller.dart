import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(ConnectivityResult connectivityResult) {
    if (connectivityResult == ConnectivityResult.none) {
      Get.rawSnackbar(
          messageText: const Text('PLEASE CONNECT TO THE INTERNET',
              style: TextStyle(color: Colors.white, fontSize: 14)),
          isDismissible: false,
          duration: const Duration(minutes: 2),
          backgroundColor: Color.fromARGB(255, 241, 9, 5)!,
          icon: const Icon(
            Icons.wifi_off,
            color: Colors.white,
            size: 35,
          ),
          margin: EdgeInsets.zero,
          snackStyle: SnackStyle.GROUNDED);
    } else {
      if (Get.isSnackbarOpen) {
        Get.closeCurrentSnackbar();
      }
 Get.closeCurrentSnackbar();
    }
  }

  Future<ConnectivityResult> checkConnectivity() async {
    return await _connectivity.checkConnectivity();
  }
}
