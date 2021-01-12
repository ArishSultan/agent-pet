import 'package:agent_pet/src/base/assets.dart';
import 'package:agent_pet/src/base/nav.dart';
import 'package:agent_pet/src/pages/pets-listing/pet-listing_page.dart';
import 'package:agent_pet/src/utils/custom-navigator.dart';
import 'package:agent_pet/src/widgets/home-category-pageview.dart';
import 'package:agent_pet/src/widgets/sliver-section-header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StadiumTabBar extends Container {
  static const _tabPadding = const EdgeInsets.symmetric(horizontal: 12);

  StadiumTabBar({
    double height,
    EdgeInsets margin = const EdgeInsets.symmetric(vertical: 5),
    List<String> tabs,
  }) : super(
          color: const Color(0),
          height: height,
          margin: margin,
          child: TabBar(
            labelPadding: EdgeInsets.symmetric(horizontal: 0),
            isScrollable: true,
            indicator: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),
            ),
            enableFeedback: false,
            indicatorColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: tabs
                .map((e) => Container(padding: _tabPadding, child: Text(e)))
                .toList(),
          ),
        );
}

class CategoriesView extends StatefulWidget {
  @override
  _CategoriesViewState createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  static const _tabPadding = const EdgeInsets.symmetric(horizontal: 12);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            StadiumTabBar(height: 25, tabs: ['Pets', 'Foods', 'Accessories']),
            Expanded(
              child: TabBarView(children: [
                Container(color: Colors.red),
                Container(color: Colors.blue),
                Container(color: Colors.green),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryCell extends StatelessWidget {
  final String name;
  final String asset;

  _CategoryCell(this.name, this.asset);

  @override
  Widget build(BuildContext context) {
    return TableCell(
      child: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          minimumSize: Size(60, 60),
          primary: Theme.of(context).primaryColor,
        ),
        child: Column(children: [
          Expanded(child: Image.asset(asset)),
          Text(
            name,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w300,
              color: Colors.black,
              fontFamily: 'Roboto',
            ),
          ),
        ]),
      ),
    );
  }
}

class _PetCategory {
  final String name;
  final String image;

  const _PetCategory({this.name, this.image});

  static const all = [
    _PetCategory(name: 'Dog', image: Assets.dog),
    _PetCategory(name: 'Cat', image: Assets.cat),
    _PetCategory(name: 'Bird', image: Assets.bird),
    _PetCategory(name: 'Fish', image: Assets.fish),
    _PetCategory(name: 'Cow', image: Assets.cow),
    _PetCategory(name: 'Lion', image: Assets.lion),
    _PetCategory(name: 'Rabbit', image: Assets.rabbit),
    _PetCategory(name: 'Parrot', image: Assets.parrot),
    _PetCategory(name: 'Monkey', image: Assets.monkey),
    _PetCategory(name: 'Lizard', image: Assets.lizard),
    _PetCategory(name: 'Hamsters', image: Assets.hamster),
    _PetCategory(name: 'Pony', image: Assets.pony),
    _PetCategory(name: 'Iguana', image: Assets.iguana),
    _PetCategory(name: 'Ferret', image: Assets.ferret),
    _PetCategory(name: 'Crocodile', image: Assets.crocodile),
    _PetCategory(name: 'Pig', image: Assets.pig),
    _PetCategory(name: 'Guinea Pig'),
    _PetCategory(name: 'Horse'),
    _PetCategory(name: 'Snake'),
    _PetCategory(name: 'Frog'),
    _PetCategory(name: 'Turtle'),
    _PetCategory(name: 'Other Pets'),
  ];
}

class _PetsTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Column(children: []),
    );
    // return LayoutBuilder(
    //   builder: (context, constraints) {
    //     if (constraints.maxWidth);
    //   },
    // )
    // return Table(
    //   children: [
    //     TableRow(children: [
    //       _CategoryCell('Dog', Assets.dog),
    //       _CategoryCell('Cat', Assets.cat),
    //       _CategoryCell('Bird', Assets.bird),
    //       _CategoryCell('Fish', Assets.fish),
    //     ]),
    //     TableRow(children: [
    //       _CategoryCell('Cow', Assets.cow),
    //       _CategoryCell('Lion', Assets.lion),
    //       _CategoryCell('Rabbit', Assets.rabbit),
    //       _CategoryCell('Parrot', Assets.parrot),
    //     ])
    //   ],
    // );
  }
}

