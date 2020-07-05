import 'dart:async';
import 'package:agent_pet/src/models/order-item.dart';
import 'package:flutter/material.dart';


List<bool> isDisabledCart = [false,true,true];

class CartData {

  String referenceId;
  String total;
  String subtotal;
  int tax;
  String shippingMethod;
  String orderDate;

  // ignore: close_sinks
  final StreamController _streamController = StreamController.broadcast();

  Stream get stream => _streamController.stream;

  Sink get sink => _streamController.sink;
}

class InheritedCart extends InheritedWidget {
  final CartData data;

  InheritedCart({
    Key key,
    @required Widget child,
  })  : assert(child != null),
        data = CartData(),
        super(key: key, child: child);

  static CartData of(BuildContext context) => (context.inheritFromWidgetOfExactType(InheritedCart) as InheritedCart).data;

  @override
  bool updateShouldNotify(InheritedCart old) => false;
}
