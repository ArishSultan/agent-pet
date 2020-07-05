import 'package:agent_pet/src/models/pet-detail.dart';
import 'package:agent_pet/src/services/_service.dart';

class PetDetailService extends Service<PetDetail>{
  @override
  PetDetail parse(Map<String, dynamic> item) {
    return PetDetail.fromJson(item);
  }

  Future<List<PetDetail>> getPetDetail(int id) {
    return this.getAll('pet-detail/$id');
  }

}