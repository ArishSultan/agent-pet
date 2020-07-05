import 'package:agent_pet/src/models/_model.dart';

class Attributes extends Model {
  int weight;
  int quantity;
  int productId;
  String price;
  String createdAt;
  String updatedAt;

  Attributes({
    int id,
    this.quantity,
    this.price,
    this.weight,
    this.productId,
    this.createdAt,
    this.updatedAt
  }): super(id);

  Map<String, dynamic> toJson() => {
    "id": this.id,
    "weight" : this.weight,
    "quantity" : this.quantity,
    "productId" : this.productId,
    "price" : this.price,
  };

  Attributes.fromJson(Map<String, dynamic> json): this(
    id: json['id'],
    price: json['price'],

    weight: Model.resolveInt(json['weight']),
    quantity: Model.resolveInt(json['quantity']),
    productId: Model.resolveInt(json['product_id']),

    createdAt: json['created_at'],
    updatedAt: json['updated_at'],
  );
}
