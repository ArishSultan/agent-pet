import 'package:agent_pet/src/models/pet-type.dart';
import 'package:agent_pet/src/services/_service.dart';

class PetTypeService extends Service<PetType> {
  @override
  PetType parse(Map<String, dynamic> item) {
    return PetType.fromJson(item);
  }


  Future<List<PetType>> getPopularPets() {
    return this.getAll('popular-pets');
  }
}