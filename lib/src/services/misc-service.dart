import 'dart:convert';
import 'package:agent_pet/src/models/cities.dart';
import 'package:agent_pet/src/services/_service.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class MiscService extends Service<Cities> {
  @override
  Cities parse(Map<String, dynamic> item) {
    return Cities.fromJson(item);
  }

  Future<List<String>> getCities() async {
    Response res = await http.get('$apiUrl/api/cities');
    return (jsonDecode(res.body) as List).map((item) => item.toString()).toList();
  }

  Future<List<String>> getShopCities() async {
    Response res = await http.get('$apiUrl/api/shop-cities');
    return (jsonDecode(res.body) as List).map((item) => item.toString()).toList();
  }

  Future<double> getMaxProductsPrice() async {
    Response res = await http.get('$apiUrl/api/max-price');
    return (jsonDecode(res.body));
  }

  Future<int> getPetsCount() async {
    Response res = await http.get('$apiUrl/api/pets-count');
    return (jsonDecode(res.body));
  }

  Future<int> getProductsCount() async {
    Response res = await http.get('$apiUrl/api/products-count');
    return (jsonDecode(res.body));
  }




}