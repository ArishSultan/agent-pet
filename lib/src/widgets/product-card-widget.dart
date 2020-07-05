import 'package:agent_pet/src/models/order-item.dart';
import 'package:agent_pet/src/models/product.dart';
import 'package:agent_pet/src/pages/product-detail_page.dart';
import 'package:agent_pet/src/services/_service.dart';
import 'package:agent_pet/src/utils/custom-navigator.dart';
import 'package:agent_pet/src/utils/local-data.dart';
import 'package:agent_pet/src/widgets/loading-builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  ProductCard({@required this.product});

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 150,
        child: Card(
          elevation: 1,
          child: Material(
            child: InkWell(

              child: Column(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                        Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade400)
                        ),
                        height: 100,
                        width: 100,
                        child: ClipRect(
                          child: Stack(
                            children: <Widget>[
                              ConstrainedBox(
                                constraints: BoxConstraints.expand(),
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Image.network(
                                    Service.getConvertedImageUrl("storage/${widget.product.cover}"),
                                    fit: BoxFit.scaleDown,
                                      loadingBuilder: circularImageLoader
                                  ),
                                ),
                              ),
                              widget.product.isFeatured ?
                              Transform.translate(
                                  offset: Offset(-55, -55),
                                  child: Transform.rotate(
                                    angle: 225.45,
                                    child: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Container(
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                              color: Theme.of(context).primaryColor,
                                          ),
                                          child: Align(
                                            alignment: Alignment(0, .97),
                                            child: Text("Featured", style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold
                                            ), textAlign: TextAlign.center),
                                          )
                                      ),
                                    ),
                                  )
                              ): Container()
                            ],
                          ),
                        )
                      ),
//            SizedBox(
//              width: 100,
//              height: 100,
//              child: Image.network(
//                  widget.product.cover != null
//                      ? Service.getConvertedImageUrl("storage/${widget.product.cover}")
//                      : 'https://www.agentpet.com/img/no-image2.png',
//                  fit: BoxFit.scaleDown,
//                  loadingBuilder: circularImageLoader
//              ),
//            ),

                      Padding(
                        padding: const EdgeInsets.only(top:8.0,left: 2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              widget.product.name[0].toUpperCase() +
                                  widget.product.name.substring(1),
                              style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 16,),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text("PKR ${widget.product.price}",style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 13,color: Colors.primaries[0]),),
                          ],
                        ),
                      ),

                    ],
                  ),
                  widget.product.quantity > 0 ? RaisedButton(
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
                        Scaffold.of(context).hideCurrentSnackBar();
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text(
                              "${widget.product.name} added successfuly!"),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(),
                        ));
                      }
                      LocalData.likeChanged();
                  }else{
                  CustomNavigator.navigateTo(context, ProductDetailPage(product: widget.product));
                  }
                    },
                    padding: EdgeInsets.all(10),
                  ): Padding(
                    padding: EdgeInsets.all(20),
                    child: Text("Out of stock",style: TextStyle(color: Colors.primaries[0],fontSize: 15),),
                  ),
                ],
              ),
         onTap: () =>CustomNavigator.navigateTo(context, ProductDetailPage(product: widget.product)),
    ),
          ),
        ),
      ),
    );
  }
}
