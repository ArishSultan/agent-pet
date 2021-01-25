import 'package:flutter/material.dart';

class AppTextField extends TextFormField {
  AppTextField({
    String label,
    int maxLines,
    bool dense = true,
    String placeholder,
    String initialValue,
    TextInputType keyboardType,
    ValueChanged<String> onChanged,
    FormFieldSetter<String> onSaved,
    TextEditingController controller,
    FormFieldValidator<String> validator,
  }) : super(
    maxLines: maxLines,
    validator: validator,
    keyboardType: keyboardType,
    decoration: InputDecoration(
      isDense: dense,
      labelText: label,
      contentPadding: const EdgeInsets.fromLTRB(12, 15, 12, 10),
      alignLabelWithHint: true,
      border: OutlineInputBorder(),
    )
  );
}
