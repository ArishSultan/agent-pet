import 'package:agent_pet/src/models/product.dart';
import 'package:agent_pet/src/models/saved-ads.dart';
import 'package:agent_pet/src/services/_service.dart';

class SavedAdsService extends Service<SavedAds>{
  @override
  SavedAds parse(Map<String, dynamic> item) {
    return SavedAds.fromJson(item);
  }

  Future<List<SavedAds>> getSavedPetsIds(int userId) async {
    return this.getAll('saved-ads/$userId');
  }

}