import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TabViewIndexed extends StatefulWidget {
  final List<Widget> views;
  final TabController controller;
  final bool indicator;

  TabViewIndexed({
    @required this.views,
    @required this.controller,
    this.indicator=false
  });

  @override
  _TabViewIndexedState createState() => _TabViewIndexedState();
}

class _TabViewIndexedState extends State<TabViewIndexed> {
  List<Widget> _indexer;

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(() { setState(() {}); });

//    _indexer =
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Expanded(
        child: TabBarView(
          controller: widget.controller,
          children: widget.views,
        ),
      ),
      widget.indicator ?
      Row(
        children: List.generate(widget.controller.length, (val) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Container(
              width: 5, height: 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2.5),
                color: val == widget.controller.index? Colors.primaries[0]: Colors.grey.shade300,
              ),
            ),
          );
        }),
        mainAxisAlignment: MainAxisAlignment.center
      ) : SizedBox(),
    ]);
  }
}
