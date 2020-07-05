import 'dart:io';
import 'dart:convert';
import 'package:agent_pet/src/models/order-item.dart';
import 'package:agent_pet/src/models/pet.dart';
import 'package:agent_pet/src/models/product.dart';
import 'package:agent_pet/src/models/user.dart';
import 'package:agent_pet/src/services/saved-ads-service.dart';
import 'package:agent_pet/src/services/user-service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:agent_pet/src/services/_service.dart';

//
class LocalData {
  static Map<String, Function> _listeners = Map();

  static User _user;

  static User get user => _user;

  /// Flag for Authentication.
  static bool get isSignedIn => _user != null;

  /// List Representing Product Cart.
  static List<OrderItem> _productCart = [];

  /// List Representing Api Saved Pets.
  static List<int> savedPetsIds = [];

  /// List Representing Saved Products.
  static List<int> savedProductsIds = [];

  static List<OrderItem> getCart() => _productCart;

  static List<int> getSavedPetsIds() => savedPetsIds;

  static List<int> getSavedProductsIds() => savedProductsIds;

  static void registerLikeListener(Function listener) {
    if (!_listeners.containsKey("like")) {
      _listeners.addAll({
        "like": listener
      });
    }
  }

  static void unRegisterLikeListener() {
    _listeners.remove("like");
  }

  static void likeChanged() {
    print("called");
    if (_listeners.containsKey("like")) {
      print("callesassad");
      _listeners["like"]();
    }
  }


  static void savePetId(pet) {
    LocalData.savedPetsIds.add(pet);
    writeData();
  }


  static void saveProductId(product) {
    LocalData.savedProductsIds.add(product);
    writeData();
  }


  static void addToCart(product) {
    LocalData._productCart.add(product);
    writeData();
  }

  static void clearCart() {
    LocalData._productCart=[];
    writeData();
  }

  static void removeFromCart(int index) {
    LocalData._productCart.removeAt(index);
    writeData();
  }

  static void removeFromSavedPetIds(int index) {
    LocalData.savedPetsIds.removeAt(index);
    writeData();
  }


  static void removeFromSavedProductIds(int index) {
    LocalData.savedProductsIds.removeAt(index);
    writeData();
  }

  static loadData() async {

    final file = File((await getApplicationDocumentsDirectory()).path + '/data.json');
//    await file.writeAsString('{}');

    try {
      final data = jsonDecode(await file.readAsString());
      print(data);

      _user = data['user']!= null ? User.fromJson(data['user']) : null;
      _productCart = data['cart']?.map<OrderItem>((item) => OrderItem.fromJson(item))?.toList() ?? [];
      savedPetsIds = (data['saved-pets-ids'] as List)?.cast<int>() ?? [];
      savedProductsIds = (data['saved-products-ids'] as List)?.cast<int>() ?? [];

    } catch (e) {
      print(e);
//      await file.writeAsString('');

    }
  }

  static writeData() async {
    final file = File((await getApplicationDocumentsDirectory()).path + '/data.json');

    await file.writeAsString(jsonEncode({
      'user': _user?.toJson(),
      'cart': _productCart.map((item) => item.toJson()).toList(),
      'saved-pets-ids': savedPetsIds,
      'saved-products-ids': savedProductsIds,
    }));
    print(await file.readAsString());
  }

  static bool canPurchase(OrderItem item) {
    for(final prod in _productCart) {

      if(prod?.selectedAttribute!=null){
        if(prod.product.id == item.product.id &&
            item.selectedAttribute.id == prod.selectedAttribute.id
        ) {
          return false;
        }
      }else if (prod.product.id == item.product.id){
        return false;
      }

    }
    return true;

  }


  static bool canSavePetId(int id) {
    return ! savedPetsIds.contains(id);
  }

  static bool canSaveProductId(int id) {
    return ! savedProductsIds.contains(id);
  }

  static void reloadProfile() async {
    if(isSignedIn){
      await UserService().fetchProfile(LocalData.user.id).then((profile){
        LocalData.signIn(profile[0]);
      });
    }
  }

  static void reloadSavedAdsIds() async {
    if(isSignedIn){

//     await LocalData.savedPets.forEach((pet) async {
//
//        FormData _saveAd = FormData.fromMap({
//          "user_id": LocalData.user.id,
//          "pet_id": pet.id
//        });
//        await Service.post("save-ad", _saveAd);
//        print(pet.id.toString() + 'saved');
//        LocalData.savedPets.remove(pet);
//
//      });
//
//     await LocalData.savedProducts.forEach((prod) async {
//
//       FormData _saveAd = FormData.fromMap({
//         "user_id": LocalData.user.id,
//         "product_id": prod.id
//       });
//
//       await Service.post("save-product", _saveAd);
//       print(prod.id.toString() + 'saved prod');
//       LocalData.savedProducts.remove(prod);
//     });


      await  SavedAdsService().getSavedPetsIds(LocalData.user.id).then((ad){
        LocalData.savedPetsIds= ad[0].savedPets;
        LocalData.savedProductsIds= ad[0].savedProducts;
        LocalData.writeData();
      });

    }
  }


  static void signIn(User user) {
    /// Code for Signing-In
    ///
    LocalData._user = user;
    writeData();
    reloadSavedAdsIds();
  }

  static void signOut() {
    LocalData._user = null;

    writeData();
  }




}
