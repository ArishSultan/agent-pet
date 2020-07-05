import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String message;
  ConfirmationDialog({@required this.message});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text("Are you sure you want to $message?",),
           Row(children: <Widget>[

              MaterialButton(child: Text("Yes"),onPressed: ()=> Navigator.pop(context,true),
               minWidth: 0,
               padding: EdgeInsets.only(left: 10),
             ),
             MaterialButton(child: Text("No"),onPressed: ()=> Navigator.pop(context,false),
               minWidth: 0,
               padding: EdgeInsets.only(left:  10,right: 2),
             ),
            ],
             mainAxisAlignment: MainAxisAlignment.end,

          )
        ],
      ),
    );
  }
}



