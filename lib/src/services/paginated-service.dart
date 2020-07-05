import 'package:agent_pet/src/models/paginated-pet.dart';
import 'package:agent_pet/src/services/_service.dart';

class PaginatedPetService extends Service<PaginatedPet> {
  @override
  PaginatedPet parse(Map<String, dynamic> item) {
    return PaginatedPet.fromJson(item);
  }

  Future<List<PaginatedPet>> getPetsByType(int typeId,String orderBy,[int pageNo=1]) {
    return this.getAll('pets/$typeId?page=$pageNo&order_by=$orderBy');
  }

  Future<List<PaginatedPet>> getAllPets(String orderBy,[int pageNo=1]) {
    return this.getAll('pets?page=$pageNo&order_by=$orderBy');
  }

  Future<List<PaginatedPet>> getPetsForAdoption(String orderBy,[int pageNo=1]) {
    return this.getAll('pets-for-engage?page=$pageNo&order_by=$orderBy');
  }

  Future<List<PaginatedPet>> getPetsByQuery(String query,String orderBy,[int pageNo=1]) {
    return this.getAll('$query&page=$pageNo&order_by=$orderBy');
  }

  Future<List<PaginatedPet>> getAllFeaturedPets(String orderBy,[int pageNo=1]) {
    return this.getAll('all-featured-pets?page=$pageNo&order_by=$orderBy');
  }

  Future<List<PaginatedPet>> searchPetByKeyword(String keyword,String orderBy,[int pageNo=1]) {
    return this.getAll('pet-list?page=$pageNo&search_term=$keyword&order_by=$orderBy');
  }

  Future<List<PaginatedPet>> petsByUser(int userId,String orderBy,[int pageNo=1]) {
    return this.getAll('pets-by-user/$userId?page=$pageNo&order_by=$orderBy');
  }

}