
import 'package:agent_pet/src/models/order-item.dart';
import 'package:agent_pet/src/utils/date-formatter.dart';
import 'package:agent_pet/src/utils/local-data.dart';
import 'package:flutter/material.dart';

import 'cart-data.dart';

class OrderComplete extends StatefulWidget {
  @override
  _OrderCompleteState createState() => _OrderCompleteState();
}

class _OrderCompleteState extends State<OrderComplete> with AutomaticKeepAliveClientMixin{

  String referenceId;
  String total;
  String date;
  int tax;
  String shippingMethod;

  List<OrderItem> _products;

  @override
  void initState() {
    isDisabledCart= [true,true,false];
    super.initState();
    _products = LocalData.getCart();
    LocalData.clearCart();
  }

  @override
  Widget build(BuildContext context) {
    var orderData = InheritedCart.of(context);
    referenceId = orderData.referenceId;
    tax = orderData.tax;
    shippingMethod = orderData.shippingMethod;
    date = orderData.orderDate;


    return ListView(children: <Widget>[

      Padding(
        padding: const EdgeInsets.all(10),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text("Thank you. Your order has been placed.", style: TextStyle(color: Colors.green)),
              ),

              Table(children: [
                TableRow(children: [
                  Text("Order Number:"),
                  Text(referenceId, style: TextStyle(fontWeight: FontWeight.bold)),
                ]),

                TableRow(children: [
                  Text("Date:"),
                  Text(getFormattedDate(date), style: TextStyle(fontWeight: FontWeight.bold)),
                ]),

                TableRow(children: [
                  Text("Total:"),
                  Text(_getTotal(false,tax.toString()), style: TextStyle(fontWeight: FontWeight.bold)),
                ]),

                TableRow(children: [
                  Text("Payment Methods"),
                  Text("Cash on Delivery", style: TextStyle(fontWeight: FontWeight.bold)),
                ])
              ])
            ], crossAxisAlignment: CrossAxisAlignment.start),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(children: <Widget>[

                    Table(children: <TableRow>[
                      TableRow(children: <Widget>[
                        Text("Items", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),

                        Text("Unit Price", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))
                      ]),
                    ], columnWidths: {
                    0: FractionColumnWidth(.75)
                    }),
                     ListView.builder(itemCount: _products.length,
                        shrinkWrap: true,
                        itemBuilder: (context,i){
                          return Table(children: <TableRow>[

                            TableRow(children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Text(_products[i].product.name),
                              ),
                              Row(children: <Widget>[
                                Text("PKR", style: TextStyle(fontSize: 11)),
                                SizedBox(width: 5),
                                _products[i].selectedAttribute!=null ?  Text("${_products[i].selectedAttribute.price}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)):
                                Text("${_products[i].product.price}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))
                              ], crossAxisAlignment: CrossAxisAlignment.end)
                            ]),


                          ], columnWidths: {
                            0: FractionColumnWidth(.75)
                          });
                        },
                    ),



                    Divider(),

                    Table(children: <TableRow>[
                      TableRow(children: <Widget>[
                        Text("Subtotal"),
                        Row(children: <Widget>[
                          Text("PKR", style: TextStyle(fontSize: 11)),
                          SizedBox(width: 5),
                          Text(_getTotal(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))
                        ], crossAxisAlignment: CrossAxisAlignment.end)
                      ]),
                      TableRow(children: <Widget>[
                        Text("Shipping & Sales Tax"),
                        Row(children: <Widget>[
                          Text("PKR", style: TextStyle(fontSize: 11)),
                          SizedBox(width: 5),
                          Text(tax.toString(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))
                        ], crossAxisAlignment: CrossAxisAlignment.end)
                      ]),

                      TableRow(children: <Widget>[
                        Text("Shipping Method"),
                        Text(shippingMethod) ,
                      ]),

                      TableRow(children: <Widget>[
                        Text(""),
                        Text("")
                      ]),

                      TableRow(children: <Widget>[
                        Text(""),
                        Text("")
                      ]),

                      TableRow(children: <Widget>[
                        Text("Total", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                        Row(children: <Widget>[
                          Text("PKR", style: TextStyle(fontSize: 11)),
                          SizedBox(width: 5),
                          Text(_getTotal(false,tax.toString()), style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold))
                        ], crossAxisAlignment: CrossAxisAlignment.end)
                      ]),
                    ], columnWidths: {
                      0: FractionColumnWidth(.75)
                    })
                  ]),
                )
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 50,right: 10),
            child: Container(
              width: 130,
              child: FlatButton(
                child: Text("Back to Store", style: TextStyle(color: Colors.white)),
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),

        ],);
  }

  _getTotal([bool subtotal=true,String tax]) {
    var sum = 0.0;

    _products.forEach((prod) {
      if (prod.selectedAttribute != null) {
        sum += prod.qty * double.parse(prod.selectedAttribute.price);
      } else {
        sum += prod.qty * double.parse(prod.product.price);
      }
    });
    if(subtotal){
      return sum.toString();
    }else{
       sum+= double.parse(tax);
       return sum.toString();
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

}