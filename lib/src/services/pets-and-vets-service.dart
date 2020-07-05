import 'package:agent_pet/src/models/pets-and-vets-shops.dart';
import 'package:agent_pet/src/services/_service.dart';

class PetsAndVetsService extends Service<PetsAndVetsShop> {
  @override
  PetsAndVetsShop parse(Map<String, dynamic> item) {
    return PetsAndVetsShop.fromJson(item);
  }

  Future<List<PetsAndVetsShop>> getPetAndVetShops([String query]) {
    return this.getAll('pets-and-vets$query');
  }

}