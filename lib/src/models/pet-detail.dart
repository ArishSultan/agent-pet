import 'package:agent_pet/src/models/_model.dart';
import 'package:agent_pet/src/models/pet.dart';

class PetDetail extends Model {
  Pet pet;
//  Comments comments;
//  List<String> shopCities;
//  int viewMap;
//  List<Pet> similarPets;
//  List<Pet> savedPets;

  PetDetail(
      {
        this.pet,
//        this.comments,
//        this.shopCities,
//        this.viewMap,
//        this.similarPets,
//        this.savedPets
      }) : super(0);

  PetDetail.fromJson(Map<String, dynamic> json) : this(
    pet : json != null ? new Pet.fromJson(json) : null,
//    comments : json['comments'] != null
//        ? new Comments.fromJson(json['comments'])
//        : null,
//    shopCities : json['shop_cities']?.cast<String>(),
//    viewMap : json['viewMap'],
//    similarPets:  (json['images'] as List)
//        ?.map((i) => Pet.fromJson(i))
//        ?.toList(),
//    savedPets: (json['images'] as List)
//        ?.map((i) => Pet.fromJson(i))
//        ?.toList(),

  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pet != null) {
      data['pet'] = this.pet.toJson();
    }
//    if (this.comments != null) {
//      data['comments'] = this.comments.toJson();
//    }
//    data['shop_cities'] = this.shopCities;
//    data['viewMap'] = this.viewMap;
//    if (this.similarPets != null) {
//      data['similar_pets'] = this.similarPets.map((v) => v.toJson()).toList();
//    }
//    if (this.savedPets != null) {
//      data['saved_pets'] = this.savedPets.map((v) => v.toJson()).toList();
//    }
    return data;
  }
}