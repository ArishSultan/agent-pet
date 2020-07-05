import 'package:agent_pet/src/models/_model.dart';

class Country extends Model {
  final String name;

  Country({
    int id,
    this.name,
  }): super(id);

  /// Since not posting is required.
  Map<String, dynamic> toJson() => {};

  Country.fromJson(Map<String, dynamic> json): this(
      id: json["id"],
      name: json["name"],
  );
}