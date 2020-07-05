import 'package:agent_pet/src/models/_model.dart';

class PetType extends Model {
  final String name;
  final String image;
  final int petsCount;

  PetType({
    int id,
    this.name,
    this.image,
    this.petsCount
  }): super(id);

  /// Since not posting is required.
  Map<String, dynamic> toJson() => {};

  PetType.fromJson(Map<String, dynamic> json): this(
    id: json["id"],
    name: json["name"],
    image: json["image"],
    petsCount: json["pets_count"]
  );
}