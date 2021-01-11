import 'package:flutter/material.dart';

class SectionHeader extends Container {
  SectionHeader(String text, [Widget other])
      : super(
          color: Colors.grey.shade200,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
            child: Row(
              children: <Widget>[
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 17,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Spacer(),
                other != null ? other : Container(),
              ],
            ),
          ),
        );
}
