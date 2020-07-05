import 'package:agent_pet/src/models/_model.dart';
import 'package:agent_pet/src/models/product-attributes.dart';
import 'package:agent_pet/src/models/product.dart';

class OrderItem extends Model {
  int qty = 0;
  final Product product;
  final Attributes selectedAttribute;

  OrderItem({
    int id,
    this.qty,
    this.product,
    this.selectedAttribute
  }): super(id);

  Map<String, dynamic> toJson() => {
    "id": 0,
    "qty": this.qty,
    "product": this.product.toJson(),
    "selectedAttributes": this.selectedAttribute?.toJson()
  };

  factory OrderItem.fromJson(Map<String, dynamic> json) {

   try{
  return OrderItem(id: 0,
  qty: json["qty"],
  product: Product.fromJson(json["product"]),
  selectedAttribute: json["selectedAttributes"]!=null ? Attributes.fromJson(json["selectedAttributes"]) : null
  );
  } catch(e){
     throw e;
  }
  }

  @override
  bool operator ==(other) {
    return this.id == other.id;
  }
}