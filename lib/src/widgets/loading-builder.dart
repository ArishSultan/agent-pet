
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget circularImageLoader (BuildContext context, Widget widget, ImageChunkEvent event){
    if (event != null) {
      return  Center(
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.black),
            value: event.cumulativeBytesLoaded / event.expectedTotalBytes
        ),
      );
    } else if (widget != null) {
      return widget;
    } return CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Colors.black),
    );
  }


