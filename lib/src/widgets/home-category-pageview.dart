import 'package:agent_pet/src/pages/pets-listing/pet-listing_page.dart';
import 'package:agent_pet/src/pages/products-listing/product-listing_page.dart';
import 'package:agent_pet/src/utils/custom-navigator.dart';
import 'package:agent_pet/src/widgets/tab-view-indexed.dart';
import 'package:flutter/material.dart';

import 'dots-indicator.dart';

//


class HomeCategoriesView extends StatefulWidget {
  @override
  _HomeCategoriesViewState createState() => _HomeCategoriesViewState();
}

class _HomeCategoriesViewState extends State<HomeCategoriesView> with TickerProviderStateMixin {

  TabController _controller;
  PageController _petViewController = PageController();
  PageController _foodViewController = PageController();
  PageController _accessoryViewController = PageController();
  int _currentIndex=0;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 3, vsync: this)..addListener((){
      setState(() {
        _currentIndex = _controller.index;
      });
    });

  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: TabBar(
            isScrollable: true,
            labelPadding: EdgeInsets.symmetric(horizontal: 5),
            indicatorSize: TabBarIndicatorSize.label,
            unselectedLabelColor: Colors.grey.shade600,
            labelColor: Colors.primaries[0],
            labelStyle: TextStyle(fontSize: 16),
            indicatorColor: Colors.primaries[0],
            controller: _controller,
            tabs: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Pets",),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Foods",),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Accessories",),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 200,
          child: Padding(
            padding: const EdgeInsets.only(top:20.0),
            child: TabViewIndexed(
              controller: _controller,
              views: <Widget>[
                tabView(_petViewController,_controller.index),
                tabView(_foodViewController,_controller.index),
                tabView(_accessoryViewController,_controller.index),
              ],
            ),
          ),
        ),

      ],
    );
  }

  Widget tabView(PageController controller, int tabIndex){
    return  Stack(
      children: <Widget>[
        PageView(
          controller: controller,
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            Table(children: <TableRow>[

              TableRow(children: <Widget>[
                _CategoryCell(image: 'assets/icons/dog.png', name: 'Dog', onPressed: () {

                  CustomNavigator.navigateTo(context, tabIndex == 0 ?
                  PetListing(petTypeId: 2,petName: 'Dogs',) :
                  ProductListing(listing: 10,petName: "Dog",category: tabIndex == 1 ?  "pet-food" : 'pet-accessories',
                  petTypeId: 2,)
                  );

                }),
                _CategoryCell(image: 'assets/icons/cat.png', name: 'Cat', onPressed: () {

                  CustomNavigator.navigateTo(context, tabIndex == 0 ?
                  PetListing(petTypeId: 1,petName: 'Cats',) :
                  ProductListing(listing: 10,petTypeId: 1,petName: 'Cats',category: tabIndex == 1 ?  "pet-food" : 'pet-accessories',)
                  );

                }),
                _CategoryCell(image: 'assets/icons/bird.png', name: 'Bird', onPressed: () {
                  CustomNavigator.navigateTo(context, tabIndex == 0 ?
                  PetListing(petTypeId: 6,petName: 'Birds',) :
                  ProductListing(listing: 10,petTypeId: 6,petName: 'Bird',category: tabIndex == 1 ?  "pet-food" : 'pet-accessories',)
                  );
                }),
                _CategoryCell(image: 'assets/icons/fish.png', name: 'Fish', onPressed: () {
                  CustomNavigator.navigateTo(context, tabIndex == 0 ?
                  PetListing(petTypeId: 3,petName: 'Fish') :
                  ProductListing(listing: 10,petTypeId: 3,petName: 'Fish',category: tabIndex == 1 ?  "pet-food" : 'pet-accessories',)
                  );
                }),

              ]),
              TableRow(
                  children: <Widget>[
                    SizedBox(height: 10,),
                    SizedBox(),
                    SizedBox(),
                    SizedBox(),
                  ]
              ),

              TableRow(children: <Widget>[
                _CategoryCell(image: 'assets/icons/cow.png', name: 'Cow', onPressed: () {
                  CustomNavigator.navigateTo(context, tabIndex == 0 ?
                  PetListing(petTypeId: 5,petName: 'Cows',) :
                  ProductListing(listing: 10,petTypeId: 5, petName: 'Cows',category: tabIndex == 1 ?  "pet-food" : 'pet-accessories',)
                  );

                }),
                _CategoryCell(image: 'assets/icons/lion.png', name: 'Lion', onPressed: () {
                  CustomNavigator.navigateTo(context, tabIndex == 0 ?
                  PetListing(petTypeId: 3879, petName: 'Lions') :
                  ProductListing(listing: 10,petTypeId: 3879, petName: 'Lions',category: tabIndex == 1 ?  "pet-food" : 'pet-accessories',)
                  );

                }),
                _CategoryCell(image: 'assets/icons/rabbit.png', name: 'Rabbit', onPressed: () {
                  CustomNavigator.navigateTo(context, tabIndex == 0 ?
                  PetListing(petTypeId: 13, petName: 'Rabbits',) :
                  ProductListing(listing: 10,petTypeId: 13, petName: 'Rabbits',category: tabIndex == 1 ?  "pet-food" : 'pet-accessories',)
                  );
                }),
                _CategoryCell(image: 'assets/icons/parrot.png', name: 'Parrot', onPressed: () {
                  CustomNavigator.navigateTo(context, tabIndex == 0 ?
                  PetListing(petTypeId: 4, petName: 'Parrots',) :
                  ProductListing(listing: 10,petTypeId: 4, petName: 'Parrot',category: tabIndex == 1 ?  "pet-food" : 'pet-accessories',)
                  );
                }),


              ]),
            ]),


            Table(children: <TableRow>[
              TableRow(children: <Widget>[
                _CategoryCell(image: 'assets/icons/monkey.png', name: 'Monkey', onPressed: () {
                  CustomNavigator.navigateTo(context, tabIndex == 0 ?
                  PetListing(petTypeId: 10, petName: 'Monkeys',) :
                  ProductListing(listing: 10,petTypeId: 10, petName: 'Monkey',category: tabIndex == 1 ?  "pet-food" : 'pet-accessories',)
                  );
                }),
                _CategoryCell(image: 'assets/icons/lizard.png', name: 'Lizard', onPressed: () {
                  CustomNavigator.navigateTo(context, tabIndex == 0 ?
                  PetListing(petTypeId: 15, petName: 'Lizards',) :
                  ProductListing(listing: 10,petTypeId: 15, petName: 'Lizard',category: tabIndex == 1 ?  "pet-food" : 'pet-accessories',)
                  );
                }),
                _CategoryCell(image: 'assets/icons/hamster.png', name: 'Hamsters', onPressed: () {
                  CustomNavigator.navigateTo(context, tabIndex == 0 ?
                  PetListing(petTypeId: 19, petName: 'Hamsters') :
                  ProductListing(listing: 10,petTypeId: 19, petName: 'Hamsters',category: tabIndex == 1 ?  "pet-food" : 'pet-accessories',)
                  );
                }),
                _CategoryCell(image: 'assets/icons/pony.png', name: 'Pony', onPressed: () {
                  CustomNavigator.navigateTo(context, tabIndex == 0 ?
                  PetListing(petTypeId: 12, petName: 'Pony') :
                  ProductListing(listing: 10,petTypeId: 12, petName: 'Pony',category: tabIndex == 1 ?  "pet-food" : 'pet-accessories',)
                  );
                }),

              ]),

              TableRow(
                  children: <Widget>[
                    SizedBox(height: 10,),
                    SizedBox(),
                    SizedBox(),
                    SizedBox(),
                  ]
              ),

              TableRow(children: <Widget>[
                _CategoryCell(image: 'assets/icons/iguana.png', name: 'Iguana', onPressed: () {
                  CustomNavigator.navigateTo(context, tabIndex == 0 ?
                  PetListing(petTypeId: 8, petName: 'Iguana',) :
                  ProductListing(listing: 10,petTypeId: 8, petName: 'Iguana',category: tabIndex == 1 ?  "pet-food" : 'pet-accessories',)
                  );
                }),
                _CategoryCell(image: 'assets/icons/ferret.png', name: 'Ferret', onPressed: () {
                  CustomNavigator.navigateTo(context, tabIndex == 0 ?
                  PetListing(petTypeId: 7, petName: 'Ferret',) :
                  ProductListing(listing: 10,petTypeId: 7, petName: 'Ferret',category: tabIndex == 1 ?  "pet-food" : 'pet-accessories',)
                  );
                }),
                _CategoryCell(image: 'assets/icons/crocodiles.png', name: 'Crocodile', onPressed: () {
                  CustomNavigator.navigateTo(context, tabIndex == 0 ?
                  PetListing(petTypeId: 14, petName: 'Crocodiles',) :
                  ProductListing(listing: 10,petTypeId: 14, petName: 'Crocodiles',category: tabIndex == 1 ?  "pet-food" : 'pet-accessories',)
                  );
                }),
                _CategoryCell(image: 'assets/icons/pig.png', name: 'Pig', onPressed: () {
                  CustomNavigator.navigateTo(context, tabIndex == 0 ?
                  PetListing(petTypeId: 11, petName: 'Pigs',) :
                  ProductListing(listing: 10,petTypeId: 11, petName: 'Pigs',category: tabIndex == 1 ?  "pet-food" : 'pet-accessories',)
                  );
                }),


              ]),

            ]),

            Table(children: <TableRow>[
              TableRow(children: <Widget>[
                _CategoryCell(image: 'assets/icons/pig.png', name: 'Guinea Pig', onPressed: () {
                  CustomNavigator.navigateTo(context, tabIndex == 0 ?
                  PetListing(petTypeId: 3409, petName: 'Guinea Pig',) :
                  ProductListing(listing: 10,petTypeId: 3409, petName: 'Guinea Pig',category: tabIndex == 1 ?  "pet-food" : 'pet-accessories',)
                  );
                }),
                _CategoryCell(image: 'assets/icons/pony.png', name: 'Horse', onPressed: () {
                  CustomNavigator.navigateTo(context, tabIndex == 0 ?
                  PetListing(petTypeId: 9, petName: 'Horse',) :
                  ProductListing(listing: 10,petTypeId: 9, petName: 'Horse',category: tabIndex == 1 ?  "pet-food" : 'pet-accessories',)
                  );
                }),
                _CategoryCell(image: 'assets/icons/snake.png', name: 'Snake', onPressed: () {
                  CustomNavigator.navigateTo(context, tabIndex == 0 ?
                  PetListing(petTypeId: 16, petName: 'Snake',) :
                  ProductListing(listing: 10,petTypeId: 16, petName: 'Snake',category: tabIndex == 1 ?  "pet-food" : 'pet-accessories',)
                  );
                }),
                _CategoryCell(image: 'assets/icons/frog.png', name: 'Frog', onPressed: () {
                  CustomNavigator.navigateTo(context, tabIndex == 0 ?
                  PetListing(petTypeId: 18, petName: 'Frogs',) :
                  ProductListing(listing: 10,petTypeId: 18, petName: 'Frogs',category: tabIndex == 1 ?  "pet-food" : 'pet-accessories',)
                  );
                }),
              ]),
              TableRow(
                  children: <Widget>[
                    SizedBox(height: 10,),
                    SizedBox(),
                    SizedBox(),
                    SizedBox(),
                  ]
              ),
              TableRow(children: <Widget>[
                _CategoryCell(image: 'assets/icons/turtle.png', name: 'Turtle', onPressed: () {
                  CustomNavigator.navigateTo(context, tabIndex == 0 ?
                  PetListing(petTypeId: 17, petName: 'Turtle',) :
                  ProductListing(listing: 10,petTypeId: 17, petName: 'Turtle',category: tabIndex == 1 ?  "pet-food" : 'pet-accessories',)
                  );
                }),
                _CategoryCell(image: 'assets/icons/paw.png', name: 'Other Pets', onPressed: () {
                  CustomNavigator.navigateTo(context, tabIndex == 0 ?
                  PetListing(petTypeId: 3692, petName: 'Other Pets',) :
                  ProductListing(listing: 10,petTypeId: 3692, petName: 'Other Pets',category: tabIndex == 1 ?  "pet-food" : 'pet-accessories',)
                  );
                }),

                SizedBox(),
                SizedBox(),

              ]),
            ]),



          ],
        ),


        Positioned(
            bottom: 00.0,
            left: 0.0,
            top: 150,
            right: 0.0,
            child:  HomeDotsIndicator(
              color: Colors.grey,
              controller: controller,
              itemCount: 3,
              onPageSelected: (int page) {
                controller.animateToPage(
                    page,
                    duration:  Duration(milliseconds: 0),
                    curve: Curves.easeIn
                );
              },
            )),
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
