import 'package:agent_pet/src/models/order-item.dart';
import 'package:agent_pet/src/pages/cart/cart-data.dart';
import 'package:agent_pet/src/services/_service.dart';
import 'package:agent_pet/src/utils/local-data.dart';
import 'package:agent_pet/src/widgets/dialogs/loading-dialog.dart';
import 'package:agent_pet/src/widgets/dialogs/message-dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Checkout extends StatefulWidget {
  final TabController controller;
  Checkout({this.controller});
  @override
  State<StatefulWidget> createState() {
    return CartState();
  }
}

class CartState extends State<Checkout> with AutomaticKeepAliveClientMixin{
  TextEditingController _name = TextEditingController();
  TextEditingController _city = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _postalCode = TextEditingController();
  TextEditingController _additionalInfo = TextEditingController();
  String referenceId;
  List<OrderItem> _products;
  var _checkoutKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  int _prods = 0;
  double _total = 0;
  String groupValue = "Standard Shipping";
  int shippingPrice = 0;
  int standardShipping;
  int fastShipping;
  bool freeShipping = false;
  bool checkBoxVal = false;
  String orderDate;
  double _subtotal = 0;

  @override
  void initState() {
    super.initState();
    this._prods = LocalData.getCart().length;
    this._products = LocalData.getCart();
    getShippingCosts();


    if(LocalData.isSignedIn && LocalData.user.userForShip==1){
      _name.text = LocalData.user.name;
      _phone.text = LocalData.user.phone;
      _postalCode.text = LocalData.user.zipCode;
      _email.text = LocalData.user.email;
      _city.text = LocalData.user.city;
      _address.text = LocalData.user.address;
    }
  }

