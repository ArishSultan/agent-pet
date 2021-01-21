import 'dart:async';
import 'package:agent_pet/src/base/assets.dart';
import 'package:agent_pet/src/models/brand.dart';
import 'package:agent_pet/src/models/paginated-product.dart';
import 'package:agent_pet/src/pages/products-listing/product-listing_page.dart';
import 'package:agent_pet/src/services/_service.dart';
import 'package:agent_pet/src/services/brand_service.dart';
import 'package:agent_pet/src/services/paginated-product-service.dart';
import 'package:agent_pet/src/pages/product-detail_page.dart';
import 'package:agent_pet/src/widgets/loading-builder.dart';
import 'package:agent_pet/src/widgets/product-card-widget.dart';
import 'package:agent_pet/src/widgets/sliver-section-header.dart';
import 'package:agent_pet/src/widgets/tab-view-indexed.dart';
import 'package:agent_pet/src/utils/custom-navigator.dart';
import 'package:agent_pet/src/utils/simple-future-builder.dart';
import 'package:agent_pet/src/widgets/view-all-button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'search-pages/pet-search-page.dart';
import 'search-pages/product-search.dart';

class PetStorePage extends StatefulWidget {
  static int _prevCat = 0;
  static int _category = 0;

  static set category(val) {
    _prevCat = _category;
    _category = val;
  }

  static int get category => _category;

  static int get prevCat => _prevCat;

  @override
  _PetStorePageState createState() => _PetStorePageState();
}

