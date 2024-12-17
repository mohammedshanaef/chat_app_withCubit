import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, [FirebaseAuthException? ex]) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ex.toString())));
}
