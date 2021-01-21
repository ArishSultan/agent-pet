import 'package:agent_pet/src/base/assets.dart';
import 'package:agent_pet/src/pages/pets-listing/pet-listing_page.dart';
import 'package:agent_pet/src/pages/pet-relocation/main-pet-relocation.dart';
import 'package:agent_pet/src/utils/custom-navigator.dart';
import 'package:agent_pet/src/widgets/bullet-point-widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'search-pages/pet-search-page.dart';


class AdoptAPet extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.primaries[0],
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: (){
                  CustomNavigator.navigateTo(context, PetSearchPage());
                },
                child: Container(
                  height: 48.0,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0,right: 8),
                        child: Icon(Icons.search,size: 22,),
                      ),
                      Text("Search",style: TextStyle(fontSize: 16),),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Column(

                children: <Widget>[

                  Text("Pet Adoption / Matchmaking Made Easy",style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                  ),),
                  SizedBox(
                    height: 10,
                  ),
                  ClipRRect(child:
                  Image.asset(Assets.howItWorks1, scale: 3),
                    borderRadius: BorderRadius.circular(10),),
                  SizedBox(height: 10,),
                  Center(child: Text("Ready to add a new love to your family? There are so many wonderful pets in your community waiting for loving homes.Put your love into action by adopting today - and spread the word that adoption is the way to go.",style: TextStyle(
                      fontSize: 15
                  ),)),

                  SizedBox(height: 10,),


                  RaisedButton(
                    onPressed: (){
                      CustomNavigator.navigateTo(context, PetListing(listing: 1,));
                    },
                    color: Colors.primaries[0],
                    child: Text(
                      "Adopt at AgentPet",
                      style: TextStyle(color: Colors.white,),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}
