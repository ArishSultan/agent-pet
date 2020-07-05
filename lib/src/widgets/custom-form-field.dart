import 'package:flutter/material.dart';

class CustomFormField extends TextFormField {
  CustomFormField({
    String label,
    dynamic lines = 1,
    bool dense = false,
    bool bordered = true,
    bool password = false,
    Widget suffixIcon,
    Function(String) validator,
    TextEditingController controller
  }): super(
      keyboardType: label == 'Email Address' ? TextInputType.emailAddress : (label == 'Phone #' ? TextInputType.phone : TextInputType.text),
      maxLines: lines,
    obscureText: password,
    decoration: InputDecoration(
      isDense: dense,
      labelText: label,
      border: bordered? OutlineInputBorder(): UnderlineInputBorder(),
      suffixIcon: suffixIcon
    ),
    controller: controller,

    validator: validator
  );
}
