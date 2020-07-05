import 'package:agent_pet/src/models/d.dart';
import 'package:agent_pet/src/pages/add-or-edit-pet/main-add-or-edit-pet.dart';
import 'package:agent_pet/src/pages/how-it-works_page.dart';
import 'package:agent_pet/src/pages/pet-relocation/main-pet-relocation.dart';
import 'package:agent_pet/src/pages/products-listing/product-listing_page.dart';
import 'package:agent_pet/src/pages/profile/edit-profile_page.dart';
import 'package:agent_pet/src/pages/profile/my-ads_page.dart';
import 'package:agent_pet/src/pages/profile/my-alerts_page.dart';
import 'package:agent_pet/src/pages/profile/my-orders_page.dart';
import 'package:agent_pet/src/pages/profile/profile_page.dart';
import 'package:agent_pet/src/services/auth_service.dart';
import 'package:agent_pet/src/pages/base_page.dart';
import 'package:agent_pet/src/pages/contact_page.dart';
import 'package:agent_pet/src/pages/pets-listing/pet-listing_page.dart';
import 'package:agent_pet/src/pages/pets-and-vets_page.dart';
import 'package:agent_pet/src/pages/auth/login_page.dart';
import 'package:agent_pet/src/pages/profile/messages_page.dart';
import 'package:agent_pet/src/pages/profile/saved_ads-page.dart';
import 'package:agent_pet/src/utils/custom-navigator.dart';
import 'package:agent_pet/src/utils/local-data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'custom-expansion-tile.dart' as custom;

