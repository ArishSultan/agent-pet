import 'package:agent_pet/src/models/_model.dart';

class Brand extends Model {
  final String name;
  final String slug;
  final String image;

  Brand({
    int id,
    this.name,
    this.slug,
    this.image
  }) : super(id);

  Brand.fromJson(Map<String, dynamic> json): this(
    id: json["id"],
    name: json["name"],
    slug: json["slug"],
    image: json["image"]
  );
}