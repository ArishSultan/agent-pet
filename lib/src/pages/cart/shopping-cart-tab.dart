import 'package:agent_pet/src/models/order-item.dart';
import 'package:agent_pet/src/pages/cart/cart-data.dart';
import 'package:agent_pet/src/pages/cart/main-cart.dart';
import 'package:agent_pet/src/services/_service.dart';
import 'package:agent_pet/src/utils/custom-navigator.dart';
import 'package:agent_pet/src/utils/local-data.dart';
import 'package:agent_pet/src/widgets/loading-builder.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ShoppingCart extends StatefulWidget {
  final Function next;

  ShoppingCart({this.next});

  @override
  ShoppingCartState createState() => ShoppingCartState();
}

class ShoppingCartState extends State<ShoppingCart> {
  List<OrderItem> _products;


  @override
  void initState() {
    super.initState();
    isDisabledCart=[false,true,true];
//
//    print(LocalData.getCart()[1].selectedAttribute.id);
//    print(LocalData.getCart()[1].selectedAttribute.quantity);
//    print(LocalData.getCart()[1].selectedAttribute.weight);
//    print(LocalData.getCart()[1].selectedAttribute.productId);

    this._products = LocalData.getCart();

  }



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: CustomScrollView(slivers: <Widget>[

        _products.length < 1 ? SliverToBoxAdapter(child: Center(
           heightFactor: 10,
          child: FlatButton(
            padding: EdgeInsets.all(15),
              color: Colors.primaries[0],
              child: Text("Start Shopping", style: TextStyle(color: Colors.white)),
              onPressed: () {
                CustomNavigator.baseNavigateTo(1, 0, 0);
                Navigator.of(context).pop();
              }
          ),
        ),) :
        SliverList(delegate: SliverChildBuilderDelegate(
                (context, i) {
              return Stack(children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          border: Border.all(color: Colors.grey.shade400)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(children: <Widget>[
                          Container(
                            width: 70,
                            height: 70,
                            child: Image.network(Service.getConvertedImageUrl("storage/${_products[i].product.cover}"),
                              loadingBuilder: circularImageLoader,
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(child: Column(
                            children: <Widget>[
                              Text(_products[i].product.name, style: TextStyle(
                                  fontSize: 17,
                              ),maxLines: 2,),
                              _products[i].selectedAttribute!=null ?
                              Text("${_products[i].qty}xPKR ${_products[i].selectedAttribute.price} ", style: TextStyle(color: Colors.red)):
                              Text("${_products[i].qty}xPKR ${_products[i].product.price} ", style: TextStyle(color: Colors.red))

                            ],
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                          )),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(children: <Widget>[
                                  MaterialButton(
                                    shape: CircleBorder(),
                                    minWidth: 0,
                                    padding: EdgeInsets.only(right: 10),
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    onPressed: () => setState(() {
                                  if (this._products[i].qty > 1)
                                    --_products[i].qty;
                                    }),
                                    child: Icon(Icons.remove_circle),
                                  ),
                                  Text(_products[i].qty.toString()),
                                  MaterialButton(
                                    padding: EdgeInsets.only(left: 10),
                                    shape: CircleBorder(),
                                    child: Icon(Icons.add_circle),
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    onPressed: () => setState(() {

                                  if (this._products[i].qty <=
                                      _products[i].product.quantity) ++_products[i].qty;

                                    }),
                                    minWidth: 0,
                                  ),
                                ],mainAxisSize: MainAxisSize.min,

                                mainAxisAlignment: MainAxisAlignment.end,
                                ),
                                SizedBox(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() => LocalData.removeFromCart(i));
                                    },
                                    child:Text("Remove",style: TextStyle(color: Colors.primaries[0]),),

                                  ),
                                )
                              ],
                            )

                        ]),

                      )
                  ),
                ),


              ]);
            },
            childCount: _products.length
        )),

      _products.length > 0 ?  SliverToBoxAdapter(
          child: Column(children: <Widget>[
            SizedBox(height: 20),
            Align(alignment: Alignment.topRight,child: Text("Subtotal: PKR ${_getTotal()}")),
            SizedBox(height: 20),
            FlatButton(
                color: Colors.grey.shade600,
                child: ConstrainedBox(
                  constraints: BoxConstraints.expand(height: 40),
                  child: Center(child: Text("Checkout", style: TextStyle(color: Colors.white))),
                ),
                onPressed: () {
                  if(_products.length > 0){
                    isDisabledCart=[false,false,true];
                    this.widget.next();
                  }else{
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text("No products in cart yet!"),
                      behavior: SnackBarBehavior.floating,
                      shape:RoundedRectangleBorder(),
                    ));
                  }
               }
            ),
            SizedBox(height: 30),
            Text("For Assistance, Offers & Discounts, Call : 0304-111-MEOW / 0304-111-6369",style: TextStyle(
              fontWeight: FontWeight.bold
            ),),

          ]),
        ): SliverToBoxAdapter(child: SizedBox())
      ]),
    );
  }

  _getTotal() {
    var sum = 0.0;

    _products.forEach((prod) {
      if (prod.selectedAttribute != null) {
        sum += prod.qty * double.parse(prod.selectedAttribute.price);
      } else {
        sum += prod.qty * double.parse(prod.product.price);
      }
    });

    return sum;
  }
}
