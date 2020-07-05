import 'package:agent_pet/src/pages/cart/main-cart.dart';
import 'package:agent_pet/src/utils/custom-navigator.dart';
import 'package:agent_pet/src/utils/local-data.dart';
import 'package:flutter/material.dart';

import 'badge.dart';

class CartBadgedIcon extends StatefulWidget {
  final bool white;
  CartBadgedIcon({this.white = true});
  @override
  _CartBadgedIconState createState() => _CartBadgedIconState();
}

class _CartBadgedIconState extends State<CartBadgedIcon> {
  @override
  void initState() {

    LocalData.registerLikeListener(() {
      setState(() {
        print("registered");
      });

    });
    super.initState();

  }





  @override
  Widget build(BuildContext context) {

    return IconButton(
      icon: Badge.numbered(
        number: LocalData.getCart().length,
        child: Icon(
          Icons.shopping_cart,
          color: widget.white? Colors.white: Colors.black,
        ),
      ),
      onPressed: () =>
          CustomNavigator.navigateTo(context, CartPage()),
    );
  }
  @override
  void dispose() {
    LocalData.unRegisterLikeListener();
    super.dispose();
  }
}
