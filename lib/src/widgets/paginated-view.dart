import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:agent_pet/src/models/_model.dart';
import 'package:agent_pet/src/services/paginated_service.dart';

class PaginatedView<T extends Model> extends StatefulWidget {
  final List<Widget> before;

  final Widget Function(Future<List<T>>) builder;
  final FutureOr<List<T>> Function(int) fetcher;

  PaginatedView({
    this.before,
    this.builder,
    this.fetcher
  }): assert(builder != null),
      assert(fetcher != null);

  @override
  _PaginatedViewState<T> createState() => _PaginatedViewState<T>();
}

class _PaginatedViewState<T extends Model> extends State<PaginatedView> {
  PaginatedService<T> _service;

  @override
  void initState() {
    super.initState();

    this.widget.before.addAll([
//      widget.builder();
    ]);
  }

  @override
  Widget build(BuildContext context) {

  }
}
