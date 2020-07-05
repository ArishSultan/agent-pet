import 'package:agent_pet/src/models/_model.dart';

class SavedAds extends Model {
  final List<int> savedPets;
  final List<int> savedProducts;


  SavedAds({
    this.savedPets,
    this.savedProducts,
  }): super(0);

  /// Since not posting is required.
  Map<String, dynamic> toJson() => {};

  SavedAds.fromJson(Map<String, dynamic> json): this(
    savedPets : (json['saved_pets'] as List).cast<int>().toList(),
    savedProducts : (json['saved_products'] as List).cast<int>().toList(),
  );
}