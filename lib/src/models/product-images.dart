import 'package:agent_pet/src/models/_model.dart';

///
/// 
class ProductImage extends Model {
  ///
  /// 
  final String src;
  
  ///
  /// 
  final int productId;

  ProductImage({
    int id,
    this.src,
    this.productId
  }): super(id);

  ProductImage.fromJson(Map<String, dynamic> json): this(
    id: json['id'],
    src: json['src'],
    productId: int.parse(json['product_id'].toString()),
  );

  Map<String, dynamic> toJson() => {
    'id': this.id,
    'src': this.src,
    'product_id': this.productId,
  };
}