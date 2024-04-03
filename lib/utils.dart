import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void showSnackbar(BuildContext context, String msg) {
  final snackBar = SnackBar(
    duration: const Duration(seconds: 1),
    content: Text(msg),
    backgroundColor: Colors.blue,
    action: SnackBarAction(
      label: "Done",
      textColor: Colors.black,
      onPressed: () {},
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showSnackbarError(BuildContext context, String msg) {
  final snackBar = SnackBar(
    duration: const Duration(seconds: 2),
    content: Text(msg),
    backgroundColor: Colors.red,
    action: SnackBarAction(
      label: "Done",
      textColor: Colors.red[400],
      onPressed: () {},
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void log(String msg) {
  if (kDebugMode) {
    debugPrint(msg);
  }
}
