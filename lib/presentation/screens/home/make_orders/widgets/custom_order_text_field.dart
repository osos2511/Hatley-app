import 'package:flutter/material.dart';
import 'package:hatley/core/colors_manager.dart';

class CustomOrderTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final int maxLines;
  final TextInputType keyboardType;

  const CustomOrderTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(color: Colors.white),
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,


        labelStyle: TextStyle(color: ColorsManager.white),
        border: OutlineInputBorder(
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorsManager.white)
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ColorsManager.white)
        ),

      ),
    );
  }
}
