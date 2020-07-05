import 'package:agent_pet/src/models/_model.dart';

/// This model is used to represent the [user] object
/// that is sent to server for authentication purposes.
class User extends Model {
  String name;
  String phone;
  String email;
  String password;
  DateTime dateOfBirth;
  String gender;
  String photo;
  String provider;
  String providerId;
  int countryId;
  String city;
  String zipCode;
  String address;
  int userForShip;
  int sendUpdates;

  User({
    int id,
    this.name = '',
    this.phone = '',
    this.email,
    this.password,
    this.gender,
    this.city,
    this.address,
    this.photo,
    this.countryId,
    this.dateOfBirth,
    this.provider,
    this.providerId,
    this.userForShip,
    this.zipCode,
    this.sendUpdates
  }) : super(id);

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] != null? json['id']: 0,
      name: json['name'] != null? json['name']: '',
      phone: json['phone'] != null? json['phone']: '',
        photo: json['photo'] != null? json['photo']: '',
      email: json['email'] != null? json['email']: '',
      address: json['address'] != null? json['address']: '',
      gender: json['gender'] != null? json['gender']: '',
      city: json['city'] != null? json['city']: '',
      countryId: json['country_id'] != null? int.parse(json['country_id'].toString()): 0,
      zipCode: json['zip_code'] != null? json['zip_code']: '',
      userForShip: json['use_for_ship'] != null? int.parse(json['use_for_ship'].toString()): 0,
      sendUpdates: json['send_updates'] != null? int.parse(json['send_updates'].toString()): 0,
      dateOfBirth: json['d_o_b'] != null ? DateTime.parse(json['d_o_b']): DateTime.now()
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['photo'] = this.photo;
    data['city'] = this.city;
    data['country_id'] = this.countryId;
    data['zip_code'] = this.zipCode;
    data['address'] = this.address;
    data['gender'] = this.gender;
    data['use_for_ship'] = this.userForShip;
    data['send_updates'] = this.sendUpdates;
    data['d_o_b'] = dateOfBirth!=null ? this.dateOfBirth.toIso8601String() : '';
    return data;
  }

}