class DrawerWidget extends StatefulWidget {
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        elevation: 0,
        child: SingleChildScrollView(
          child: Column(
              children: <Widget>[
            AppBar(
              automaticallyImplyLeading: false,

              title: Image.asset("assets/agent-pet-logo.png", fit: BoxFit.cover,scale: 8,),
              centerTitle: true,
              actions: <Widget>[
                IconButton(icon: Icon(Icons.close),onPressed: ()=> Navigator.of(context).pop(),)
              ],

            ),
            !LocalData.isSignedIn ?
            ListTile(
              dense:true,
              title: Row(
                children: <Widget>[
                  CircleAvatar(maxRadius: 16,backgroundColor: Colors.grey.shade200, child: Icon(Icons.person_pin,color: Colors.grey.shade700,),),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("SIGN IN / SIGN UP",style: TextStyle(fontWeight: FontWeight.bold
                    ),),
                  ),
                ],
              ),
              onTap: () async{
              await  CustomNavigator.navigateTo(context, LoginPage());
              setState(() {

              });
              },
            ) :
                custom.ExpansionTile(

                  title: Row(
                    children: <Widget>[
                      CircleAvatar(maxRadius: 16,backgroundColor: Colors.white,child: Icon(Icons.person_pin,color: Colors.grey.shade700,),),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(LocalData.user.name.toUpperCase(),style: TextStyle(color: Colors.primaries[0],fontSize:15,fontWeight: FontWeight.bold
                        ),),
                      ),
                    ],
                  ),

                  children: <Widget>[
                    ListTile(
                      dense:true,
                      title: Row(
                        children: <Widget>[
                          CircleAvatar(maxRadius: 16,backgroundColor: Colors.white,child: Icon(Icons.account_circle,size: 17,color: Colors.grey.shade800),),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("My Profile",style: TextStyle(
                            ),),
                          ),
                        ],
                      ),
                      onTap: () async {
                      await  CustomNavigator.navigateTo(context, EditProfile());
                      LocalData.reloadProfile();
                      },
                    ),
                    Divider(),
                    ListTile(
                      dense:true,
                      title: Row(
                        children: <Widget>[
                          CircleAvatar(maxRadius: 16,backgroundColor: Colors.white,child: Icon(Icons.pets,size: 17,color: Colors.grey.shade800),),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("My Ads",style: TextStyle(
                            ),),
                          ),
                        ],
                      ),
                      onTap: () {
                        CustomNavigator.navigateTo(context, MyAds());
                      },
                    ),
                    Divider(),
                    ListTile(
                      dense:true,
                      title: Row(
                        children: <Widget>[
                          CircleAvatar(maxRadius: 16,backgroundColor: Colors.white,child: Icon(Icons.description,size: 17,color: Colors.grey.shade800),),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Orders",style: TextStyle(
                            ),),
                          ),
                        ],
                      ),
                      onTap: (){
                        CustomNavigator.navigateTo(context,  MyOrders());
                      },
                    ),
                    Divider(),
                    ListTile(
                      dense:true,
                      title: Row(
                        children: <Widget>[
                          CircleAvatar(maxRadius: 16,backgroundColor: Colors.white,child: Icon(Icons.message,size: 17,color: Colors.grey.shade800),),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Messages",style: TextStyle(
                            ),),
                          ),
                        ],
                      ),
                      onTap: (){
                        CustomNavigator.navigateTo(context, MessagesPage());

                      },
                    ),
                    Divider(),
                    ListTile(
                      dense:true,
                      title: Row(
                        children: <Widget>[
                          CircleAvatar(maxRadius: 16,backgroundColor: Colors.white,child: Icon(Icons.notifications,size: 17,color: Colors.grey.shade800),),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Alerts",style: TextStyle(
                            ),),
                          ),
                        ],
                      ),
                      onTap: (){
                        CustomNavigator.navigateTo(context, MyAlerts());

                      },
                    ),
                    Divider(),
                    ListTile(
                      dense:true,
                      title: Row(
                        children: <Widget>[
                          CircleAvatar(maxRadius: 16,backgroundColor: Colors.white,child: Icon(Icons.exit_to_app, color: Colors.grey.shade800)),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Logout",style: TextStyle()),
                          ),
                        ],
                      ),
                      onTap: ()  {
                        AuthService().logOut();
                        CustomNavigator.navigateTo(context, BasePage());
                      },
                    )


                  ],
                ),

            Divider(),
                ListTile(
              dense:true,
              title: Row(
                children: <Widget>[
                  CircleAvatar(maxRadius: 16,backgroundColor: Colors.white,child: Image.asset("assets/icons/cat-add-pet.png"),),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Post Pet Ad",style: TextStyle(
                    ),),
                  ),
                  Container(
                      child: Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: Text("FREE", style: TextStyle(color: Colors.white, fontSize: 10))
                      ),
                      decoration: BoxDecoration(
                          color: Colors.primaries[0], borderRadius: BorderRadius.circular(10)
                      )
                  )
                ],
              ),
              onTap: (){
                CustomNavigator.navigateTo(context, LocalData.isSignedIn ? AddPetPage() : LoginPage());
              },
            ),
                Divider(),
                custom.ExpansionTile(

                  title: Row(
                    children: <Widget>[
                      CircleAvatar(maxRadius: 16,backgroundColor: Colors.white,child: Image.asset("assets/icons/pet-store.png",color: Colors.black,),),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Pet Store",style: TextStyle(color: Colors.black
                        ),),
                      ),
                    ],
                  ),
                  children: <Widget>[
                    ListTile(
                      dense:true,
                      title: Row(
                        children: <Widget>[
                          CircleAvatar(maxRadius: 16,backgroundColor: Colors.white,child: Image.asset("assets/icons/dog.png",scale:2,color: Colors.grey.shade800,),),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Dog",style: TextStyle(
                            ),),
                          ),
                        ],
                      ),
                      onTap: () {
                        CustomNavigator.navigateTo(context, ProductListing(listing: 10,petTypeId: 2,petName: 'Dog'));
                        },
                    ),
                    Divider(),
                    ListTile(
                      dense:true,
                      title: Row(
                        children: <Widget>[
                          CircleAvatar(maxRadius: 16,backgroundColor: Colors.white,child: Image.asset("assets/icons/cat.png",scale:2,color: Colors.grey.shade800,),),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Cat",style: TextStyle(
                            ),),
                          ),
                        ],
                      ),
                      onTap: (){
                        CustomNavigator.navigateTo(context, ProductListing(listing: 10,petTypeId: 1,petName: 'Cat'));
                      },
                    ),
                    Divider(),
                    ListTile(
                      dense:true,
                      title: Row(
                        children: <Widget>[
                          CircleAvatar(maxRadius: 16,backgroundColor: Colors.white,child: Image.asset("assets/icons/bird.png",scale:2,color: Colors.grey.shade800,),),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Bird",style: TextStyle(
                            ),),
                          ),
                        ],
                      ),
                      onTap: (){
                        CustomNavigator.navigateTo(context, ProductListing(listing: 10,petTypeId: 6,petName: 'Bird'));
                      },
                    ),
                    Divider(),
                    ListTile(
                      dense:true,
                      title: Row(
                        children: <Widget>[
                          CircleAvatar(maxRadius: 16,backgroundColor: Colors.white,child: Image.asset("assets/icons/fish.png",scale:2,color: Colors.grey.shade800,),),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Fish",style: TextStyle(
                            ),),
                          ),
                        ],
                      ),
                      onTap: (){
                        CustomNavigator.navigateTo(context, ProductListing(listing: 10,petTypeId: 3,petName: 'Fish'));
                      },
                    ),
                    Divider(),

                  ],
                ),


                Divider(),

                ListTile(

              dense:true,
              title: Row(
                children: <Widget>[
                  CircleAvatar(maxRadius: 16,backgroundColor: Colors.white,child: Image.asset("assets/icons/buy-sell-icon.png",scale:2,color: Colors.grey.shade800,),),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Buy / Sell Pet",style: TextStyle(
                    ),),
                  ),
                ],
              ),
              onTap: (){
//                CustomNavigator.navigateTo(context, PetListingTest());
                CustomNavigator.navigateTo(context, PetListing(listing: 0,));
              },
            ),

                Divider(),

                ListTile(
                  dense:true,
                  title: Row(
                    children: <Widget>[
                      CircleAvatar(maxRadius: 16,backgroundColor: Colors.white,child:  Image.asset("assets/icons/mate.png",scale:2,color: Colors.grey.shade800,),),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Adopt A Pet",style: TextStyle(
                        ),),
                      ),
                    ],
                  ),
                  onTap: (){
                    CustomNavigator.navigateTo(context, PetListing(listing: 1,));
                  },
                ),
            Divider(),

                ListTile(
                  dense:true,
                  title: Row(
                    children: <Widget>[
                      CircleAvatar(maxRadius: 16,backgroundColor: Colors.white,child:  Image.asset("assets/icons/plane.png",scale:2,color: Colors.grey.shade800,),),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Pet Relocation",style: TextStyle(
                        ),),
                      ),
                    ],
                  ),
                  onTap: (){
                    CustomNavigator.navigateTo(context, PetRelocationPage());
                  },
                ),
                Divider(),
                ListTile(
                  dense:true,
                  title: Row(
                    children: <Widget>[
                      CircleAvatar(maxRadius: 16,backgroundColor: Colors.white,child: Image.asset("assets/icons/veterinary.png",color: Colors.grey.shade800,),),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Pets & Vets",style: TextStyle(
                        ),),
                      ),
                    ],
                  ),
                  onTap: (){
                    CustomNavigator.navigateTo(context, PetAndVetPage());
                  },
                ),
                Divider(),
               ListTile(
                 dense:true,
                 title: Row(
                   children: <Widget>[
                     CircleAvatar(maxRadius: 16,backgroundColor: Colors.white,child: Icon(Icons.favorite,size: 22,color: Colors.grey.shade800,),),
                     Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Text("My Favorites",style: TextStyle(
                       ),),
                     ),
                   ],
                 ),
                 onTap: (){
                   CustomNavigator.navigateTo(context, SavedAds());
                 },
               ),


               Divider() ,


                ListTile(
                  dense:true,
                  title: Row(
                    children: <Widget>[
                      CircleAvatar(maxRadius: 16,backgroundColor: Colors.white,child: Icon(Icons.info,color: Colors.grey.shade800,),),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("How It Works",style: TextStyle(
                        ),),
                      ),
                    ],
                  ),
                  onTap: (){
                    CustomNavigator.navigateTo(context, HowItWorks());
                  },
                ),
                Divider(),

            ListTile(
              dense:true,
              title: Row(
                children: <Widget>[
                  CircleAvatar(maxRadius: 16,backgroundColor: Colors.white,child: Icon(Icons.mail,color: Colors.grey.shade800,),),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Contact",style: TextStyle(
                    ),),
                  ),
                ],
              ),
              onTap: (){
                CustomNavigator.navigateTo(context, Contact());
              },
            ),
            Divider(),




          ]),
        ),
      ),
    );
  }
}






