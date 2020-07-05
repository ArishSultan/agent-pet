
import 'package:agent_pet/src/models/_model.dart';

class Type extends Model{
  int id;
  String name;
  String slug;
  String image;
  int status;
  int parentId;
  String createdAt;
  String updatedAt;

  Type(
      {this.id,
        this.name,
        this.slug,
        this.image,
        this.status,
        this.parentId,
        this.createdAt,
        this.updatedAt}) : super(id);

  Type.fromJson(Map<String, dynamic> json) : this (
    id : json['id'],
    name : json['name'],
    slug : json['slug'],
    image : json['image'],
    status : int.parse(json['status'].toString()),
    parentId : int.parse(json['parent_id'].toString()),
    createdAt : json['created_at'],
    updatedAt : json['updated_at'],
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['image'] = this.image;
    data['status'] = this.status;
    data['parent_id'] = this.parentId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
