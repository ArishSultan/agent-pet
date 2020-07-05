import 'package:agent_pet/src/models/ratings-count.dart';
import 'package:flutter/material.dart';

class ReviewCounter extends StatelessWidget {
  final RatingsCount count;

  final arr = [0.0, 0.0, 0.0, 0.0, 0.0];

  ReviewCounter({
    this.count
  }) {
    if (count.total != 0) {
      arr[0] = (count.i1 / count.total);
      arr[1] = (count.i2 / count.total);
      arr[2] = (count.i3 / count.total);
      arr[3] = (count.i4 / count.total);
      arr[4] = (count.i5 / count.total);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(children: <Widget>[
          Text('5', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
          Icon(Icons.star, size: 13, color: Colors.grey.shade600),

          SizedBox(width: 10),
          Expanded(child: LinearProgressIndicator(
            value: arr[4],
            backgroundColor: Colors.grey.shade400,
            valueColor: AlwaysStoppedAnimation(Colors.primaries[0]),
          )),
          SizedBox(width: 10),

          Text(count.i5.toString(), style: TextStyle(color: Colors.grey, fontSize: 13)),
        ]),
      ),

      Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(children: <Widget>[
          Text('4', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
          Icon(Icons.star, size: 13, color: Colors.grey.shade600),

          SizedBox(width: 10),
          Expanded(child: LinearProgressIndicator(
            value: arr[3],
            backgroundColor: Colors.grey.shade400,
            valueColor: AlwaysStoppedAnimation(Colors.primaries[0]),
          )),
          SizedBox(width: 10),

          Text(count.i4.toString(), style: TextStyle(color: Colors.grey, fontSize: 13)),
        ]),
      ),

      Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(children: <Widget>[
          Text('3', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
          Icon(Icons.star, size: 13, color: Colors.grey.shade600),

          SizedBox(width: 10),
          Expanded(child: LinearProgressIndicator(
            value: arr[2],
            backgroundColor: Colors.grey.shade400,
            valueColor: AlwaysStoppedAnimation(Colors.primaries[0]),
          )),
          SizedBox(width: 10),

          Text(count.i3.toString(), style: TextStyle(color: Colors.grey, fontSize: 13)),
        ]),
      ),

      Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(children: <Widget>[
          Text('2', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
          Icon(Icons.star, size: 13, color: Colors.grey.shade600),

          SizedBox(width: 10),
          Expanded(child: LinearProgressIndicator(
            value: arr[1],
            backgroundColor: Colors.grey.shade400,
            valueColor: AlwaysStoppedAnimation(Colors.primaries[0]),
          )),
          SizedBox(width: 10),

          Text(count.i2.toString(), style: TextStyle(color: Colors.grey, fontSize: 13)),
        ]),
      ),

      Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(children: <Widget>[
          Text('1', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
          Icon(Icons.star, size: 13, color: Colors.grey.shade600),

          SizedBox(width: 10),
          Expanded(child: LinearProgressIndicator(
            value: arr[0],
            backgroundColor: Colors.grey.shade400,
            valueColor: AlwaysStoppedAnimation(Colors.primaries[0]),
          )),
          SizedBox(width: 10),

          Text(count.i1.toString(), style: TextStyle(color: Colors.grey, fontSize: 13)),
        ]),
      ),
    ]);
  }
}