class _PetStorePageState extends State<PetStorePage>
    with TickerProviderStateMixin {
  TabController _controller;

  Widget _tab;
  String _count = '';
  String _fAccCount = '';
  String _onSaleCount = '';
  String _title;

  //For listing page
  int _listing = 2;
  int _brandId;
  String _petName = '';
  String _brandName = '';
  String _category = '';
  int petTypeId = 0;

  PaginatedProductService _service;
  Future<List<PaginatedProduct>> _products;
  Future<List<PaginatedProduct>> _featuredAccessories;
  Future<List<PaginatedProduct>> _onSale;

  @override
  void initState() {
    super.initState();

    this._tab = _petStoreTab();
    this._count = '';

    this._title = 'Featured Food';

    this._service = PaginatedProductService();
    this._products =
        _service.getProducts(featured: 'yes', category: 'pet-food');
    this._products.then((val) => _updateCount(val[0].total.toString()));
    this._featuredAccessories =
        _service.getProducts(featured: 'yes', category: 'pet-accessories');
    this._onSale = _service.getProducts(flash: 'yes');
    this._featuredAccessories.then((val) {
      setState(() {
        _fAccCount = val[0].total.toString();
      });
    });
    this._onSale.then((val) {
      setState(() {
        _onSaleCount = val[0].total.toString();
      });
    });

    _controller = TabController(length: 24, vsync: this)
      ..addListener(() {
        FutureOr tabs;
        switch (_controller.index) {
          case 0:
            tabs = _petStoreTab();
            break;
          case 1:
            tabs = SimpleFutureBuilder.simplerSliver(
              future: _brandsTab(),
              builder: (AsyncSnapshot<Widget> snapshot) {
                return snapshot.data;
              },
              context: context,
            );
            break;
          case 2:
            tabs = _petTab('Dog', 2);
            break;
          case 3: // Register Controller;
            tabs = _petTab('Cat', 1);
            break;
          case 4:
            tabs = _petTab('Bird', 6);
            break;
          case 5:
            tabs = _petTab('Fish', 3);
            break;
          case 6:
            tabs = _petTab('Rabbit', 13);
            break;
          case 7:
            tabs = _petTab('Parrot', 4);
            break;
          case 8:
            tabs = _petTab('Cow', 5);
            break;
          case 9:
            tabs = _petTab('Lion', 3879);
            break;
          case 10:
            tabs = _petTab('Monkey', 10);
            break;
          case 11:
            tabs = _petTab('Hamsters', 19);
            break;
          case 12:
            tabs = _petTab('Lizard', 15);
            break;
          case 13:
            tabs = _petTab('Pony', 12);
            break;
          case 14:
            tabs = _petTab('Iguana', 8);
            break;
          case 15:
            tabs = _petTab('Ferret', 7);
            break;
          case 16:
            tabs = _petTab('Crocodile', 14);
            break;
          case 17:
            tabs = _petTab('Pig', 3409);
            break;
          case 18:
            tabs = _petTab('Horse', 9);
            break;
          case 19:
            tabs = _petTab('Snake', 16);
            break;
          case 20:
            tabs = _petTab('Frog', 18);
            break;
          case 21:
            tabs = _petTab('Turtle', 17);
            break;
          case 22:
            tabs = _petTab('Guinea Pig', 3409);
            break;
          case 23:
            tabs = _petTab('Other Pets', 3692);
            break;
        }
        if (tabs != null) setState(() => this._tab = tabs);
      });

    CustomNavigator.registerPetStoreRouter(this._controller);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: CustomScrollView(slivers: <Widget>[
          SliverToBoxAdapter(
            child: Container(
              color: Colors.primaries[0],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    CustomNavigator.navigateTo(context, ProductSearchPage());
                  },
                  child: Container(
                    height: 48.0,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 8),
                          child: Icon(
                            Icons.search,
                            size: 22,
                          ),
                        ),
                        Text(
                          "Search",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 100,
                child: Card(
                  child: Column(
                    children: <Widget>[
                      TabBar(
                          tabs: <Widget>[
                            tabBarButton(
                                index: 0,
                                icon: CupertinoIcons.cart,
                                title: 'PET STORE',
                                petTypeId: 0),
                            tabBarButton(
                                index: 1,
                                image: Assets.shopByBrand,
                                title: 'SHOP BY BRANDS',
                                petTypeId: 0),
                            tabBarButton(
                                index: 2,
                                image: Assets.dog,
                                title: 'DOG',
                                petTypeId: 2),
                            tabBarButton(
                                index: 3,
                                image: Assets.cat,
                                title: 'CAT',
                                petTypeId: 1),
                            tabBarButton(
                                index: 4,
                                image: Assets.bird,
                                title: 'BIRD',
                                petTypeId: 6),
                            tabBarButton(
                                index: 5,
                                image: Assets.fish,
                                title: 'FISH',
                                petTypeId: 3),
                            tabBarButton(
                                index: 6,
                                image: Assets.rabbit,
                                title: 'Rabbit',
                                petTypeId: 13),
                            tabBarButton(
                                index: 7,
                                image: Assets.parrot,
                                title: 'Parrot',
                                petTypeId: 4),
                            tabBarButton(
                                index: 8,
                                image: Assets.cow,
                                title: 'Cow',
                                petTypeId: 5),
                            tabBarButton(
                                index: 9,
                                image: Assets.lion,
                                title: 'Lion',
                                petTypeId: 3879),
                            tabBarButton(
                                index: 10,
                                image: Assets.monkey,
                                title: 'Monkey',
                                petTypeId: 10),
                            tabBarButton(
                                index: 11,
                                image: Assets.hamster,
                                title: 'Hamsters',
                                petTypeId: 19),
                            tabBarButton(
                                index: 12,
                                image: Assets.lizard,
                                title: 'Lizard',
                                petTypeId: 15),
                            tabBarButton(
                                index: 13,
                                image: Assets.pony,
                                title: 'Pony',
                                petTypeId: 12),
                            tabBarButton(
                                index: 14,
                                image: Assets.iguana,
                                title: 'Iguana',
                                petTypeId: 8),
                            tabBarButton(
                                index: 15,
                                image: Assets.ferret,
                                title: 'Ferret',
                                petTypeId: 7),
                            tabBarButton(
                                index: 16,
                                image: Assets.crocodile,
                                title: 'Crocodile',
                                petTypeId: 14),
                            tabBarButton(
                                index: 17,
                                image: Assets.pig,
                                title: 'Pig',
                                petTypeId: 3409),
                            tabBarButton(
                                index: 18,
                                image: Assets.horse,
                                title: 'Horse',
                                petTypeId: 9),
                            tabBarButton(
                                index: 19,
                                image: Assets.snake,
                                title: 'Snake',
                                petTypeId: 16),
                            tabBarButton(
                                index: 20,
                                image: Assets.frog,
                                title: 'Frog',
                                petTypeId: 18),
                            tabBarButton(
                                index: 21,
                                image: Assets.turtle,
                                title: 'Turtle',
                                petTypeId: 17),
                            tabBarButton(
                                index: 22,
                                image: Assets.pig,
                                title: 'Guinea Pig',
                                petTypeId: 3409),
                            tabBarButton(
                                index: 23,
                                icon: CupertinoIcons.paw,
                                title: 'Other Pet',
                                petTypeId: 3692),
                          ],
                          indicatorColor: Colors.primaries[0],
                          controller: _controller,
                          isScrollable: true),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                              children:
                                  List.generate(_controller.length, (val) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 3),
                                  child: Container(
                                    width: 5,
                                    height: 5,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(2.5),
                                      color: val == _controller.index
                                          ? Colors.primaries[0]
                                          : Colors.grey.shade300,
                                    ),
                                  ),
                                );
                              }),
                              mainAxisAlignment: MainAxisAlignment.center),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          _tab,
          SliverToBoxAdapter(
            child: Container(
              color: Colors.grey.shade200,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      fit: FlexFit.tight,
                      child: Text(
                        this._count + this._title,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
//                    Spacer(),
                    viewAllBtn(onPressed: () {
                      CustomNavigator.navigateTo(
                          context,
                          ProductListing(
                            listing: _listing,
                            petTypeId: petTypeId,
                            petName: _petName,
                            category: _category,
                            brandId: _brandId,
                            title: _brandName,
                          ));
                    })
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Container(
                color: Colors.white,
                height: 230,
                child: SimpleFutureBuilder<List<PaginatedProduct>>.simpler(
                  future: this._products,
                  context: context,
                  builder: (AsyncSnapshot<List<PaginatedProduct>> snapshot) {
                    var products = snapshot.data[0].product;
                    return products.isNotEmpty
                        ? ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: products.length,
                            itemBuilder: (context, i) {
                              return ProductCard(
                                product: products[i],
                              );
                            },
                          )
                        : Center(
                            child: Text(
                                "No Food or Accessories in this category."),
                          );
                  },
                ),
              ),
            ),
          ),
          SliverSectionHeader(this._fAccCount + ' Featured Accessories',
              viewAllBtn(onPressed: () {
            CustomNavigator.navigateTo(context, ProductListing(listing: 6));
          })),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Container(
                color: Colors.white,
                height: 230,
                child: SimpleFutureBuilder<List<PaginatedProduct>>.simpler(
                  future: this._featuredAccessories,
                  context: context,
                  builder: (AsyncSnapshot<List<PaginatedProduct>> snapshot) {
                    var products = snapshot.data[0].product;
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: products.length,
                      itemBuilder: (context, i) {
                        return Material(
                          child: InkWell(
                            onTap: () {
                              CustomNavigator.navigateTo(context,
                                  ProductDetailPage(product: products[i]));
                            },
                            child: ProductCard(
                              product: products[i],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
          SliverSectionHeader(this._onSaleCount + ' Products On Sale',
              viewAllBtn(onPressed: () {
            CustomNavigator.navigateTo(
                context,
                ProductListing(
                  listing: 1,
                ));
          })),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Container(
                color: Colors.white,
                height: 230,
                child: SimpleFutureBuilder<List<PaginatedProduct>>.simpler(
                  future: this._onSale,
                  context: context,
                  builder: (AsyncSnapshot<List<PaginatedProduct>> snapshot) {
                    var products = snapshot.data[0].product;
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: products.length,
                      itemBuilder: (context, i) {
                        return Material(
                          child: InkWell(
                            onTap: () {
                              CustomNavigator.navigateTo(context,
                                  ProductDetailPage(product: products[i]));
                            },
                            child: ProductCard(
                              product: products[i],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }

  Widget _petStoreTab() {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(15, 8, 15, 17),
      sliver: SliverToBoxAdapter(
        child: Table(
          children: <TableRow>[
            TableRow(children: <Widget>[
              _buildIcon(Assets.newIcon, 'New Arrivals', () {
                CustomNavigator.navigateTo(context, ProductListing(listing: 0));
//                _listing=0;
//                setState(() {
//                  this._count = '';
//                  this._title = 'New Arrivals';
//                  this._products =  this._service.getProducts();
//                  this._products.then((val) => _updateCount(val[0].total.toString()));
//                });
//
              }),
              _buildIcon(Assets.popular, 'Popular Products', () {
                CustomNavigator.navigateTo(context, ProductListing(listing: 7));

//                _listing=7;
//                setState(() {
//                  this._count = '';
//                  this._title = 'Popular Products';
//                  this._products =  this._service.getProducts(popular: 'yes');
//                  this._products.then((val) => _updateCount(val[0].total.toString()));
//
//                });
              }),
            ]),
            TableRow(children: <Widget>[
              _buildIcon(Assets.bowl, 'Featured Food', () {
                CustomNavigator.navigateTo(context, ProductListing(listing: 5));
//                _listing=5;
//                setState(() {
//                  this._count = '';
//                  this._title = 'Featured Pet Food';
//                  this._products =  this._service.getProducts(category: 'pet-food',featured: 'yes');
//                  this._products.then((val) => _updateCount(val[0].total.toString()));
//                });
              }),
              _buildIcon(Assets.collar, 'Featured Accessories', () {
                CustomNavigator.navigateTo(context, ProductListing(listing: 6));
//                _listing=6;
//                setState(() {
//                  this._count = '';
//                  this._title = 'Featured Pet Accessories';
//                  this._products =  this._service.getProducts(category: 'pet-accessories',featured: 'yes');
//                  this._products.then((val) => _updateCount(val[0].total.toString()));
//                });
              }),
            ]),
            TableRow(children: <Widget>[
              _buildIcon(Assets.bowl, 'Pet Food', () {
                CustomNavigator.navigateTo(context, ProductListing(listing: 3));

//                _listing=3;
//                setState(() {
//                  this._count = '';
//                  this._title = 'Pet Food';
//                  this._products =  this._service.getProducts(category: 'pet-food');
//                  this._products.then((val) => _updateCount(val[0].total.toString()));
//                });
              }),
              _buildIcon(Assets.collar, 'Pet Accessories', () {
                CustomNavigator.navigateTo(context, ProductListing(listing: 4));

//                _listing=4;
//                setState(() {
//                  this._count = '';
//                  this._title = 'Pet Accessories';
//                  this._products =  this._service.getProducts(category: 'pet-accessories');
//                  this._products.then((val) => _updateCount(val[0].total.toString()));
//                });
              }),
            ]),
            TableRow(children: <Widget>[
              _buildIcon(Assets.shopByBrand, 'Brands', () {
                CustomNavigator.baseNavigateTo(1, 1, 0);
              }),
              _buildIcon(Assets.featured, 'Featured Products', () {
                CustomNavigator.navigateTo(context, ProductListing(listing: 2));

//                _listing=2;
//                setState(() {
//                  this._count = '';
//                  this._title = 'Featured Products';
//                  this._products =  this._service.getProducts(featured: 'yes');
//                  this._products.then((val) => _updateCount(val[0].total.toString()));
//                });
              }),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _petTab(String name, int typeId) {
    setState(() {
      if (PetStorePage.category == 1) {
        _listing = 10;
        _petName = '$name';
        _category = 'pet-food';
        setState(() {
          this._count = '';
          this._title = '$name Food to Buy';
          this._products =
              this._service.getProducts(type: typeId, category: 'pet-food');
          this._products.then((val) {
            setState(() {
              this._count = val[0].total.toString() + ' ';
            });
          });
        });
      } else if (PetStorePage.category == 2) {
        _listing = 10;
        _petName = '$name';
        _category = 'pet-accessories';
        setState(() {
          this._count = '';
          this._title = '$name Accessories to Buy';
          this._products = this
              ._service
              .getProducts(type: typeId, category: 'pet-accessories');
          this._products.then((val) {
            setState(() {
              this._count = val[0].total.toString() + ' ';
            });
          });
        });
      } else {
        _listing = 10;
        _petName = '$name';
        petTypeId = petTypeId;
        _category = '';
        setState(() {
          this._count = '';
          this._title = '$name Food and Accessories to Buy';
          this._products = this._service.getProducts(type: typeId);
          this._products.then((val) {
            setState(() {
              this._count = val[0].total.toString() + ' ';
            });
          });
        });
      }
    });

//    PetStorePage.category = 0;

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(15, 8, 15, 17),
      sliver: SliverToBoxAdapter(
        child: Table(
          children: <TableRow>[
            TableRow(children: <Widget>[
              _buildIcon(Assets.bowl, '$name Food', () {
                CustomNavigator.navigateTo(
                    context,
                    ProductListing(
                      listing: 10,
                      petName: name,
                      category: 'pet-food',
                      petTypeId: typeId,
                    ));

//                _category = 'pet-food';
//                setState(() {
//                  this._count = '';
//                  this._title = '$name Food to Buy';
//                  this._products =  this._service.getProducts(type: name,category: 'pet-food');
//                  this._products.then((val){
//                    setState(() {
//                      this._count = val[0].total.toString() + ' ';
//                    });
//                  });
//                }
//                  );
              }),
              _buildIcon(Assets.collar, '$name Accessories', () {
                CustomNavigator.navigateTo(
                    context,
                    ProductListing(
                      listing: 10,
                      petName: name,
                      category: 'pet-accessories',
                      petTypeId: typeId,
                    ));

//                _category = 'pet-accessories';
//                setState(() {
//                  this._count='';
//                  this._title = '$name Accessories to Buy';
//                  this._products =  this._service.getProducts(type: name,category: 'pet-accessories');
//                  this._products.then((val){
//                    setState(() {
//                      this._count = val[0].total.toString() + ' ';
//                    });
//                  }
//                  );});
              }),
            ]),
          ],
        ),
      ),
    );
  }

  Future<Widget> _brandsTab() async {
    List<Brand> brands = await BrandsService().getAll('brands');

    List<List<Brand>> dividedBrands = <List<Brand>>[];

    var temp = <Brand>[];
    for (int i = 1; i < brands.length; ++i) {
      temp.add(brands[i - 1]);

      if (i % 12 == 0) {
        dividedBrands.add(temp);
        temp = <Brand>[];
      }
    }

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(15, 8, 15, 17),
      sliver: SliverToBoxAdapter(
        child: Container(
          height: 200,
          child: TabViewIndexed(
            indicator: true,
            views: dividedBrands.map((list) {
              return GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 30,
                childAspectRatio: 6.3,
                children: list
                    .map((item) => Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: InkWell(
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Center(
                                        child: Container(
                                            child: Image.network(
                                      Service.getConvertedImageUrl(item.image),
                                      loadingBuilder: circularImageLoader,
                                      height: 100,
                                      width: 50,
                                      fit: BoxFit.cover,
                                    ))),
                                  )),
                              onTap: () {
                                CustomNavigator.navigateTo(
                                    context,
                                    ProductListing(
                                        listing: 9,
                                        brandId: item.id,
                                        title: item.name));
//                    _listing=9;
//                    _brandId=item.id;
//                    _brandName = item.name;
//                    setState(() {
//                      this._count = '';
//                      this._title = ' Products to Buy By ' + item.name;
//                      this._products =  this._service.getProducts(brandId: item.id);
//                      this._products.then((val){
//                        setState(() {
//                          this._count = val[0].total.toString() + ' ';
//                        });
//                      }
//                      );
//                    });
                              }),
                        ))
                    .toList(), //list.map((item) => Text(item)).toList(),
              );
            }).toList(),
            controller:
                TabController(length: dividedBrands.length, vsync: this),
          ),
        ),
      ),
    );
  }

  _updateCount(count) {
    setState(() => this._count = count + ' ');
  }

  _buildIcon(String image, String label, Function onPressed) {
    return InkWell(
        child: Row(children: <Widget>[
          Image.asset(image, color: Colors.grey, width: 20),
          SizedBox(width: 10, height: 30),
          Text(label, style: TextStyle(color: Colors.grey))
        ]),
        onTap: onPressed);
  }

  Widget tabBarButton(
      {int index, IconData icon, String image, String title, int petTypeId}) {
    return GestureDetector(
        onTap: () {
          if (index != 0 | 1) {
            _listing = 10;
            _petName = title;
            this.petTypeId = petTypeId;
            _category = '';
          }
          CustomNavigator.baseNavigateTo(1, index, 0);
        },
        child: AbsorbPointer(
          child: Tab(
//        iconMargin: EdgeInsets.zero,
              icon: SizedBox(
                  width: 45,
                  child: icon != null
                      ? Icon(icon, color: Theme.of(context).primaryColor, size: 43,)
                      : Image.asset(image, color: Colors.primaries[0])),
              child: Text(title,
                  style: TextStyle(fontSize: 9, color: Colors.black))),
        ));
  }
}
