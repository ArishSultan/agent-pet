import 'package:agent_pet/src/models/_model.dart';
import 'package:agent_pet/src/models/pet-images.dart';
import 'package:agent_pet/src/models/pet-type.dart';


class Pet extends Model{
  int typeId;
  int userId;
  String name;
  String description;
  String petFor;
  String primaryBreed;
  String gender;
  String color;
  String age;
  String group;
  String trainingLevel;
  String energyLevel;
  String groomingLevel;
  bool protective;
  bool playful;
  bool affectionate;
  bool gentle;
  bool okayWithKids;
  bool okayWithDogs;
  bool okayWithCats;
  bool okayWithAppartments;
  bool okayWithSeniors;
  bool hypoallergenic;
  bool houseTrained;
  bool declawed;
  bool specialDiet;
  bool likesToLap;
  bool specialNeeds;
  bool ongoingMedical;
  bool neutered;
  bool vaccinated;
  bool highRisk;
  bool featured;
  String status;
  String lat;
  String lng;
  String ownerName;
  String ownerCountry;
  String ownerCity;
  String ownerAddress;
  String ownerEmail;
  String ownerPhone;
  String approvedAt;
  String createdAt;
  String updatedAt;
  String slug;
  String price;
  String expiredAt;
  int remainingDays;
  List<PetImages> images;
  PetType type;

