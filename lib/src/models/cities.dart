import 'package:agent_pet/src/models/_model.dart';

class Cities extends Model{
  List<String> shopCities;

  Cities({this.shopCities}): super(0);

  Cities.fromJson(Map<String, dynamic> json): this(
    shopCities: json['shop_cities'].cast<String>(),
  );

  Map<String, dynamic> toJson() => {};
}