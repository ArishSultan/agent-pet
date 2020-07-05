import 'package:flutter/material.dart';

class CustomFlatButton extends StatelessWidget {
  final String title;
  final Function onPressed;
  CustomFlatButton({@required this.title,@required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      child: ConstrainedBox(
        constraints: BoxConstraints.expand(height: 40),
        child: FlatButton(
            child: Text(title),
            color: Colors.primaries[0],
            onPressed: () => onPressed()
        ),
      ),
    );
  }
}