class _HomeViewAction extends StatelessWidget {
  final Color color;
  final AppPage page;

  final String image;
  final String title;
  final String subtitle;

  const _HomeViewAction({
    this.page,
    this.color,
    this.image,
    this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey.shade200),
            bottom: BorderSide(color: Colors.grey.shade200),
          ),
        ),
        child: TextButton(
          onPressed: () => AppNavigation.toPage(context, page),
          style: TextButton.styleFrom(
              primary: Colors.grey, padding: EdgeInsets.zero),
          child: Row(children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: CircleAvatar(
                radius: 25,
                backgroundColor: color,
                child: Image.asset(image, scale: 2.2, color: Colors.white),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Icon(
                CupertinoIcons.chevron_right,
                color: Colors.grey.shade400,
              ),
            )
          ]),
        ),
      ),
    );
  }
}

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.black,
      onRefresh: () {
        return Future.delayed(Duration(seconds: 2));
      },
      child: CustomScrollView(slivers: [
        SliverSectionHeader('Select a Category'),
        _HomeViewAction(
          page: AppPage.allPets,
          title: 'Pet Buy/Sell',
          image: Assets.petBuySell,
          color: const Color(0xfffd4245),
          subtitle: 'Buy & Sell Pets Online In Pakistan.',
        ),
        _HomeViewAction(
          image: Assets.mate,
          page: AppPage.petsForAdoption,
          color: const Color(0xfff8a135),
          title: 'Pet Adoption / Match Making',
          subtitle: 'Find pets for adoption and match making in Pakistan.',
        ),
        _HomeViewAction(
          title: 'Pet Store',
          image: Assets.petStore,
          color: const Color(0xff7b43a5),
          subtitle: 'A variety of Animal supplies and pet accessories.',
          // onPressed: () {
          //   CustomNavigator.baseNavigateTo(1, 0, 0);
          // },
        ),
        _HomeViewAction(
          subtitle:
              'Agent Pet Specializes in relocation of your pet intercity, interstates, import and export for whatever pet you need.',
          color: const Color(0xff47b5e2),
          image: Assets.relocation,
          title: 'Pet Relocation',
          // onPressed: () {
          //   CustomNavigator.navigateTo(context, PetRelocationPage());
          // },
        ),
        _HomeViewAction(
          subtitle: 'Find Pet and Vet clinics in your area.',
          color: const Color(0xfff8a135),
          image: Assets.veterinary,
          title: 'Pets and Vets',
          // onPressed: () {
          // CustomNavigator.navigateTo(context, PetAndVetPage());

          // },
        ),
        // SliverToBoxAdapter(child: _PetsTable()),
        // SliverToBoxAdapter(child: HomeCategoriesView()),
        // SliverToBoxAdapter(
        //   child: Container(
        //     color: Colors.primaries[0],
        //     child: Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: InkWell(
        //         onTap: (){
        //           // CustomNavigator.navigateTo(context, HomeSearchPage());
        //         },
        //         child: Container(
        //           height: 48.0,
        //           alignment: Alignment.center,
        //           decoration: BoxDecoration(
        //               color: Colors.white,
        //               borderRadius: BorderRadius.circular(20)
        //           ),
        //           child: Row(
        //             children: <Widget>[
        //               Padding(
        //                 padding: const EdgeInsets.only(left: 20.0,right: 8),
        //                 child: Icon(Icons.search,size: 22,),
        //               ),
        //               Text("Search",style: TextStyle(fontSize: 16),),
        //             ],
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
      ]),
    );
  }
}

