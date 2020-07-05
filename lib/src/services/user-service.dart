import 'dart:convert';

import 'package:agent_pet/src/models/user.dart';
import 'package:agent_pet/src/services/_service.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class UserService extends Service<User> {
  @override
  User parse(Map<String, dynamic> item) {
    return User.fromJson(item);
  }

  Future<List<User>> fetchProfile(int id){
    return this.getAll('profile/$id');
  }

  Future<List<int>> getSavedPetsIds(int userId) async {
    Response res = await http.get('$apiUrl/api/saved-pets-ids/$userId');
    return (jsonDecode(res.body) as List).map((item) => int.parse(item)).toList();
  }


}