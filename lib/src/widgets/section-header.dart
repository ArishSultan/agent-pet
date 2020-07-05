import 'package:flutter/material.dart';

class SectionHeader extends Container {
  SectionHeader(String text, [Widget other]): super(
    color: Colors.grey.shade200,

    child: Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
      child: Row(
        children: <Widget>[
          Text(text, style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),overflow: TextOverflow.ellipsis,),
          Spacer(),
          other != null? other: Container(),
        ],
      ),
    )
  );
}