// class HomePage extends StatefulWidget {
//   HomePage();
//
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
//   final _service = PetService();
//   final _typeService = PetTypeService();
//   TabController _controller;
//   Future<List<Pet>> _new;
//   Future<List<Pet>> _featured;
//   Future<List<PetType>> _popular;
//   PageController _pageController;
//   int _index;
//   List<String> _mobileBanners = [
//     'assets/banners/dog-food.png',
//     'assets/banners/cat-food.png',
//     'assets/banners/bird-food.png',
//     'assets/banners/fish-food.png',
//   ];
//
//   List<String> _webBanners = [
//     'assets/banners/web-banner-dog.png',
//     'assets/banners/web-banner-bird.png',
//     'assets/banners/web-banner-fish.png',
//     'assets/banners/web-banner-cat.png',
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//
//     _popular = _typeService.getPopularPets();
//     _featured = _service.getFeaturedPets();
//     _new = _service.getNewlyAddedPets();
//     _pageController = PageController();
//
//     _controller = TabController(length: 3, vsync: this);
//     _controller.addListener((){
//
//       setState(() {
//         _index = _controller.index;
//       });
//       print(_index);
//
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//   return RefreshIndicator(
//     color: Colors.primaries[0],
//     child: CustomScrollView(slivers: <Widget>[
//       SliverSectionHeader('Select a Category'),
//       SliverToBoxAdapter(child: HomeCategoriesView()),
//
//
//       SliverSectionHeader('Our Services'),
//       SliverToBoxAdapter(
//         child: Padding(
//           padding: const EdgeInsets.only(
//               top:5,
//               bottom: 5
//           ),
//           child: Column(children: <Widget>[
//             HomePageMainAction(
//               subtitle: 'Buy & Sell Pets Online In Pakistan.',
//               color: Color(0xfffd4245),
//               image: 'assets/icons/buy-sell-icon.png',
//               title: 'Pet Buy/Sell',
//               onPressed: (){
//                 CustomNavigator.navigateTo(context, PetListing(listing: 0,));
//               },
//             ),
//             HomePageMainAction(
//               subtitle: 'Find pets for adoption and match making in Pakistan.',
//               color:  Color(0xfff8a135),
//               image: 'assets/icons/mate.png',
//               title: 'Pet Adoption / Match Making',
//               onPressed: (){
//                 CustomNavigator.navigateTo(context, PetListing(listing: 1,));
//               },
//             ),
//
//             HomePageMainAction(
//               subtitle: 'A variety of Animal supplies and pet accessories.',
//               color: Color(0xff7b43a5),
//               image: 'assets/icons/pet-store.png',
//               title: 'Pet Store',
//               onPressed: () {
//                 CustomNavigator.baseNavigateTo(1, 0, 0);
//               },
//             ),
//             HomePageMainAction(
//               subtitle: 'Agent Pet Specializes in relocation of your pet intercity, interstates, import and export for whatever pet you need.',
//               color: Color(0xff47b5e2),
//               image: 'assets/icons/plane.png',
//               title: 'Pet Relocation',
//               onPressed: (){
//                 CustomNavigator.navigateTo(context, PetRelocationPage());
//               },
//             ),
//
//             HomePageMainAction(
//               subtitle: 'Find Pet and Vet clinics in your area.',
//               color: Color(0xfff8a135),
//               image: 'assets/icons/veterinary.png',
//               title: 'Pets and Vets',
//               onPressed: () {
//                 CustomNavigator.navigateTo(context, PetAndVetPage());
//               },
//             ),
//
//
//
//
//           ]),
//         ),
//       ),
//       /// Featured Pets
//       SliverSectionHeader('Featured Pets',viewAllBtn(
//           onPressed: (){
//             CustomNavigator.navigateTo(context, PetListing(listing: 4,));
//           }
//       )),
//       SliverToBoxAdapter(
//         child: SimpleFutureBuilder<List<Pet>>.simpler(
//             context: context,
//             future: _featured,
//             builder: (AsyncSnapshot<List<Pet>> snapshot) {
//               return Container(
//                 height: 210,
//                 child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemBuilder: (context, i)  {
//                       var pet = snapshot.data[i];
//                       return InkWell(
//                         highlightColor: Colors.grey.shade200,
//                         onTap: (){
//                           CustomNavigator.navigateTo(context, PetDetailPage(pet: pet,));
//                         },
//                         child: NewPetsWidget(
//                           pet: pet,
//                         ),
//                       );
//                     },
//                     itemCount: snapshot.data.length),
//               );
//             }
//         ),
//       ),
//
//       SliverToBoxAdapter(child: Padding(
//         padding: const EdgeInsets.only(top:7.0,bottom: 14),
//         child: Carousel(_webBanners),
//       )),
//
//       /// Newly Arrived Pets
//       SliverSectionHeader('Newly Added Pets',viewAllBtn(
//           onPressed: (){
//             CustomNavigator.navigateTo(context, PetListing(listing: 0,));
//           }
//       )),
//       SliverToBoxAdapter(
//         child: SimpleFutureBuilder<List<Pet>>.simpler(
//             context: context,
//             future: _new,
//             builder: (AsyncSnapshot<List<Pet>> snapshot) {
//               return Container(
//                 height: 210,
//                 child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemBuilder: (context, i)  {
//                       var pet = snapshot.data[i];
//                       return InkWell(
//                         highlightColor: Colors.grey.shade200,
//                         onTap: (){
//                           CustomNavigator.navigateTo(context, PetDetailPage(pet: pet,));
//                         },
//                         child: NewPetsWidget(
//                           pet: pet,
//                         ),
//                       );
//                     },
//                     itemCount: snapshot.data.length),
//               );
//             }
//         ),
//       ),
//
//       SliverSectionHeader('Most Popular Pets In Pakistan'),
//
//       SliverToBoxAdapter(
//         child: SimpleFutureBuilder<List<PetType>>.simpler(
//             context: context,
//             future: _popular,
//             builder: (AsyncSnapshot<List<PetType>> snapshot) {
//               return Padding(
//                 padding: const EdgeInsets.symmetric(horizontal:8.0),
//                 child: Container(
//                   height:100,
//                   child: ListView.builder(
//                       scrollDirection: Axis.horizontal,
//                       itemBuilder: (context, i)  {
//                         var pet = snapshot.data[i];
//                         return Material(
//                           child: InkWell(
//                             onTap: (){
//                               CustomNavigator.navigateTo(context, PetListing(petTypeId: pet.id,
//                                 petName: '${pet.name}',
//                               ));
//                             },
//                             child: Column(
//                               children: <Widget>[
//                                 Padding(
//                                   padding: const EdgeInsets.only(left:8.0,right:8,top:8 ),
//                                   child: Container(
//                                     height: 50,
//                                     width: 50,
//                                     child: Padding(
//                                       padding: const EdgeInsets.symmetric(horizontal:8.0),
//                                       child: CircleAvatar(
//                                         child: Image.asset("assets/icons/${popularPetImages(pet.id)}.png", color: Colors.primaries[0]),
//                                         backgroundColor: Colors.transparent,
//                                       ),
//                                     ),
//                                     decoration: BoxDecoration(
//                                       border: Border.all(color: Colors.primaries[0]),
//                                       borderRadius: BorderRadius.circular(50),
//                                     ),
//                                   ),
//                                 ),
//                                 Text(pet.name.split(' ').first,softWrap: true,),
//                                 Text(pet.petsCount.toString()),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                       itemCount: snapshot.data.length),
//                 ),
//               );
//             }
//         ),
//       ),
//
//
//       SliverToBoxAdapter(child: SizedBox(height: 25,),),
//     ]), onRefresh: () async {
//     _featured = _service.getFeaturedPets();
//     _new = _service.getNewlyAddedPets();
//     _popular = _typeService.getPopularPets();
//     await _featured;
//     await _new;
//     await _popular;
//     setState(() {});
//   },
//   );
// }

String popularPetImages(int id) {
  switch (id) {
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
  // }
}

class HomePageMainAction extends StatelessWidget {
  final Color color;
  final String image;
  final String title;
  final String subtitle;
  final Function onPressed;

  HomePageMainAction(
      {this.color, this.image, this.title, this.subtitle, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
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
          title: Text(title,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.primaries[0].shade400)),
          subtitle: Text(subtitle),
          trailing: Icon(Icons.navigate_next),
          onTap: onPressed,
        ),
        Divider(),
      ],
    );
  }
}

// class _CategoryCell extends Material {
//   _CategoryCell({String name, String image, Function onPressed})
//       : super(
//           child: InkWell(
//             onTap: onPressed,
//             child: Column(children: <Widget>[
//               Image.asset(image, scale: 5.5, color: Colors.primaries[0]),
//               SizedBox(
//                 height: 2,
//               ),
//               Text(name,
//                   style: TextStyle(fontSize: 11),
//                   overflow: TextOverflow.ellipsis),
//             ]),
//           ),
//         );
// }
