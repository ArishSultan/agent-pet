import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotLoggedIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Not Logged In!",style: TextStyle(fontWeight: FontWeight.bold),),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text("You must be logged in to chat."),
          Align(
            child: FlatButton(onPressed: ()=> Navigator.of(context).pop(),
              child: Text("Ok"),
            ),
            alignment: Alignment.bottomRight,
          )
        ],
      ),
    );
  }
}
