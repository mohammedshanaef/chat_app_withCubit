import 'package:flutter/material.dart';

/// A generic function to show a SnackBar with a given text
void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
    ),
  );
}
