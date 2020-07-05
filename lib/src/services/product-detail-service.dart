import 'package:agent_pet/src/models/product-detail.dart';
import 'package:agent_pet/src/services/_service.dart';

class ProductDetailService extends Service<ProductDetail> {
  @override
  ProductDetail parse(Map<String, dynamic> item) {
    return ProductDetail.fromJson(item);
  }

  Future<List<ProductDetail>> getProductDetail(String slug) {
    return this.getAll('product-detail/$slug');
  }

}