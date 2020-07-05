import 'package:agent_pet/src/models/_model.dart';

class Alert extends Model{
  int id;
  int typeId;
  String frequency;
  String email;
  String city;
  String createdAt;
  String updatedAt;
  String petName;

  Alert(
      {this.id,
        this.typeId,
        this.frequency,
        this.email,
        this.city,
        this.createdAt,
        this.updatedAt,this.petName}):super(id);

  Alert.fromJson(Map<String, dynamic> json) : this (
    id : json['id'],
    typeId : json['type_id'],
    frequency : json['frequency'],
    petName : json['pet_name'],
    email : json['email'],
    city : json['city'],
    createdAt : json['created_at'],
    updatedAt : json['updated_at'],
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type_id'] = this.typeId;
    data['frequency'] = this.frequency;
    data['email'] = this.email;
    data['pet_name'] = this.petName;
    data['city'] = this.city;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}