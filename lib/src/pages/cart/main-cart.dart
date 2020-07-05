import 'package:agent_pet/src/pages/cart/cart-data.dart';
import 'package:agent_pet/src/utils/local-data.dart';
import 'package:agent_pet/src/widgets/chevron-clipper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'checkout-tab.dart';
import 'order-complete-tab.dart';
import 'shopping-cart-tab.dart';


class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage>
    with SingleTickerProviderStateMixin {

  int _index = 0;
  TabController _tabController;

  @override
  void initState() {
    super.initState();

    isDisabledCart = [false,true,false];


    this._tabController = TabController(
        length: 3,
        vsync: this
    );

    _tabController.addListener((){

      if (isDisabledCart[_tabController.index]) {
        int index = _tabController.previousIndex;
        setState(() {
          _tabController.index = index;
        });
      }

      setState(() {
        _index = _tabController.index;
      });

      if(_tabController.indexIsChanging)
      {
        FocusScope.of(context).unfocus();
      }

    });
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: ()async {
        if(_tabController.index>0 && _tabController.index!=2){
          _tabController.animateTo(_tabController.index-1);
          return false;
        }
        return true;
      },
      child: InheritedCart(
        child: Scaffold(
            appBar: AppBar(
                leading: IconButton(
                  onPressed: () async {
                    if(_tabController.index>0 && _tabController.index!=2){
                      _tabController.animateTo(_tabController.index-1);
                      return false;
                    }
                    Navigator.of(context).pop();
                    return true;
                  },
                  icon: Icon(Icons.keyboard_backspace,color: Colors.black,),
                ),
                backgroundColor: Colors.white,
                title: Text("Cart", style: TextStyle(color: Colors.black)),
                actions: <Widget>[
//                IconButton(
//                  icon: Icon(Icons.clear,color: Colors.black),
//                  onPressed: (){
//                    LocalData.clearCart();
//                  },
//                )
                ],
                bottom: PreferredSize(
                  child: Container(
                    constraints: BoxConstraints.tightFor(width: 800,height: 60),
                    color: Colors.white,
                    child: TabBar(
                      labelPadding: EdgeInsets.all(0),
                        unselectedLabelColor: Colors.black,
                        controller: this._tabController,
                        indicatorPadding: EdgeInsets.all(0),
                        tabs: <Widget>[
                          Chevron(
                            triangleHeight: 20,
                            child: Container(
                              color: _index == 0 ? Colors.primaries[0] : Colors.grey.shade200,
                              child: Center(child: Text("   Shopping Cart")),
                            ),
                          ),
                          Chevron(
                            triangleHeight: 20,
                            child: Container(
                              color:  _index == 1 ? Colors.primaries[0] : Colors.grey.shade200,
                              child: Center(child: Text("   Checkout")),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right:8.0),
                            child: Chevron(
                              triangleHeight: 20,
                              child: Container(
                                color:  _index == 2 ? Colors.primaries[0] : Colors.grey.shade200,
                                child: Center(child: Text("       Order Completed",textAlign: TextAlign.center,),),
                              ),
                            ),
                          ),
//                          Tab(child: Text("Shopping Cart")),
//                          Tab(child: Text("Checkout")),
//                          Tab(child: Text("Order Completed")),
                        ]
                    ),
                  ),
                  preferredSize: Size.fromHeight(50),
                )
            ),
            body: TabBarView(
              controller: this._tabController,
              children: <Widget>[
                ShoppingCart(next: this._next),
                Checkout(controller: this._tabController),
                OrderComplete()
              ],
              physics: NeverScrollableScrollPhysics(),
            )
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    this._tabController.dispose();
  }

  void _next() {
    this._tabController.animateTo(this._tabController.index + 1);
  }
}
