import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


openMessageDialog(BuildContext context, String text) {
  showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(

        content: Column(children: <Widget>[
          Text(text),
          Align(
            alignment: Alignment.topRight,
            child: MaterialButton(child: Text("Ok"),onPressed: ()=> Navigator.pop(context),
              minWidth: 0,
            ),
          ),
        ],
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
        ),
      )
  );
}