import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageNotSelected extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("No Image Selected!",style: TextStyle(fontWeight: FontWeight.bold),),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text("You must upload at least one image."),
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