  Pet({
    int id,
    this.typeId,
    this.userId,
    this.name,
    this.description,
    this.petFor,
    this.primaryBreed,
    this.gender,
    this.color,
    this.age,
    this.group,
    this.trainingLevel,
    this.energyLevel,
    this.groomingLevel,
    this.protective,
    this.playful,
    this.affectionate,
    this.gentle,
    this.okayWithKids,
    this.okayWithDogs,
    this.okayWithCats,
    this.okayWithAppartments,
    this.okayWithSeniors,
    this.hypoallergenic,
    this.houseTrained,
    this.declawed,
    this.specialDiet,
    this.likesToLap,
    this.specialNeeds,
    this.ongoingMedical,
    this.neutered,
    this.vaccinated,
    this.highRisk,
    this.featured,
    this.status,
    this.lat,
    this.lng,
    this.ownerName,
    this.ownerCountry,
    this.ownerCity,
    this.ownerAddress,
    this.ownerEmail,
    this.ownerPhone,
    this.approvedAt,
    this.createdAt,
    this.updatedAt,
    this.slug,
    this.price,
    this.expiredAt,
    this.remainingDays,
    this.images,
    this.type
  }): super(id);


  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'],
      typeId: int.parse(json['type_id'].toString()),
      userId: int.parse(json['user_id'].toString()),
      name: json['name'],
      description: json['description'],
      petFor: json['pet_for'],
      primaryBreed: json['primary_breed'],
      gender: json['gender'],
      color: json['color'],
      age: (json['type_id'].toString()),
      group: json['group'],
      trainingLevel: json['training_level'],
      energyLevel: json['energy_level'],
      groomingLevel: json['grooming_level'],
      protective: int.parse(json['protective'].toString()) == 1,
      playful: int.parse(json['playful'].toString()) == 1,
      affectionate: int.parse(json['affectionate'].toString()) == 1,
      gentle: int.parse(json['gentle'].toString()) == 1,
      okayWithKids: int.parse(json['okay_with_kids'].toString()) == 1,
      okayWithDogs: int.parse(json['okay_with_dogs'].toString()) == 1,
      okayWithCats: int.parse(json['okay_with_cats'].toString()) == 1,
      okayWithAppartments: int.parse(
          json['okay_with_appartments'].toString()) == 1,
      okayWithSeniors: int.parse(json['okay_with_seniors'].toString()) == 1,
      hypoallergenic: int.parse(json['hypoallergenic'].toString()) == 1,
      houseTrained: int.parse(json['house_trained'].toString()) == 1,
      declawed: int.parse(json['declawed'].toString()) == 1,
      specialDiet: int.parse(json['special_diet'].toString()) == 1,
      likesToLap: int.parse(json['likes_to_lap'].toString()) == 1,
      specialNeeds: int.parse(json['special_needs'].toString()) == 1,
      ongoingMedical: int.parse(json['ongoing_medical'].toString()) == 1,
      neutered: int.parse(json['neutered'].toString()) == 1,
      vaccinated: int.parse(json['vaccinated'].toString()) == 1,
      highRisk: int.parse(json['high_risk'].toString()) == 1,
      featured: int.parse(json['featured'].toString()) == 1,
      status: json['status'],
      lat: json['lat'],
      lng: json['lng'],
      ownerName: json['owner_name'],
      ownerCountry: json['owner_country'],
      ownerCity: json['owner_city'],
      ownerAddress: json['owner_address'],
      ownerEmail: json['owner_email'],
      ownerPhone: json['owner_phone'],
      approvedAt: json['approved_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      slug: json['slug'],
      price: json['price'],
      expiredAt: json['expired_at'],
      remainingDays: int.parse(json['remaining_days'].toString()),
      images: (json['images'] as List)
          ?.map((i) => PetImages.fromJson(i))
          ?.toList(),
      type: json['type'] != null ? new PetType.fromJson(json['type']) : null,
    );
  }



  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type_id'] = this.typeId;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['pet_for'] = this.petFor;
    data['primary_breed'] = this.primaryBreed;
    data['gender'] = this.gender;
    data['color'] = this.color;
    data['age'] = this.age;
    data['group'] = this.group;
    data['training_level'] = this.trainingLevel;
    data['energy_level'] = this.energyLevel;
    data['grooming_level'] = this.groomingLevel;
    data['protective'] = this.protective? 1 : 0;
    data['playful'] = this.playful? 1 : 0;
    data['affectionate'] = this.affectionate? 1 : 0;
    data['gentle'] = this.gentle? 1 : 0;
    data['okay_with_kids'] = this.okayWithKids ? 1 : 0;
    data['okay_with_dogs'] = this.okayWithDogs ? 1 : 0;
    data['okay_with_cats'] = this.okayWithCats ? 1 : 0;
    data['okay_with_appartments'] = this.okayWithAppartments ? 1 : 0;
    data['okay_with_seniors'] = this.okayWithSeniors ? 1 : 0;
    data['hypoallergenic'] = this.hypoallergenic ? 1 : 0;
    data['house_trained'] = this.houseTrained ? 1 : 0;
    data['declawed'] = this.declawed ? 1 : 0;
    data['special_diet'] = this.specialDiet ? 1 : 0;
    data['likes_to_lap'] = this.likesToLap ? 1 : 0;
    data['special_needs'] = this.specialNeeds ? 1 : 0;
    data['ongoing_medical'] = this.ongoingMedical ? 1 : 0;
    data['neutered'] = this.neutered ? 1 : 0;
    data['vaccinated'] = this.vaccinated ? 1 : 0;
    data['high_risk'] = this.highRisk ? 1 : 0;
    data['featured'] = this.featured ? 1 : 0;
    data['status'] = this.status;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['owner_name'] = this.ownerName;
    data['owner_country'] = this.ownerCountry;
    data['owner_city'] = this.ownerCity;
    data['owner_address'] = this.ownerAddress;
    data['owner_email'] = this.ownerEmail;
    data['owner_phone'] = this.ownerPhone;
    data['approved_at'] = this.approvedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['slug'] = this.slug;
    data['price'] = this.price;
    data['expired_at'] = this.expiredAt;
    data['remaining_days'] = this.remainingDays;
    if (this.images != null) {
      data['images'] = this.images.map((v) => v.toJson()).toList();
    }
    if (this.type != null) {
      data['type'] = this.type.toJson();
    }
    return data;
  }
}


