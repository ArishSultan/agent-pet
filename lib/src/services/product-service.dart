import 'package:agent_pet/src/models/product.dart';
import 'package:agent_pet/src/services/_service.dart';

class ProductService extends Service<Product>{
  @override
  Product parse(Map<String, dynamic> item) {
    return Product.fromJson(item);
  }

  Future<List<Product>> getOfflineProducts(String array) {
    return this.getAll('offline-products$array');
  }



}