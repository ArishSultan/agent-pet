import 'package:flutter/material.dart';

Widget bulletPoint({String title}){
  return Row(
    children: <Widget>[
      Container(height: 8,width: 8, decoration: BoxDecoration(borderRadius: BorderRadius.circular(40), color: Colors.red),),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal:8.0),
          child: Text(title),
        ),
      ),
    ],
  );
}