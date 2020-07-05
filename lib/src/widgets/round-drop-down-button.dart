import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RoundDropDownButton<T> extends StatelessWidget {
  final T value;
  final Widget hint;
  final Function(T value) onChanged;
  final List<DropdownMenuItem<T>> items;

  RoundDropDownButton({
    this.hint,
    this.value,
    this.onChanged,
    this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(4)
      ),

      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 1),
        child: DropdownButtonFormField(
          hint: this.hint,
          isDense: true,
          validator: (value)=>  value == null ? 'Please select an item in the list' : null,
          decoration: InputDecoration.collapsed(hintText: ''),
          items: this.items,
          value: this.value,
          onChanged: this.onChanged,

          isExpanded: true,
        ),
      ),
    );
  }
}
