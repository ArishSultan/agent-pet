import 'package:agent_pet/src/models/pet-type.dart';
import 'package:agent_pet/src/models/pet.dart';
import 'package:agent_pet/src/pages/search-pages/pet-search-page.dart';
import 'package:agent_pet/src/services/_service.dart';
import 'package:agent_pet/src/services/pet-service.dart';
import 'package:agent_pet/src/services/pet-type_service.dart';
import 'package:agent_pet/src/services/user-service.dart';
import 'package:agent_pet/src/utils/custom-navigator.dart';
import 'package:agent_pet/src/utils/local-data.dart';
import 'package:agent_pet/src/utils/simple-future-builder.dart';
import 'package:agent_pet/src/widgets/carousel-banner.dart';
import 'package:agent_pet/src/widgets/dots-indicator.dart';
import 'package:agent_pet/src/widgets/home-category-pageview.dart';
import 'package:agent_pet/src/widgets/new-pets-widget.dart';
import 'package:agent_pet/src/widgets/sliver-section-header.dart';
import 'package:agent_pet/src/widgets/tab-view-indexed.dart';
import 'package:agent_pet/src/widgets/view-all-button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'search-pages/home-search_page.dart';
import 'pet-detail_page.dart';
import 'pets-listing/pet-listing_page.dart';
import 'pet-relocation/main-pet-relocation.dart';
import 'pets-and-vets_page.dart';
import 'products-listing/product-listing_page.dart';

class HomePage extends StatefulWidget {
  HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final _service = PetService();
  final _typeService = PetTypeService();
  TabController _controller;
  Future<List<Pet>> _new;
  Future<List<Pet>> _featured;
  Future<List<PetType>>  _popular;
  PageController _pageController;
  int _index;
  List<String> _mobileBanners = [
        'assets/banners/dog-food.png',
        'assets/banners/cat-food.png',
        'assets/banners/bird-food.png',
        'assets/banners/fish-food.png',
  ];

  List<String> _webBanners = [
    'assets/banners/web-banner-dog.png',
    'assets/banners/web-banner-bird.png',
    'assets/banners/web-banner-fish.png',
    'assets/banners/web-banner-cat.png',
  ];

