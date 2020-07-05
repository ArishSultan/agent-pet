import 'package:flutter/material.dart';

class Bubble extends StatelessWidget {
  Bubble({this.message, this.time,  this.isMe});
  final String message, time;
  final isMe;

  @override
  Widget build(BuildContext context) {
    final bubbleColor = isMe ? Colors.primaries[0] : Colors.grey.shade200;
    final msgTxtColor = isMe ? Colors.white : Colors.black;
    final align = isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final radius = isMe
        ?  BorderRadius.only(
        topLeft: Radius.circular(5.0),
        bottomLeft: Radius.circular(5.0),
        bottomRight: Radius.circular(10.0)
    )
        : BorderRadius.only(
      topRight: Radius.circular(5.0),
      bottomLeft: Radius.circular(10.0),
      bottomRight: Radius.circular(5.0)

    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal :8.0),
      child: Column(
        crossAxisAlignment: align,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(3.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    blurRadius: .5,
                    spreadRadius: 1.0,
                    color: Colors.black.withOpacity(.12))
              ],
              color: bubbleColor,
              borderRadius: radius,
            ),
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 48.0),
                  child: Text(message,style: TextStyle(color: msgTxtColor),),
                ),
                Positioned(
                  bottom: 0.0,
                  right: 0.0,
                  child: Row(
                    children: <Widget>[
                      Text(time,
                          style: TextStyle(
                            color: msgTxtColor,
                            fontSize: 10.0,
                          )),
                      SizedBox(width: 3.0),

                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
