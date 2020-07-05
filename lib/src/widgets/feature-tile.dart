import 'package:flutter/material.dart';


class FeatureTile extends StatelessWidget {
  bool b1;
//  Icon i1;
//  Icon i2;
  String t1;
  String v1;
  String t2;
  String v2;
  FeatureTile({this.t1,this.v1,this.t2,this.v2,this.b1});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: b1 ? Colors.grey.shade200 : Colors.white,
      child: Row(
        children: <Widget>[
          SizedBox(width: 10,),
        Expanded (child: ListTile(
          dense: true,
          leading: Padding(
            padding: const EdgeInsets.only(top:5),
            child: Icon(Icons.pets,size:20,),
          ),title: Text(t1,style: TextStyle(fontSize: 16),),
          subtitle: Text(v1,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 18),
          ),
        )),
      Expanded (child: ListTile(
        dense: true,

        leading: Padding(
          padding: const EdgeInsets.only(top:5),
          child: Icon(Icons.pets,size:20,),
        ),title: Text(t2,style: TextStyle(fontSize: 16),),
        subtitle: Text(v2,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 18),
        ),
      )),
        ],
      ),
    );
  }
}
