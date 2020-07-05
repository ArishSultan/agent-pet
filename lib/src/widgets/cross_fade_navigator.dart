//import 'package:flutter/material.dart';
//
//class CrossFadeNavigatorItem {
//  final String title;
//  final Widget body;
//
//  CrossFadeNavigatorItem({
//    @required this.title,
//    @required this.body
//  }): assert(title != null),
//      assert(body != null);
//}
//
//class CrossFadeNavigator extends StatefulWidget {
//  final List<CrossFadeNavigatorItem> items;
//
//  final double fontSize;
//  final String fontFamily;
//
//  final Color idleColor;
//  final Color selectedColor;
//
//  final int initial;
//
//  CrossFadeNavigator(
//    this.items,
//    {this.selectedColor, this.idleColor, this.fontFamily, this.fontSize, this.initial = 0}
//  ) {
//    print(this.items);
//  }
//
//  @override createState() => _CrossFadeNavigatorState();
//}
//
//class _CrossFadeNavigatorState extends State<CrossFadeNavigator> with TickerProviderStateMixin {
//  int selectedIndex;
//
//  AnimationController _controller;
//
//  Animation<Color> _idleAnimation;
//  Animation<Color> _selectedAnimation;
//
//  List<Animation<Color>> _uselessAnimation;
//
//  @override initState() {
//    super.initState();
//
//    _controller =
//        AnimationController(duration: Duration(milliseconds: 200), vsync: this);
//
////    _uselessAnimation = List<Animation<Color>>(widget.items.length).map((f) => CurvedAnimation(
////      parent: _controller,
//      curve: Curves.ease
//    )).toList();
//
//    _idleAnimation = ColorTween(
//      end: widget.idleColor,
//      begin: widget.selectedColor,
//    ).animate(
//        CurvedAnimation(
//            parent: _controller,
//            curve: Interval(0, 1, curve: Curves.ease)
//        )
//    );
//
//    _selectedAnimation = ColorTween(
//      begin: widget.idleColor,
//      end: widget.selectedColor,
//    ).animate(
//        CurvedAnimation(
//            parent: _controller,
//            curve: Interval(0, 1, curve: Curves.ease)
//        )
//    );
//
//    _handleCrossFade(widget.initial, false);
//  }
//
//  _handleCrossFade(int index, bool animate) {
////    assert(index >= 0 && index <= widget.items.length);
//
//    if (animate) {
//
//    } else {
//      setState(() {
//
//      });
//    }
//  }
//
//  @override build(context) => Column(
//    children: [
//      ConstrainedBox(
//        constraints: BoxConstraints.expand(height: 70),
//        child: ListView.builder(
//          itemCount: widget.items.length,
//
//          scrollDirection: Axis.horizontal,
//
//          itemBuilder: (context, index) => Container(
//            decoration: BoxDecoration(
//              color: _uselessAnimation[index].value,
//              border: Border.all(color: widget.selectedColor),
//            ),
//
//            child: Text(
//              widget.items[index].title,
//
//              style: TextStyle(
//                fontSize: widget.fontSize,
//                fontFamily: widget.fontFamily,
//                fontWeight: FontWeight.bold
//              )
//            ),
//          ),
//        ),
//      ),
//    ],
//  );
//}

import 'package:flutter/material.dart';

class CrossFadeNavigator extends StatefulWidget {
  final String firstTitle;
  final String secondTitle;

  final Widget firstChild;
  final Widget secondChild;

  final Color foregroundColor;
  final Color backgroundColor;

  final double fontSize;
  final String fontFamily;

  final int index;

  CrossFadeNavigator({
    this.firstTitle,
    this.secondTitle,
    this.firstChild,
    this.secondChild,

    this.foregroundColor,
    this.backgroundColor,

    this.fontFamily,
    this.fontSize,
    this.index = 0,
  });

  @override createState() => _CrossFadeNavigatorState();
}

class _CrossFadeNavigatorState extends State<CrossFadeNavigator> with TickerProviderStateMixin {
  Animation<Color> nav1;
  Animation<Color> nav2;
  AnimationController _controller;

  CrossFadeState view = CrossFadeState.showFirst;

  initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 100));

    nav2 = ColorTween(
        begin: widget.backgroundColor,
        end: widget.foregroundColor
    ).animate(
        CurvedAnimation(
            parent: _controller,
            curve: Interval(0, 1, curve: Curves.ease)
        )
    );

    nav1 = ColorTween(
        begin: widget.foregroundColor,
        end: widget.backgroundColor
    ).animate(
        CurvedAnimation(
            parent: _controller,
            curve: Interval(0, 1, curve: Curves.ease)
        )
    );

    var d = _controller.duration;

    _controller.duration = Duration(milliseconds: 0);

    if (widget.index == 1) {
      _controller.forward().orCancel;
      setState(() => view = CrossFadeState.showFirst);
    }

    _controller.duration = d;
  }

  handle(index) {
    FocusScope.of(context).unfocus();
    if (index == 1) {
      _controller.forward().orCancel;
      setState(() => view = CrossFadeState.showFirst);
    } else {
      _controller.reverse().orCancel;
      setState(() => view = CrossFadeState.showSecond);
    }
  }

  @override build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,

    children: [

      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 70),
        child: Container(
          width: 300,
          height: 50,

          decoration: BoxDecoration(
              border: Border.all(color: widget.backgroundColor, width: 1),
              borderRadius: BorderRadius.circular(50)
          ),

          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),

            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, w) => Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => handle(1),

                      child: Container(
                        color: nav1.value,
                        child: Center(
                          child: Text(
                            widget.firstTitle,

                            style: TextStyle(
                                color: nav2.value,
                                fontSize: widget.fontSize,
                                fontFamily: widget.fontFamily,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    child: GestureDetector(
                      onTap: () => handle(2),

                      child: Container(
                        color: nav2.value,
                        child: Center(
                            child: Text(
                              widget.secondTitle,

                              style: TextStyle(
                                  color: nav1.value,
                                  fontSize: widget.fontSize,
                                  fontFamily: widget.fontFamily,
                                  fontWeight: FontWeight.bold

                              ),
                            )
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),

      Flexible(
        fit: FlexFit.loose,
        child:
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: AnimatedCrossFade(
            duration: Duration(milliseconds: 200),
            crossFadeState: view,
            firstChild: widget.firstChild,
            secondChild: widget.secondChild,
          ),
        ),
      )
    ],
  );
}
