import 'package:agent_pet/src/pages/pet-store_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomNavigator {
  static navigateTo(context, widget) {
    return Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => widget)
    );
  }

  static Function _baseRouter;
  static TabController _petStoreRouter;

  static baseNavigateTo(int i, int j, int cat) async {
    if (_baseRouter != null) {
      _baseRouter(i);

      await Future.delayed(Duration(milliseconds: 400));

      if (_petStoreRouter != null) {
        PetStorePage.category = cat;
        _petStoreRouter.animateTo(j);
      }
    }
  }

  static registerBaseRouter(Function navigator) {
    _baseRouter = navigator;    // Register Controller;
  }

  static registerPetStoreRouter(TabController navigator) {
    _petStoreRouter = navigator;
  }
}