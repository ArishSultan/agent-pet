import 'package:flutter/material.dart';

class TitleBar extends Container {
  TitleBar({
    @required String title,
    Widget trailing
  }): super(
    color: Colors.grey.shade100,

    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(children: <Widget>[
        Text(title, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        trailing != null? trailing: Container(),
      ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
    )
  );
}