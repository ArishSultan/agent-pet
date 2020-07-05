
import 'package:agent_pet/src/models/country.dart';

import '_service.dart';

class CountryService extends Service<Country> {
  @override
  Country parse(Map<String, dynamic> item) => Country.fromJson(item);
}