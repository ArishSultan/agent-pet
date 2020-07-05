import 'package:flutter/material.dart';


class Badge extends StatefulWidget {
  final Widget badge;
  final Widget child;
  final double size;

  Badge({
    this.badge,
    this.child,
    this.size = 24
  });

  Badge.numbered({
    int number,
    double size = 24,
    Widget child,
  }): this(badge: Text(number.toString(), style: TextStyle(fontSize: 8, color: Colors.white)), child: child, size: size);

  @override
  _BadgeState createState() => _BadgeState();
}

class _BadgeState extends State<Badge> {
  @override build(BuildContext context) {

    return Container(
      width: widget.size, height: widget.size,
      child: Stack(children: <Widget>[
        Align(
          child: this.widget.child,
          alignment: Alignment(0, 0)
        ),

        Positioned(
          top: -5,
          right: -5,
          child: Material(
            elevation: 2,
            borderRadius: BorderRadius.circular(widget.size / 2),

            child: Container(
              width: widget.size / 1.7,
              height: widget.size / 1.7,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(widget.size / 2)
              ),
              child: Align(
                alignment: Alignment.center,
                child: this.widget.badge
              )
            ),
          ),
        )
      ], overflow: Overflow.visible),
    );
  }
}
