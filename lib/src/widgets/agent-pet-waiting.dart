import 'package:flutter/material.dart';

class AgentPetWaiting extends StatefulWidget {
  final double width;

  AgentPetWaiting({this.width = 20});

  @override
  _AgentPetWaitingState createState() => _AgentPetWaitingState();
}

class _AgentPetWaitingState extends State<AgentPetWaiting>
  with SingleTickerProviderStateMixin {
  double _gap;
  double _size;

  AnimationController _controller;
  Animation<double> _position;

  @override
  void initState() {
    super.initState();

    this._gap = widget.width / 6;
    this._size = widget.width / 3;

    this._controller = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this
    )..addListener(() => setState(() {}));

    this._position = Tween<double>(
      begin: -1.0,
      end: 0.0
    ).animate(CurvedAnimation(
      curve: Curves.ease,
      parent: _controller
    ));
  }

  @override
  Widget build(BuildContext context) {
    try {
      _controller
          .repeat();   // start paper animation over


    } on TickerCanceled {}

    return SizedBox(
      height: widget.width,
      width: widget.width + (this._gap * 3),

      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => child,
        child: Stack(children: <Widget>[
          _Circle(position: -1 -_position.value, size: _size, scale: _position.value + 1),
          _Circle(position: _position.value, size: _size),
          _Circle(position: _position.value + 1, size: _size),
          _Circle(position: -_position.value, size: _size, scale: -_position.value),
        ]),
      ),
    );
  }

  @override
  void dispose() {
    this._controller.dispose();
    super.dispose();
  }
}

class _Circle extends StatelessWidget {
  final double scale;
  final double position;
  final double size;

  _Circle({this.position, this.size, this.scale = 1});

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: Align(
        alignment: Alignment(this.position, 0),
        child: Container(
          width: size,
          height: size,

          decoration: BoxDecoration(
            color: Colors.primaries[0],
            borderRadius: BorderRadius.circular(size / 2)
          ),
        ),
      ),
    );
  }
}

