import 'package:agent_pet/src/pages/home_page.dart';
import 'package:agent_pet/src/pages/pets-listing/pet-listing_page.dart';
import 'package:flutter/cupertino.dart';

class AppPage {
  final String _name;

  const AppPage._(this._name);

  static const home = AppPage._('/');
  static const allPets = AppPage._('/all-pets');
  static const petsForAdoption = AppPage._('/pets-for-adoption');
}

abstract class AppNavigation {
  static Future<void> to(BuildContext context, Widget page) {
    return Navigator.of(context).push(CupertinoPageRoute(
      builder: (context) => page,
    ));
  }

  static Future<void> toPage(BuildContext context, AppPage page) {
    // return Navigator.of(context).pushNamed(page._name);
  }

  /// Warning: use this method only if the navigation stack has [HomePage] in it
  /// otherwise all the pages will be removed from the [Navigator] stack and you
  /// will see a black screen.
  static void backToHome(BuildContext context) => Navigator.of(context)
      .popUntil((route) => route.settings.name == AppPage.home._name);

  static final routes = <String, WidgetBuilder>{
    AppPage.home._name: (context) => HomePage(),
    AppPage.allPets._name: (context) => PetListing(),
    AppPage.petsForAdoption._name: (context) => PetListing(listing: 1),
  };
}