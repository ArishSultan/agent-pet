import 'package:flutter/material.dart';


openLoadingDialog(BuildContext context, String text) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(children: <Widget>[
          SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(
                  strokeWidth: 1,
                  valueColor: AlwaysStoppedAnimation(Colors.black)
              )
          ),

          SizedBox(width: 10),

          Text(text)
        ]),
      )
  );
}