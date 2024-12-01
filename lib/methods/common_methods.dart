import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class CommonMethods {
  checkConnectivity(BuildContext context) async {
    var connectionResult = await Connectivity().checkConnectivity();

    if (connectionResult != ConnectivityResult.mobile &&
        connectionResult != ConnectivityResult.wifi) {
      if (!context.mounted) return;
      displaySnackBar(
          "Your internet is not available. Check your connection and try again",
          context);
    }
  }

  displaySnackBar(String messegeText, BuildContext context) {
    var snackBar = SnackBar(content: Text(messegeText));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
