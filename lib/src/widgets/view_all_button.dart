import 'package:agent_pet/src/base/theme.dart';
import 'package:flutter/material.dart';

class SmallOutlinedButton extends OutlinedButton {
  SmallOutlinedButton(String text, VoidCallback onPressed): super(
    style: OutlinedButton.styleFrom(
      textStyle: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.bold,
      ),
      padding: EdgeInsets.zero,
      primary: AppTheme.primaryColor,
      visualDensity: VisualDensity.compact,
      side: BorderSide(color: AppTheme.primaryColor, width: 2),
    ),
    child: Text('View All'),
    onPressed: onPressed,
  );
}