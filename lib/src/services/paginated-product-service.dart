import 'package:agent_pet/src/models/paginated-product.dart';
import 'package:agent_pet/src/services/_service.dart';

class PaginatedProductService extends Service<PaginatedProduct> {
  @override
  PaginatedProduct parse(Map<String, dynamic> item) {
    return PaginatedProduct.fromJson(item);
  }

  Future<List<PaginatedProduct>> getProducts({int pageNo=1,String keyword='',String category='',int type,String featured='',int brandId,String popular='',String flash='',String orderBy='',String priceRange}) {
    category = category ?? '';
    var typeId = type ?? '';
//    print('search-products?page=$pageNo&search_term=$keyword&category=$category&type=$type&featured=$featured&$priceRange&brand=$brandId&popular=$popular&flash=$flash&order_by=$orderBy');
    return this.getAll('search-products?page=$pageNo&search_term=$keyword&category=$category&type=$typeId&featured=$featured&$priceRange&brand=$brandId&popular=$popular&flash=$flash&order_by=$orderBy');
  }

}