  void getShippingCosts() async {
    var _cart = FormData.fromMap({
      "cart": _products.map((product) => product.toJson()).toList()
    });

    var _shippingCostResponse = await Service.postSimple('get-shipping-cost', _cart);
    print(_shippingCostResponse);
    setState(() {
      standardShipping = _shippingCostResponse.data['normal_shipping_cost'];
      fastShipping = _shippingCostResponse.data['fast_shipping_cost'];
      freeShipping = _shippingCostResponse.data['free_shipping'];
      shippingPrice = freeShipping ? 0 : standardShipping;
    });

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
      sum+= shippingPrice;
      return sum.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    var _cartData = InheritedCart.of(context);
    _cartData.total = _total.toString();
    _cartData.shippingMethod = groupValue;
    _cartData.referenceId = referenceId;
    _cartData.tax = shippingPrice;
    _cartData.orderDate = orderDate;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Form(
          autovalidate: _autoValidate,
          key: _checkoutKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Shipping Information", style: TextStyle(fontSize: 18)),

              SizedBox(height: 15),
              _buildTextField(context, _name, 'Name*'),
              SizedBox(height: 15),

              Row(children: <Widget>[
                Flexible(child: _buildTextField(context, _phone, 'Phone*')),
                SizedBox(width: 15),
                Flexible(child: _buildTextField(context, _postalCode, 'Postal/Zip Code')),
              ]),

              SizedBox(height: 15),

              Row(children: <Widget>[
                Flexible(child: _buildTextField(context, _email, 'Email*')),
                SizedBox(width: 15),
                Flexible(child: _buildTextField(context, _city, 'City*')),
              ]),

              SizedBox(height: 15),
              _buildTextField(context, _address, 'Address*'),
              SizedBox(height: 15),
              _buildTextField(context, _additionalInfo, 'Additional Information'),
              SizedBox(height: 15),
              Text("Summary", style: TextStyle(fontSize: 15)),
              SizedBox(height: 10),

              Row(children: <Widget>[
                Text("Subtotal (${this._prods} Items)", style: TextStyle(fontSize: 12)),
                Text("PKR ${_getTotal()}", style: TextStyle(fontSize: 12))
              ], mainAxisAlignment: MainAxisAlignment.spaceBetween),

              Divider(color: Colors.grey),


             freeShipping ? RadioListTile(
                  dense: true,
                  selected: true,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text("Free Shipping"),
                  activeColor: Colors.primaries[0],
                  onChanged: (v){

                  },
              )
             :  Column(
                children: <Widget>[
                  RadioListTile(
                      dense: true,
                      selected: groupValue == 'Standard Shipping',
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Standard Shipping"),
                         standardShipping!=null ? Text("PKR " + standardShipping.toString(),style: TextStyle(fontWeight: FontWeight.bold),): SizedBox()
                        ],
                      ),
                      value: 'Standard Shipping',
                      activeColor: Colors.primaries[0],
                      groupValue: groupValue,
                      onChanged: (value) {
                        setState(() {
                          this.groupValue = 'Standard Shipping';
                          shippingPrice = standardShipping;
                        });
                      }
                  ),
                  RadioListTile(
                      dense: true,
                      selected: groupValue == 'Fast Shipping',
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Fast Shipping"),
                       fastShipping!=null ?   Text("PKR " +fastShipping?.toString(),style: TextStyle(fontWeight: FontWeight.bold),) : SizedBox(),
                        ],
                      ),
                      value: 'Fast Shipping',
                      activeColor: Colors.primaries[0],

                      groupValue: groupValue,
                      onChanged: (value) {
                        setState(() {
                          this.groupValue = 'Fast Shipping';
                          shippingPrice = fastShipping;
                        });
                      }
                  ),
                ],
              ),

              SizedBox(height: 8),

              Row(children: <Widget>[
                Text("Total", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                Text("PKR ${_getTotal(false)}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800))
              ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
              SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Payment Method:", style: TextStyle(fontSize: 15)),
                  Text("Cash On Delivery", style: TextStyle(fontSize: 15)),
                ],
              ),

              Row(children: <Widget>[
                Checkbox(
                  value: checkBoxVal,
                  activeColor: Colors.primaries[0],
                  onChanged: (bool value) {
                    setState(() => checkBoxVal = value);
                  },
                ),
                GestureDetector(
                  child: Text(
                    "Yes, I agree to Terms & Conditions",
                    style: TextStyle(fontSize: 12),
                  ),
                  onTap: (){
                    setState(() => checkBoxVal = !checkBoxVal);
                  },
                )
              ]),
              SizedBox(height: 6),

              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: RaisedButton(
                  color: Colors.primaries[0],
                  child: Text(
                    "Place Order",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: !this.checkBoxVal ? null: () async {
                    FormData data;


                    if(_checkoutKey.currentState.validate()){
                      FocusScope.of(context).unfocus();
                      if (LocalData.isSignedIn) {
                        data = FormData.fromMap({
                          "register": false,
                          "user_id": LocalData.user.id,
                          "email": _email.text,
                          "name": _name.text,
                          "phone": _phone.text,
                          "payment": "manual",
                          "zip": _postalCode.text,
                          "city": _city.text,
                          "country_id" : 162,
                          "status": 1,
                          "address": _address.text,
                          "shipping_method": groupValue,
                          "shipping_cost": shippingPrice,
                          "total_products": _getTotal(),
                          "total": _getTotal(false),
                          "additional_info": _additionalInfo.text
                        });
                      } else {
                        data = FormData.fromMap({
                          "city": _city.text,
                          "register": true,
                          "email": _email.text,
                          "name": _name.text,
                          "payment": "manual",
                          "phone": _phone.text,
                          "zip": _postalCode.text,
                          "status": 1,
                          "city": _city.text,
                          "address": _address.text,
                          "country_id" : 162,
                          "shipping_method": groupValue,
                          "shipping_cost": shippingPrice,
                          "payment": 'manual',
                          "total_products": _getTotal(),
                          "total": _getTotal(false),
                          "additional_info": _additionalInfo.text
                        });
                      }

                      openLoadingDialog(context, 'Placing your order...');

                      var _checkoutResponse = await Service.postSimple('checkout', data);
                      print(_checkoutResponse);
                      if(_checkoutResponse.toString() == 'User Exists'){
                        Navigator.of(context).pop();
                        openMessageDialog(context, 'A user exists with email you entered.Please generate order after logging in.');
                      }else{
                        referenceId = _checkoutResponse.data['order']['reference'];
                        orderDate = _checkoutResponse.data['order']['created_at'];

                        print(referenceId);

                        final orderItems = <Map<String, dynamic>>[];

                        LocalData.getCart().forEach((element) {
                          orderItems.add({
                            "order_id": referenceId,
                            "product_id": element.product.id,
                            "quantity": element.qty,
                            "product_name": element.product.name,
                            "product_sku": element.product.sku,
                            "product_description": element.product.description,
                            "product_price": element.product.price,
                            "attribute_value_id": element.selectedAttribute?.id ?? 0
                          });
                        });

                        print(orderItems);

                        var _orderResponse =  await Service.postSimple('add-product-to-order', { "items": orderItems });
                        Navigator.of(context).pop();
                        widget.controller.animateTo(widget.controller.index++);
                      }



                    }else{
                      setState(() {
                        _autoValidate=true;
                      });
                    }
                    },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  TextFormField _buildTextField(context, controller,String label) {
    return TextFormField(
      inputFormatters: label == 'Phone*'? [WhitelistingTextInputFormatter.digitsOnly]: null,

      validator: (value) {
        if(label == 'Postal/Zip Code' || label == 'Additional Information') return null;
        if(value.isEmpty) return 'Please enter $label';
        if(label == 'Email*' && !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value))
          return 'Please provide a valid email';
        return null;
      },

      controller: controller,
      keyboardType: label == 'Email*'? TextInputType.emailAddress: (label == 'Phone*' ? TextInputType.phone :(label == 'Postal/Zip Code'? TextInputType.phone: TextInputType.text)),
      decoration: InputDecoration(
        isDense: true,
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => false;


}




