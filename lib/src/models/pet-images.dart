import 'package:agent_pet/src/models/_model.dart';

class PetImages extends Model {
  int id;
  int petId;
  String src;
  String createdAt;
  String updatedAt;

  PetImages({this.id, this.petId, this.src, this.createdAt, this.updatedAt}) : super(id);

  PetImages.fromJson(Map<String, dynamic> json) :this (
    id : json['id'],
    petId: int.parse(json['pet_id'].toString()),
    src : json['src'],
    createdAt : json['created_at'],
    updatedAt :json['updated_at'],
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['pet_id'] = this.petId;
    data['src'] = this.src;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}