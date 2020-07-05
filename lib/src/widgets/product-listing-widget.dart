import 'package:agent_pet/src/models/order-item.dart';
import 'package:agent_pet/src/models/product.dart';
import 'package:agent_pet/src/pages/product-detail_page.dart';
import 'package:agent_pet/src/services/_service.dart';
import 'package:agent_pet/src/utils/custom-navigator.dart';
import 'package:agent_pet/src/utils/local-data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'favorite-button.dart';
import 'local-favorite-button.dart';

class ProductListingWidget extends StatefulWidget {
  final Product product;

  ProductListingWidget(
      {this.product});

  @override
  _ProductListingWidgetState createState() => _ProductListingWidgetState();
}

class _ProductListingWidgetState extends State<ProductListingWidget> {
  @override
  Widget build(BuildContext context) {
      return Stack(
      children: <Widget>[


        Padding(
          padding: const EdgeInsets.symmetric(horizontal:8.0,vertical: 4),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(width: 0.5, color: Colors.black12)),
            padding: EdgeInsets.all(4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: .0, top: 0),
                  child: Container(
                    decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                    ClipRect(
                    child: Stack(
                        children: <Widget>[
                        Image.network(
                            widget.product.cover != null
                                ? Service.getConvertedImageUrl("storage/${widget.product.cover}")
                                : 'https://www.agentpet.com/img/no-image2.png',
                            width: 100,
                            height: 100,
                            fit: BoxFit.fill,
                            loadingBuilder: (context, widget, event) {
                              if (event != null) {
                                return  Padding(
                                  padding: const EdgeInsets.all(32.0),
                                  child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation(Colors.black),
                                      value: event.cumulativeBytesLoaded / event.expectedTotalBytes
                                  ),
                                );
                              } else if (widget != null) {
                                return widget;
                              } return CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(Colors.black),
                              );
                            }
                        ),
                          widget.product.isFeatured ?
                          Transform.translate(
                              offset: Offset(-55, -55),
                              child: Transform.rotate(
                                angle: 225.45,
                                child: Container(
                                    width: 100,
                                    height: 100,
                                    color: Theme.of(context).primaryColor,
                                    child: Align(
                                      alignment: Alignment(0, .97),
                                      child: Text("Featured", style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold
                                      ), textAlign: TextAlign.center),
                                    )
                                ),
                              )
                          ): Container()
          ],
                          ),),
                      ]
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Flexible(
                                child: Column(
                                  children: <Widget>[
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        widget.product.name[0].toUpperCase() +
                                            widget.product.name.substring(1),
                                        maxLines: 2,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold, fontSize: 16,),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                             FavoriteButton(id: widget.product.id, isPetAd: false,) ,
                            ],
                          ),
                        ],
                      ),
                      Container(
                        child: Row(
                          children: <Widget>[

                            Image.asset(
                              widget.product.cat == 'pet-food' ?   "assets/icons/bowl.png" : "assets/icons/collar.png",
                              scale: 5,
                              color: Colors.grey.shade600,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(widget.product.cat == 'pet-food' ? "Food" : 'Accessory'),
                            SizedBox(
                              width: 5,
                            ),


                          ],
                        ),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Text("PKR ${widget.product.price}",style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15,color: Colors.primaries[0]),),


                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          right: 18,
          child: widget.product.quantity > 0 ? RaisedButton(
            padding: EdgeInsets.symmetric(horizontal:5),
            child: Text(widget.product.attributes.isEmpty ?"Add to Cart" : 'Select Options',style: TextStyle(color: Colors.white)),
            color: Color(0xFF06b729),
            onPressed: () {
              if(widget.product.attributes.isEmpty){
                var item = OrderItem(
                  qty: 1,
                  product: widget.product,
                );

                if (LocalData.canPurchase(item)) {
                  setState(() {
                    LocalData.addToCart(item);
                  });
                  Scaffold.of(context).hideCurrentSnackBar();
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text(
                        "${widget.product.name} added successfuly!"),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(),
                  ));
                } else {
                  List<OrderItem> _products =
                  LocalData.getCart();
                  _products.forEach((prod) {
                    if (item.id == prod.id) {
                      setState(() {
                        prod.qty += 1;
                      });
                    }
                  });
                  LocalData.likeChanged();

                  Scaffold.of(context).hideCurrentSnackBar();
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text(
                        "${widget.product.name} added successfuly!"),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(),
                  ));
                }
              }else{
                CustomNavigator.navigateTo(context, ProductDetailPage(product: widget.product));
              }

            }
            ): Padding(
            padding: EdgeInsets.all(20),
            child: Text("Out of stock",style: TextStyle(color: Colors.primaries[0],fontSize: 15),),
          ),
        ),
      ],
    );
  }


}
