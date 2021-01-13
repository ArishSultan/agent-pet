import 'package:flutter/material.dart';
import 'package:agent_pet/src/utils/simple-future-builder.dart';

class RefreshController {
  _RefreshableState _state;

  Future<void> refresh() => _state.refresh();
}

typedef ItemBuilder<T> = Widget Function(T t);
typedef Fetcher<T> = Future<List<T>> Function();

class Refreshable<T> extends StatefulWidget {
  final Fetcher<T> fetcher;
  final Axis scrollDirection;
  final ItemBuilder<T> builder;
  final RefreshController controller;

  const Refreshable({
    this.fetcher,
    this.builder,
    this.controller,
    this.scrollDirection,
  });

  @override
  _RefreshableState<T> createState() => _RefreshableState();
}

class _RefreshableState<T> extends State<Refreshable> {
  Future<List<T>> data;

  void initState() {
    super.initState();
    data = widget.fetcher();

    if (widget.controller != null) {
      widget.controller._state = this;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SimpleFutureBuilder.simpler(
      future: data,
      context: context,
      builder: (AsyncSnapshot<List<T>> data) {
        return ListView.builder(
          itemCount: data.data.length,
          scrollDirection: widget.scrollDirection,
          itemBuilder: (context, i) => widget.builder(data.data[i]),
        );
      },
    );
  }

  Future<void> refresh() async {
    data = widget.fetcher();
    await data;

    setState(() {});
  }
}