  @override
  void initState() {
    super.initState();

    _popular = _typeService.getPopularPets();
    _featured = _service.getFeaturedPets();
    _new = _service.getNewlyAddedPets();
    _pageController = PageController();

    _controller = TabController(length: 3, vsync: this);
    _controller.addListener((){

      setState(() {
        _index = _controller.index;
      });
      print(_index);

    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.primaries[0],
      child: CustomScrollView(slivers: <Widget>[
        SliverToBoxAdapter(
          child: Container(
            color: Colors.primaries[0],
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: (){
                  CustomNavigator.navigateTo(context, HomeSearchPage());
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
        ),
        SliverSectionHeader('Select a Category'),
        SliverToBoxAdapter(child: HomeCategoriesView()),


        SliverSectionHeader('Our Services'),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(
                top:5,
                bottom: 5
            ),
            child: Column(children: <Widget>[
              HomePageMainAction(
                subtitle: 'Buy & Sell Pets Online In Pakistan.',
                color: Color(0xfffd4245),
                image: 'assets/icons/buy-sell-icon.png',
                title: 'Pet Buy/Sell',
                onPressed: (){
                  CustomNavigator.navigateTo(context, PetListing(listing: 0,));
                },
              ),
              HomePageMainAction(
                subtitle: 'Find pets for adoption and match making in Pakistan.',
                color:  Color(0xfff8a135),
                image: 'assets/icons/mate.png',
                title: 'Pet Adoption / Match Making',
                onPressed: (){
                  CustomNavigator.navigateTo(context, PetListing(listing: 1,));
                },
              ),

              HomePageMainAction(
                subtitle: 'A variety of Animal supplies and pet accessories.',
                color: Color(0xff7b43a5),
                image: 'assets/icons/pet-store.png',
                title: 'Pet Store',
                onPressed: () {
                  CustomNavigator.baseNavigateTo(1, 0, 0);
                },
              ),
              HomePageMainAction(
                subtitle: 'Agent Pet Specializes in relocation of your pet intercity, interstates, import and export for whatever pet you need.',
                color: Color(0xff47b5e2),
                image: 'assets/icons/plane.png',
                title: 'Pet Relocation',
                onPressed: (){
                  CustomNavigator.navigateTo(context, PetRelocationPage());
                },
              ),

              HomePageMainAction(
                subtitle: 'Find Pet and Vet clinics in your area.',
                color: Color(0xfff8a135),
                image: 'assets/icons/veterinary.png',
                title: 'Pets and Vets',
                onPressed: () {
                  CustomNavigator.navigateTo(context, PetAndVetPage());
                },
              ),




            ]),
          ),
        ),
        /// Featured Pets
        SliverSectionHeader('Featured Pets',viewAllBtn(
            onPressed: (){
              CustomNavigator.navigateTo(context, PetListing(listing: 4,));
            }
        )),
//        SliverToBoxAdapter(child: Padding(
//          padding: const EdgeInsets.only(top:8.0),
//          child: Container(
//              height: 160,
//              child: SimpleFutureBuilder<List<Pet>>.simpler(
//                context: context, future: this._featured,
//                builder: (AsyncSnapshot<List<Pet>> snapshot) {
//                  return ListView.builder(
//                      scrollDirection: Axis.horizontal,
//                      itemCount: snapshot.data.length,
//                      itemBuilder: (context, i) {
//                        final _pet = snapshot.data[i];
//                        return Material(
//                          child: InkWell(
//                            onTap: () {
//                              CustomNavigator.navigateTo(context, PetDetailPage(pet: _pet,));
//                            },
//                            child: Padding(
//                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                              child: Column(children: <Widget>[
//                                ClipRect(child: SizedBox(
//                                  width: 90,
//                                  height: 90,
//                                  child: Stack(children: <Widget>[
//                                    ConstrainedBox(
//                                      constraints: BoxConstraints.expand(),
//                                      child: Image.network(
//                                          Service.getConvertedImageUrl(_pet.images[0].src),
//                                          fit: BoxFit.cover,
//                                          loadingBuilder: (context, widget, event) {
//                                            if (event != null) {
//                                              return Center(
//                                                child: CircularProgressIndicator(
//                                                    valueColor: AlwaysStoppedAnimation(Colors.black),
//                                                    value: event.cumulativeBytesLoaded / event.expectedTotalBytes
//                                                ),
//                                              );
//                                            } else if (widget != null) {
//                                              return widget;
//                                            } return CircularProgressIndicator(
//                                              valueColor: AlwaysStoppedAnimation(Colors.black),
//                                            );
//                                          }),
//                                    ),
//                                    Transform.translate(
//                                        offset: Offset(-55, -55),
//                                        child: Transform.rotate(
//                                          angle: 225.45,
//                                          child: Container(
//                                              width: 100,
//                                              height: 100,
//                                              color: Theme.of(context).primaryColor,
//                                              child: Align(
//                                                alignment: Alignment(0, .97),
//                                                child: Text("Featured", style: TextStyle(
//                                                    color: Colors.white,
//                                                    fontSize: 8,
//                                                    fontWeight: FontWeight.bold
//                                                ), textAlign: TextAlign.center),
//                                              )
//                                          ),
//                                        )
//                                    )
//                                  ]),
//                                )),
//                                Padding(
//                                  padding: const EdgeInsets.only(top: 10.0, bottom: 5),
//                                  child: Text(_pet.name[0].toUpperCase() + _pet.name.substring(1), overflow: TextOverflow.ellipsis),
//                                ),
//                                Text(_pet.type.name, style: TextStyle(fontSize: 9, color: Colors.grey)),
//                                Text(_pet.ownerCity, style: TextStyle(fontSize: 9)),
//                              ]),
//                            ),
//                          ),
//                        );
//                      }
//                  );
//                },
//              )
//          ),
//        )),
        SliverToBoxAdapter(
          child: SimpleFutureBuilder<List<Pet>>.simpler(
              context: context,
              future: _featured,
              builder: (AsyncSnapshot<List<Pet>> snapshot) {
                return Container(
                  height: 210,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, i)  {
                        var pet = snapshot.data[i];
                        return InkWell(
                          highlightColor: Colors.grey.shade200,
                          onTap: (){
                            CustomNavigator.navigateTo(context, PetDetailPage(pet: pet,));
                          },
                          child: NewPetsWidget(
                            pet: pet,
                          ),
                        );
                      },
                      itemCount: snapshot.data.length),
                );
              }
          ),
        ),

          SliverToBoxAdapter(child: Padding(
            padding: const EdgeInsets.only(top:7.0,bottom: 14),
            child: Carousel(_webBanners),
          )),

        /// Newly Arrived Pets
        SliverSectionHeader('Newly Added Pets',viewAllBtn(
            onPressed: (){
              CustomNavigator.navigateTo(context, PetListing(listing: 0,));
            }
        )),
        SliverToBoxAdapter(
          child: SimpleFutureBuilder<List<Pet>>.simpler(
              context: context,
              future: _new,
              builder: (AsyncSnapshot<List<Pet>> snapshot) {
                return Container(
                  height: 210,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, i)  {
                        var pet = snapshot.data[i];
                        return InkWell(
                          highlightColor: Colors.grey.shade200,
                          onTap: (){
                            CustomNavigator.navigateTo(context, PetDetailPage(pet: pet,));
                          },
                          child: NewPetsWidget(
                            pet: pet,
                          ),
                        );
                      },
                      itemCount: snapshot.data.length),
                );
              }
          ),
        ),

        SliverSectionHeader('Most Popular Pets In Pakistan'),

        SliverToBoxAdapter(
          child: SimpleFutureBuilder<List<PetType>>.simpler(
              context: context,
              future: _popular,
              builder: (AsyncSnapshot<List<PetType>> snapshot) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal:8.0),
                  child: Container(
                    height:100,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, i)  {
                          var pet = snapshot.data[i];
                          return Material(
                            child: InkWell(
                              onTap: (){
                                CustomNavigator.navigateTo(context, PetListing(petTypeId: pet.id,
                                  petName: '${pet.name}',
                                ));
                              },
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(left:8.0,right:8,top:8 ),
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal:8.0),
                                        child: CircleAvatar(
                                          child: Image.asset("assets/icons/${popularPetImages(pet.id)}.png", color: Colors.primaries[0]),
                                          backgroundColor: Colors.transparent,
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.primaries[0]),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                    ),
                                  ),
                                  Text(pet.name.split(' ').first,softWrap: true,),
                                  Text(pet.petsCount.toString()),
                                ],
                              ),
                            ),
                          );
                        },
                        itemCount: snapshot.data.length),
                  ),
                );
              }
          ),
        ),


        SliverToBoxAdapter(child: SizedBox(height: 25,),),
      ]), onRefresh: () async {
      _featured = _service.getFeaturedPets();
      _new = _service.getNewlyAddedPets();
      _popular = _typeService.getPopularPets();
      await _featured;
      await _new;
      await _popular;
      setState(() {});
    },
    );
  }

  String popularPetImages(int id){
    switch(id){
      case 1:
        return 'cat';
        break;
      case 2:
        return 'dog';
        break;
      case 3:
        return 'fish';
        break;
      case 4:
        return 'parrot';
        break;
      case 5:
        return 'cow';
        break;
      case 6:
        return 'bird';
        break;
      case 7:
        return 'ferret';
        break;
      case 8:
        return 'iguana';
        break;
      case 9:
        return 'horse';
        break;
      case 10:
        return 'monkey';
        break;
      case 11:
        return 'pig';
        break;
      case 12:
        return 'pony';
        break;
      case 13:
        return 'rabbit';
        break;
      case 14:
        return 'crocodiles';
        break;
      case 15:
        return 'lizard';
        break;
      case 16:
        return 'snake';
        break;
      case 17:
        return 'turtle';
        break;
      case 18:
        return 'frog';
        break;
      case 19:
        return 'hamster';
        break;
      case 3409:
        return 'pig';
        break;
      case 3692:
        return 'paw';
        break;
      case 3879:
        return 'lion';
        break;
      default:
        return 'paw';
        break;
    }
  }
}

class HomePageMainAction extends StatelessWidget {
  final Color color;
  final String image;
  final String title;
  final String subtitle;
  final Function onPressed;

  HomePageMainAction({
    this.color,
    this.image,
    this.title,
    this.subtitle,
    this.onPressed
  });


  @override
  Widget build(BuildContext context) {
    return  Column(
      children: <Widget>[
        ListTile(
          dense: true,
          leading: CircleAvatar(
            radius: 25,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Image.asset(image, color: Colors.white),
            ),
            backgroundColor: color,
          ),
          title:  Text(title, style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.primaries[0].shade400)),
          subtitle: Text(subtitle),
          trailing: Icon(Icons.navigate_next),
          onTap: onPressed,
        ),
        Divider(),
      ],
    );


  }





}

class _CategoryCell extends Material {
  _CategoryCell({
    String name,
    String image,
    Function onPressed
  }): super(
    child: InkWell(
      onTap: onPressed,
      child: Column(children: <Widget>[
        Image.asset(image, scale: 5.5, color: Colors.primaries[0]),
        SizedBox(height: 2,),
        Text(name, style: TextStyle(fontSize: 11), overflow: TextOverflow.ellipsis),
      ]),
    ),
  );
}



