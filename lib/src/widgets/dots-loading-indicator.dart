import 'package:flutter/material.dart';

class DotsLoadingIndicator extends StatefulWidget {

  /// This indicates the size of this [Widget] by
  /// default its value is set to 20, but you can
  /// also, change its value according to your need.
  ///
  /// To be more specific you can say that it is the
  /// width of the [Widget], height will be calculated
  /// automatically from [size]
  final double size;

  /// This is the [Color] that will be assigned to the
  /// dots being animated.
  ///
  /// By default, it will take the [accent] color.
  final Color color;

  DotsLoadingIndicator({this.size = 20, this.color});

  @override
  _DotsLoadingIndicatorState createState() => _DotsLoadingIndicatorState();
}

class _DotsLoadingIndicatorState extends State<DotsLoadingIndicator>
    with SingleTickerProviderStateMixin {

  /// This is the gap between the dots that are
  /// shown in this animation.
  ///
  /// value of [_dotsGap] will not be calculated
  /// again and again, So, it is initialized in
  /// the [initState] depending upon the provided
  /// [size]
  double _dotsGap;

  ///
  Container _dot;

  /// These are the main entities that will control
  /// the whole animation process.
  Animation<double> _offset;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();

    this._dotsGap = widget.size / 6;
    final dotSize = widget.size / 3;

    this._dot = Container(
      width: dotSize,
      height: dotSize,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(dotSize / 2),
        color: widget.color != null? widget.color: Colors.accents[0]
      ),
    );



    /// Initialize the controller.
    _controller = AnimationController(
      vsync: this, duration: Duration(milliseconds: 500)
    )..repeat();

    /// Initialize the animation.
    _offset = Tween<double>(end: 1, begin: 0).animate(CurvedAnimation(
      curve: Interval(0, 1, curve: Curves.easeInOutQuad),
      parent: _controller
    ));
  }

  @override
  dispose() {
    _controller.dispose(); // you need this
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.size,
      width: widget.size + _dotsGap * 4,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget child) {
          return Stack(children: <Widget>[
            Align(child: Transform.scale(scale: _offset.value, child: _dot), alignment: Alignment(-1, 0)),
            Align(child: _dot, alignment: Alignment(_offset.value - 1, 0)),
            Align(child: _dot, alignment: Alignment(_offset.value, 0)),
            Align(child: Transform.scale(scale: 1 - _offset.value, child: _dot), alignment: Alignment(1, 0))
          ]);
        },

        child: Stack(children: <Widget>[
          Align(child: _dot, alignment: Alignment(-1, 0)),
          Align(child: _dot, alignment: Alignment(-0.35, 0)),
          Align(child: _dot, alignment: Alignment(0.35, 0)),
          Align(child: _dot, alignment: Alignment(1, 0)),
        ])
      )
    );
  }
}
