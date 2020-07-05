import 'package:agent_pet/src/models/_model.dart';

class Address extends Model {
  int id;
  String address;
  String zip;
  String city;
  int countryId;
  String status;
  String phone;
  String name;
  String email;
  String createdAt;
  String updatedAt;

  Address(
      {this.id,
        this.address,
        this.zip,
        this.city,
        this.countryId,
        this.status,
        this.phone,
        this.name,
        this.email,
        this.createdAt,
        this.updatedAt}):super(id);

  Address.fromJson(Map<String, dynamic> json):this(
    id : json['id'],
    address : json['address'],
    zip : json['zip'],
    city : json['city'],
    countryId : json['country_id'],
    status : json['status'],
    phone : json['phone'],
    name : json['name'],
    email : json['email'],
    createdAt : json['created_at'],
    updatedAt : json['updated_at'],
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['address'] = this.address;
    data['zip'] = this.zip;
    data['city'] = this.city;
    data['country_id'] = this.countryId;
    data['status'] = this.status;
    data['phone'] = this.phone;
    data['name'] = this.name;
    data['email'] = this.email;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}