import 'package:agent_pet/src/models/order.dart';
import 'package:agent_pet/src/services/order-service.dart';
import 'package:agent_pet/src/utils/date-formatter.dart';
import 'package:agent_pet/src/utils/local-data.dart';
import 'package:agent_pet/src/utils/local-data.dart';
import 'package:agent_pet/src/widgets/appBar.dart';
import 'file:///D:/Workspace/Tools/Flutter/agent_pet/lib/src/ui/views/drawer_view.dart';
import 'package:agent_pet/src/utils/simple-future-builder.dart';
import 'package:flutter/material.dart';

class MyOrders extends StatefulWidget {

  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  Future<List<Order>> orders;
  var _service = OrderService();
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    orders = _service.fetchUserOrders(LocalData.user.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AgentPetAppbar(context,'My Orders'),
      body: RefreshIndicator(
          key: refreshKey,
          color: Colors.primaries[0],
          onRefresh: () async {
            orders = _service.fetchUserOrders(LocalData.user.id);
            await orders;
            setState(() {});
          },
          child:
          SimpleFutureBuilder<List<Order>>.simpler(
              context: context,
              future: orders,
              builder: (AsyncSnapshot<List<Order>> snapshot) {
                return snapshot.data.isNotEmpty ? ListView.builder(itemBuilder:(context, i) {
                  var order = snapshot.data[i];
                  return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(children: <Widget>[

                          Text("Reference # ${order.reference}",style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                          Text("Order Date: ${getFormattedDate(order.updatedAt)} ${
                              ((DateTime date) =>
                              "${date.hour % 12 + 1}:${date.minute} ${date.hour > 12
                                  ? 'PM'
                                  : 'AM'}")(
                                  DateTime.parse(order.updatedAt))
                          }",style: TextStyle(fontSize: 14, )),
                          SizedBox(height: 6,),
                          Table(children: <TableRow>[
                            TableRow(children: <Widget>[
                              Text("Items", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                              Text("Unit Price", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))
                            ]),
                            TableRow(children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child:  Text("${order.productName} x ${order.quantity}"),
                              ),
                              Row(children: <Widget>[
                                Text("PKR", style: TextStyle(fontSize: 11)),
                                SizedBox(width: 5),
                                Text(order.productPrice, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))
                              ], crossAxisAlignment: CrossAxisAlignment.end)
                            ]),


                          ], columnWidths: {
                            0: FractionColumnWidth(.75)
                          }),

                          Divider(),
                          SizedBox(height: 12,),

                          Table(children: <TableRow>[
                            TableRow(children: <Widget>[
                              Text("Subtotal"),
                              Row(children: <Widget>[
                                Text("PKR", style: TextStyle(fontSize: 11)),
                                SizedBox(width: 5),
                                Text(order.productPrice, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))
                              ], crossAxisAlignment: CrossAxisAlignment.end)
                            ]),
                            TableRow(children: <Widget>[
                              Text("Shipping & Sales Tax"),
                              Row(children: <Widget>[
                                Text("PKR", style: TextStyle(fontSize: 11)),
                                SizedBox(width: 5),
                                Text(order.shippingCost.toString(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))
                              ], crossAxisAlignment: CrossAxisAlignment.end)
                            ]),

                            TableRow(children: <Widget>[
                              Text("Shipping Method"),
                              Column(
                                children: <Widget>[
                                  Text(order.shippingMethod),
                                  SizedBox(height: 15,)
                                ],
                              ),

                            ]),


                            TableRow(children: <Widget>[
                              Text("Total", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                              Row(children: <Widget>[
                                Text("PKR", style: TextStyle(fontSize: 11)),
                                SizedBox(width: 5),
                                Expanded(child: Text(order.total, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)))
                              ], crossAxisAlignment: CrossAxisAlignment.end)
                            ]),
                          ], columnWidths: {
                            0: FractionColumnWidth(.75)
                          })
                        ]),
                      )
                  );
                },
                  itemCount: snapshot.data.length,
                ): Center(child: Text("You haven't generated any orders!"),);
              }
          )
      ),
    );
  }
}
