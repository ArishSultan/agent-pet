import 'package:agent_pet/src/models/brand.dart';

import '_service.dart';

class BrandsService extends Service<Brand> {
  @override
  Brand parse(Map<String, dynamic> item) => Brand.fromJson(item);
}