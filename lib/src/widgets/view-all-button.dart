import 'package:flutter/material.dart';

Widget viewAllBtn({VoidCallback onPressed}){
  return Material(
    child: InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.only(right:8.0),
        child: Container(child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Text("View All",textScaleFactor: 0.8,style: TextStyle(
              color: Colors.primaries[0]
          ),),
        ),
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all( color: Colors.primaries[0],width: 1.5)
          ),),
      ),
    ),
  );
}