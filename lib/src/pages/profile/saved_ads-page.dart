import 'dart:math';

import 'package:agent_pet/src/models/pet.dart';
import 'package:agent_pet/src/models/product.dart';
import 'package:agent_pet/src/pages/product-detail_page.dart';
import 'package:agent_pet/src/services/misc-service.dart';
import 'package:agent_pet/src/services/pet-service.dart';
import 'package:agent_pet/src/services/product-service.dart';
import 'package:agent_pet/src/widgets/pet-listing-widget.dart';
import 'package:agent_pet/src/widgets/product-listing-widget.dart';
import 'package:agent_pet/src/utils/custom-navigator.dart';
import 'package:agent_pet/src/utils/local-data.dart';
import 'package:agent_pet/src/utils/simple-future-builder.dart';
import 'package:flutter/material.dart';
import '../pet-detail_page.dart';

class SavedAds extends StatefulWidget {

  @override
  _SavedAdsState createState() => _SavedAdsState();
}

class _SavedAdsState extends State<SavedAds> with SingleTickerProviderStateMixin{
  Future<List<Pet>> pets;
  Future<List<Product>> products;

  var _service = PetService();
  TabController _tabController;

  var _savedPetsIdsService = MiscService();

  @override
  void initState() {
    super.initState();
    _tabController =TabController(vsync: this,length:2 );
    LocalData.reloadSavedAdsIds();

   LocalData.isSignedIn ? _getOnlineAds() : _getOfflineAds();
  }

  Future _getOfflineAds([bool refresh=false]) async {
    List<String> _savedPets = [];
    LocalData.savedPetsIds.forEach((e){
      _savedPets.add(e.toString());
    });

    String petQuery = '';

    for (var i=0; i<_savedPets.length; ++i) {
      if (petQuery.indexOf('?') == -1) {
        petQuery = petQuery + '?pets[]=' + _savedPets[i];
      }else {
        petQuery = petQuery + '&pets[]=' + _savedPets[i];
      }
    }

    List<String> _savedProducts = [];
    LocalData.savedProductsIds.forEach((e){
      _savedProducts.add(e.toString());
    });

    String productsQuery = '';

    for (var i=0; i<_savedProducts.length; ++i) {
      if (productsQuery.indexOf('?') == -1) {
        productsQuery = productsQuery + '?products[]=' + _savedProducts[i];
      }else {
        productsQuery = productsQuery + '&products[]=' + _savedProducts[i];
      }
    }

    pets = _service.getOfflinePets(petQuery);
    products = ProductService().getOfflineProducts(productsQuery);

  }

  Future _getOnlineAds([bool refresh=false])async{

      pets = _service.getAll('saved-pets/${LocalData.user.id}');
      if(refresh){
        await pets;
        setState(() {});
      }

      products = ProductService().getAll('saved-products/${LocalData.user.id}');
      if(refresh){
        await products;
        setState(() {});
      }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
      color: Colors.primaries[0],
      onRefresh: () async {
         LocalData.isSignedIn ? await _getOnlineAds(true) : await _getOfflineAds(true);
      },
      child: CustomScrollView(
        slivers: <Widget>[

          SliverAppBar(
            centerTitle: true,
            title: Text('My Favorites'),
            bottom: TabBar(tabs: <Widget>[
              Tab(child: Text("Saved Pets")),
              Tab(child: Text("Saved Products")),
            ],controller: _tabController,) ,
          ),
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                SimpleFutureBuilder<List<Pet>>.simpler(
                    context: context,
                    future: pets,
                    builder: (AsyncSnapshot<List<Pet>> snapshot) {
                      return snapshot.data.length > 0 ?  ListView.builder(
                        itemCount: snapshot.data.length,
                          itemBuilder: (context, i) {
                            var _pet = snapshot.data[i];
                            return InkWell(
                              highlightColor: Colors.grey.shade200,
                              onTap: (){
                                CustomNavigator.navigateTo(context, PetDetailPage(pet: _pet,));
                              },
                              child: PetListingWidget(
                                pet: _pet,
                              ),
                            );
                          }
                      ): Center(child: Text("You haven't saved any pets!"));
                    }
                ),
                SimpleFutureBuilder<List<Product>>.simpler(
                    context: context,
                    future: products,
                    builder: (AsyncSnapshot<List<Product>> snapshot) {
                      return snapshot.data.length > 0 ?  ListView.builder(itemBuilder:
                              (context, i) {
                            var _product = snapshot.data[i];
                            return InkWell(
                                highlightColor: Colors.grey.shade200,
                                onTap: (){
                                  CustomNavigator.navigateTo(context, ProductDetailPage(product: _product,));
                                },
                                child: ProductListingWidget(product: _product,)
                            );
                          },
                          itemCount: snapshot.data.length
                      ): Center(child: Text("You haven't saved any products!"));
                    }
                ),

              ],
            ),
          ),

        ],
      ),
    ),
    );
  }
}
