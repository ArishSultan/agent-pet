import 'package:agent_pet/src/models/pet.dart';
import 'package:agent_pet/src/services/_service.dart';

class PetService extends Service<Pet> {
  @override
  Pet parse(Map<String, dynamic> item) {
    return Pet.fromJson(item);
  }


  Future<List<Pet>> getFeaturedPets() {
    return this.getAll('featured-pets');
  }


  Future<List<Pet>> getOfflinePets(String array) {
    return this.getAll('offline-pets$array');
  }

  Future<List<Pet>> getNewlyAddedPets() {
    return this.getAll('new-pets');
  }

  Future<List<Pet>> getPetsForEngage(String orderBy) {
    return this.getAll('pets-for-engage?order_by=$orderBy');
  }

  Future<List<Pet>> getPetTypes() {
    return this.getAll('pet-types');
  }

  Future<List<Pet>> getPetBreeds(int id) {
    return this.getAll('pet-types/$id');
  }

  Future<List<Pet>> getUserPets(int id) {
    return this.getAll('user-pets/$id');
  }

  Future<List<Pet>> getSimilarPets(int id,int typeId) {
    return this.getAll('similar-pets/$id/$typeId');
  }

}