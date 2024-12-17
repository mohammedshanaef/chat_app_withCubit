import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final emailRegex = RegExp(r'^[\w\.-]+@[a-zA-Z\d\.-]+\.[a-zA-Z]{2,}$');
  final String hintText;
  final Icon prefixIcon;
  final Function(String) onChanged;
  final bool isPassword;

  // Constructor with required parameters and optional `isPassword` parameter
  CustomTextFormField({super.key, 
    required this.hintText,
    required this.prefixIcon,
    required this.onChanged,
    this.isPassword = false, // default to false for email
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      obscureText: isPassword, // Obscure text if this is a password field
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white),
        prefixIcon: prefixIcon,
        contentPadding: EdgeInsets.all(15),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
      // Validator for email or password validation
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your ${isPassword ? 'password' : 'email'}';
        } else if (!isPassword && !emailRegex.hasMatch(value)) {
          return 'Please enter a valid email';
        } else if (isPassword && value.length < 8) {
          return 'Password must be at least 8 characters long';
        }
        return null;
      },
    );
  }
}
