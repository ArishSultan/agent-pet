import 'package:agent_pet/src/pages/cart/main-cart.dart';
import 'package:agent_pet/src/pages/pet-relocation/main-pet-relocation.dart';
import 'package:agent_pet/src/pages/pet-relocation/pet_relocation-data.dart';
import 'package:agent_pet/src/pages/pets-and-vets_page.dart';
import 'package:agent_pet/src/pages/profile/saved_ads-page.dart';
import 'package:agent_pet/src/ui/pages/contact-us_page.dart';
import 'package:agent_pet/src/ui/pages/home_page.dart';
import 'package:agent_pet/src/pages/pets-listing/pet-listing_page.dart';
import 'package:flutter/cupertino.dart';

class AppPage {
  final String _name;

  const AppPage._(this._name);

  static const home = AppPage._('/');
  static const cart = AppPage._('/cart');
  static const allPets = AppPage._('/all-pets');
  static const favorites = AppPage._('/favorites');
  static const contactUs = AppPage._('/contact-us');
  static const featuredPets = AppPage._('/featured-pets');
  static const newlyAddedPets = AppPage._('/newly-added-pets');
  static const petsForAdoption = AppPage._('/pets-for-adoption');

  static const petRelocation = AppPage._('/pets-relocation');
  static const petAndVet = AppPage._('/pets-and-Vets');
}

abstract class AppNavigation {
  static Future<void> to(BuildContext context, Widget page) {
    return Navigator.of(context).push(CupertinoPageRoute(
      builder: (context) => page,
    ));
  }

  static Future<void> toPage(BuildContext context, AppPage page) {
    return Navigator.of(context).pushNamed(page._name);
  }

  /// Warning: use this method only if the navigation stack has [HomePage] in it
  /// otherwise all the pages will be removed from the [Navigator] stack and you
  /// will see a black screen.
  static void backToHome(BuildContext context) => Navigator.of(context)
      .popUntil((route) => route.settings.name == AppPage.home._name);

  static final routes = <String, WidgetBuilder>{
    AppPage.home._name: (context) => HomePage(),
    AppPage.cart._name: (context) => CartPage(),
    AppPage.allPets._name: (context) => PetListing(),
    AppPage.favorites._name: (context) => SavedAds(),
    AppPage.contactUs._name: (context) => ContactUsPage(),
    AppPage.petAndVet._name: (context) => PetAndVetPage(),
    AppPage.featuredPets._name: (context) => PetListing(listing: 4),
    AppPage.petRelocation._name: (context) => PetRelocationPage(),
    AppPage.newlyAddedPets._name: (context) => PetListing(listing: 0),
    AppPage.petsForAdoption._name: (context) => PetListing(listing: 1),
  };
}