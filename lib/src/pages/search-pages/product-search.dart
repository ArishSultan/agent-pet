import 'package:agent_pet/src/pages/pets-listing/pet-listing_page.dart';
import 'package:agent_pet/src/utils/custom-navigator.dart';
import 'package:agent_pet/src/widgets/section-header.dart';
import 'package:flutter/material.dart';
import 'package:agent_pet/src/models/pet-type.dart';
import 'package:agent_pet/src/services/misc-service.dart';
import 'package:agent_pet/src/services/pet-type_service.dart';
import 'package:agent_pet/src/widgets/round-drop-down-button.dart';
import 'package:agent_pet/src/utils/simple-future-builder.dart';
import '../home_page.dart';
import '../pet-relocation/main-pet-relocation.dart';
import '../pets-and-vets_page.dart';
import '../products-listing/product-listing_page.dart';

class ProductSearchPage extends StatefulWidget {
  @override
  _ProductSearchPageState createState() => _ProductSearchPageState();
}

class _ProductSearchPageState extends State<ProductSearchPage>with SingleTickerProviderStateMixin {

  var _keyword = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              elevation: 0,
              titleSpacing: 0,
              actions: <Widget>[
                SizedBox(width: 20,)
              ],
              title: TextFormField(
                controller: _keyword,
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.white),
                onFieldSubmitted: (value){
                  CustomNavigator.navigateTo(context, ProductListing(query: value,listing: 11,
                    title: '${_keyword.text} Pet Food and Accessories to Buy',));
                  print(value);
                },
                autofocus: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search,color: Colors.white,),
                  suffixIcon: IconButton(icon: Icon(Icons.clear),color: Colors.white,
                    onPressed: (){
                      _keyword.clear();

                    },),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                ),
                textInputAction: TextInputAction.search,
              ),

//              backgroundColor: Colors.white,

            ),

            SliverFillRemaining(
              child: ProductAdvancedSearch()
            )
          ],
        ),
      ),
    );
  }
}




class ProductAdvancedSearch extends StatefulWidget {
  @override
  _ProductAdvancedSearchState createState() => _ProductAdvancedSearchState();
}

class _ProductAdvancedSearchState extends State<ProductAdvancedSearch> {


  var _service= MiscService();

  var _searchKeyword = TextEditingController();
  List<String> categories = ['Pet Food','Pet Accessories'];
  String _category;
  double price = 0;
  double _priceMin = 0;
  double _priceMax = 21000;
  RangeValues _values;
  Future<List<PetType>> _petTypesFuture;
  List<PetType> _petTypes;
  PetType selectedPetType;

  String productsCount = '';


  @override
  void initState() {
    super.initState();

    _petTypesFuture = PetTypeService().getAll('pet-types');

    _petTypesFuture.then((data) {
      _petTypes = data;
    });
    _values = RangeValues(_priceMin,_priceMax);
    _service.getMaxProductsPrice().then((e){
      setState(() {
        _priceMax=e;
        _values = RangeValues(_priceMin,_priceMax);
      });
    });


    _service.getProductsCount().then((e){
      if(this.mounted){
        setState(() {
          productsCount =e.toString();
        });
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0.0, 15.0),
                        blurRadius: 15.0),
                    BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0.0, -10.0),
                        blurRadius: 10.0),
                  ]),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    productsCount.isNotEmpty ? RichText(
                      text: TextSpan(
                          text: '$productsCount Products ',
                          style: TextStyle(
                            color: Colors.primaries[0],
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'to choose from',
                              style: TextStyle(color: Colors.primaries[0], fontSize: 24,fontWeight: FontWeight.normal),
                            ),
                          ]),
                    ): SizedBox(),
                    SizedBox(height: 20),
                    TextField(
                      decoration: InputDecoration(
                          suffixIcon: Icon(Icons.search),
                          isDense: true,
                          hintText: 'Product Name',
                          border: OutlineInputBorder()
                      ),
                      controller: _searchKeyword,
                    ),
                    SizedBox(height: 20),
                    SimpleFutureBuilder<List<PetType>>.simpler(
                      context: context,
                      future: _petTypesFuture,

                      builder: (AsyncSnapshot<List<PetType>> snapshot) {
                        return RoundDropDownButton<PetType>(
                          hint: Text("Pet Type"),
                          items: _petTypes.map((petType) {
                            return DropdownMenuItem<PetType>(
                              child: Text(petType.name),
                              value: petType,
                            );
                          }).toList(),
                          value: selectedPetType,

                          onChanged: (item) => setState(() {
                            this.selectedPetType = item;
                            FocusScope.of(context).requestFocus(new FocusNode());
                          }),
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    RoundDropDownButton<String>(
                      hint: Text("Select Category"),
                      items:  categories.map((i) {
                        return DropdownMenuItem<String>(
                          child: Text(i),
                          value: i,
                        );
                      }).toList(),
                      value: _category,
                      onChanged: (item) => setState(() { this._category = item;
                      FocusScope.of(context).requestFocus(new FocusNode());
                      }),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Price (PKR)', style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),overflow: TextOverflow.ellipsis,),
                    ),
                    RangeSlider(
                        values: _values,
                        min: _priceMin,
                        max: _priceMax,
                        labels: RangeLabels("${_values.start.floor()}","${_values.end.floor()}"),
                        activeColor: Colors.primaries[0],
                        divisions: 100,
                        onChanged: (RangeValues values) {
                          setState(() {
                            if (values.end - values.start >= 20) {
                              _values = values;
                            } else {
                              if (_values.start == values.start) {
                                _values = RangeValues(_values.start, _values.start + 20);
                              } else {
                                _values = RangeValues(_values.end - 20, _values.end);
                              }
                            }
                          });
                        }
                    ),
                    Center(child: Text("From ${_values.start.floor()} to ${_values.end.floor()}")),


                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20,bottom: 20),
                        child: Container(
                          width: 130,
                          child: RaisedButton(
                            shape: StadiumBorder(),
                            child: Text("Search", style: TextStyle(color: Colors.white)),
                            color: Theme.of(context).primaryColor,
                            onPressed: (){
                              var cat = _category!=null ? _category == 'Pet Food' ? 'pet-food' : 'pet-accessories' : null;
                              var catTitle = _category!=null ? _category == 'Pet Food' ? ' Food' : ' Accessories' : null;
                              StringBuffer _title = StringBuffer();
                              _title.write(_searchKeyword.text.isNotEmpty ? _searchKeyword.text + " " : '');
                              _title.write(selectedPetType?.name ??  'Pet');

                              _title.write( catTitle  ??  ' Food and Accessories');
                              _title.write(" To Buy");

                              String priceRange = "price[]=${_values.start.floor()}&price[]=${_values.end.floor()}";

                              CustomNavigator.navigateTo(context, ProductListing(petName: selectedPetType?.name,
                                petTypeId: selectedPetType?.id,
                                query: _searchKeyword.text,
                                category: cat,listing: 11,
                                title: _title.toString(),
                                priceRange: priceRange,));
                            },
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


//import 'package:agent_pet/src/pages/pets-listing/pet-listing_page.dart';
//import 'package:agent_pet/src/utils/custom-navigator.dart';
//import 'package:agent_pet/src/widgets/section-header.dart';
//import 'package:flutter/material.dart';
//import 'package:agent_pet/src/models/pet-type.dart';
//import 'package:agent_pet/src/services/misc-service.dart';
//import 'package:agent_pet/src/services/pet-type_service.dart';
//import 'package:agent_pet/src/widgets/round-drop-down-button.dart';
//import 'package:agent_pet/src/utils/simple-future-builder.dart';
//import 'home_page.dart';
//import 'pet-relocation/main-pet-relocation.dart';
//import 'pets-and-vets_page.dart';
//import 'products-listing/product-listing_page.dart';
//
//class ProductSearchPage extends StatefulWidget {
//  @override
//  _ProductSearchPageState createState() => _ProductSearchPageState();
//}
//
//class _ProductSearchPageState extends State<ProductSearchPage>with SingleTickerProviderStateMixin {
//  TabController _tabController;
//
//  var _keyword = TextEditingController();
//
//  @override
//  void initState() {
//    _tabController =TabController(vsync: this,length:2 );
//
//    super.initState();
//  }
//
//
//  @override
//  Widget build(BuildContext context) {
//    return Material(
//      child: SafeArea(
//        child: CustomScrollView(
//          slivers: <Widget>[
//            SliverAppBar(
//              elevation: 0,
//              titleSpacing: 0,
//              actions: <Widget>[
//                SizedBox(width: 20,)
//              ],
//              title: TextFormField(
//                controller: _keyword,
//                cursorColor: Colors.white,
//                style: TextStyle(color: Colors.white),
//                onFieldSubmitted: (value){
//                  CustomNavigator.navigateTo(context, ProductListing(query: value,listing: 11,
//                  title: '${_keyword.text} Pet Food and Accessories to Buy',));
//                  print(value);
//                },
//                autofocus: true,
//                decoration: InputDecoration(
//                  prefixIcon: Icon(Icons.search,color: Colors.white,),
//                  suffixIcon: IconButton(icon: Icon(Icons.clear),color: Colors.white,
//                  onPressed: (){
//                    _keyword.clear();
//
//                  },),
//                  focusedBorder: UnderlineInputBorder(
//                      borderSide: BorderSide(
//                          color: Colors.white,
//                      ),
//                  ),
//                ),
//                textInputAction: TextInputAction.search,
//              ),
//
////              backgroundColor: Colors.white,
//              bottom: TabBar(tabs: <Widget>[
//                Tab(child: Text("Home")),
//                Tab(child: Text("Advanced Search")
//                ),
//
//              ],controller: _tabController,
//                indicator: BoxDecoration(color: Colors.white),
//                labelColor: Colors.black,
//                unselectedLabelColor: Colors.white,
//
//              ),
//            ),
//
//            SliverFillRemaining(
//              child: TabBarView(
//                controller: _tabController,
//                children: <Widget>[
//                  Column(children: <Widget>[
//                    Divider(),
//                    HomePageMainAction(
//                      subtitle: 'Buy & Sell Pets Online In Pakistan.',
//                      color: Color(0xfffd4245),
//                      image: 'assets/icons/buy-sell-icon.png',
//                      title: 'Pet Buy/Sell',
//                      onPressed: (){
//                        CustomNavigator.navigateTo(context, PetListing(listing: 0,));
//                      },
//                    ),
//                    HomePageMainAction(
//                      subtitle: 'Find pets for adoption and match making in Pakistan.',
//                      color:  Color(0xfff8a135),
//                      image: 'assets/icons/mate.png',
//                      title: 'Pet Adoption / Match Making',
//                      onPressed: (){
//                        CustomNavigator.navigateTo(context, PetListing(listing: 1,));
//                      },
//                    ),
//
//                    HomePageMainAction(
//                      subtitle: 'A variety of Animal supplies and pet accessories.',
//                      color: Color(0xff7b43a5),
//                      image: 'assets/icons/pet-store.png',
//                      title: 'Pet Store',
//                      onPressed: () {
//                        Navigator.of(context).pop();
//                        CustomNavigator.baseNavigateTo(1, 0, 0);
//                      },
//                    ),
//                    HomePageMainAction(
//                      subtitle: 'Agent Pet Specializes in relocation of your pet intercity, interstates, import and export for whatever pet you need.',
//                      color: Color(0xff47b5e2),
//                      image: 'assets/icons/plane.png',
//                      title: 'Pet Relocation',
//                      onPressed: (){
//                        CustomNavigator.navigateTo(context, PetRelocationPage());
//                      },
//                    ),
//
//                    HomePageMainAction(
//                      subtitle: 'Find Pet and Vet clinics in your area.',
//                      color: Color(0xfff8a135),
//                      image: 'assets/icons/veterinary.png',
//                      title: 'Pets and Vets',
//                      onPressed: () {
//                        CustomNavigator.navigateTo(context, PetAndVetPage());
//                      },
//                    ),
//
//
//
//
//                  ]),   ProductAdvancedSearch(),
//                ],
//              ),
//            )
//          ],
//        ),
//      ),
//    );
//  }
//}
//
//
//
//
//class ProductAdvancedSearch extends StatefulWidget {
//  @override
//  _ProductAdvancedSearchState createState() => _ProductAdvancedSearchState();
//}
//
//class _ProductAdvancedSearchState extends State<ProductAdvancedSearch> {
//
//
//  var _service= MiscService();
//
//  var _searchKeyword = TextEditingController();
//  List<String> petTypes = ['Dog','Cat','Bird','Fish'];
//  List<String> categories = ['Pet Food','Pet Accessories'];
//  String _type;
//  String _category;
//  double price = 0;
//  double _priceMin = 0;
//  double _priceMax = 0;
//  RangeValues _values;
//  String productsCount = '';
//
//
//  @override
//  void initState() {
//    super.initState();
//    _values = RangeValues(_priceMin,_priceMax);
//    _service.getMaxProductsPrice().then((e){
//      setState(() {
//        _priceMax=e;
//        _values = RangeValues(_priceMin,_priceMax);
//      });
//    });
//    _service.getProductsCount().then((e){
//      if(this.mounted){
//        setState(() {
//          productsCount =e.toString();
//        });
//      }
//    });
//  }
//
//
//
//  @override
//  Widget build(BuildContext context) {
//    return Material(
//      child: Padding(
//        padding: const EdgeInsets.all(8.0),
//        child: Column(
//          children: <Widget>[
//            Container(
//              decoration: BoxDecoration(
//                  color: Colors.white,
//                  borderRadius: BorderRadius.circular(8.0),
//                  boxShadow: [
//                    BoxShadow(
//                        color: Colors.black12,
//                        offset: Offset(0.0, 15.0),
//                        blurRadius: 15.0),
//                    BoxShadow(
//                        color: Colors.black12,
//                        offset: Offset(0.0, -10.0),
//                        blurRadius: 10.0),
//                  ]),
//              child: Padding(
//                padding: const EdgeInsets.all(8.0),
//                child: Column(
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                  children: <Widget>[
//                   productsCount.isNotEmpty ? RichText(
//                      text: TextSpan(
//                          text: '$productsCount Products ',
//                          style: TextStyle(
//                            color: Colors.primaries[0],
//                            fontSize: 25,
//                            fontWeight: FontWeight.bold,
//                          ),
//                          children: <TextSpan>[
//                            TextSpan(
//                              text: 'to choose from',
//                              style: TextStyle(color: Colors.primaries[0], fontSize: 24,fontWeight: FontWeight.normal),
//                            ),
//                          ]),
//                    ): SizedBox(),
//                    SizedBox(height: 20),
//                    TextField(
//                      decoration: InputDecoration(
//                          suffixIcon: Icon(Icons.search),
//                          isDense: true,
//                          hintText: 'Product Name',
//                          border: OutlineInputBorder()
//                      ),
//                      controller: _searchKeyword,
//                    ),
//                    SizedBox(height: 20),
//                    RoundDropDownButton<String>(
//                      hint: Text("Select Pet Type"),
//                      items: petTypes
//                          .map((i) => DropdownMenuItem<String>(
//                          child: Text(i), value: i))
//                          .toList(),
//                      value: _type,
//                      onChanged: (item) => setState(() {
//                        FocusScope.of(context).requestFocus(new FocusNode());
//                        this._type = item;
//                      }),
//                    ),
//                    SizedBox(height: 20),
//                    RoundDropDownButton<String>(
//                      hint: Text("Select Category"),
//                      items:  categories.map((i) {
//                        return DropdownMenuItem<String>(
//                          child: Text(i),
//                          value: i,
//                        );
//                      }).toList(),
//                      value: _category,
//                      onChanged: (item) => setState(() { this._category = item;
//                      FocusScope.of(context).requestFocus(new FocusNode());
//                      }),
//                    ),
//                    SizedBox(height: 10),
//                    Padding(
//                      padding: const EdgeInsets.all(8.0),
//                      child: Text('Price (PKR)', style: TextStyle(
//                        fontSize: 17,
//                        fontWeight: FontWeight.bold,
//                      ),overflow: TextOverflow.ellipsis,),
//                    ),
//                    RangeSlider(
//                        values: _values,
//                        min: _priceMin,
//                        max: _priceMax,
//                        labels: RangeLabels("${_values.start.floor()}","${_values.end.floor()}"),
//                        activeColor: Colors.primaries[0],
//                        divisions: 100,
//                        onChanged: (RangeValues values) {
//                          setState(() {
//                            if (values.end - values.start >= 20) {
//                              _values = values;
//                            } else {
//                              if (_values.start == values.start) {
//                                _values = RangeValues(_values.start, _values.start + 20);
//                              } else {
//                                _values = RangeValues(_values.end - 20, _values.end);
//                              }
//                            }
//                          });
//                        }
//                    ),
//                    Center(child: Text("From ${_values.start.floor()} to ${_values.end.floor()}")),
//
//
//                    Center(
//                      child: Padding(
//                        padding: const EdgeInsets.only(top: 20,bottom: 20),
//                        child: Container(
//                          width: 130,
//                          child: RaisedButton(
//                            shape: StadiumBorder(),
//                            child: Text("Search", style: TextStyle(color: Colors.white)),
//                            color: Theme.of(context).primaryColor,
//                            onPressed: (){
//                              var cat = _category!=null ? _category == 'Pet Food' ? 'pet-food' : 'pet-accessories' : null;
//                              var catTitle = _category!=null ? _category == 'Pet Food' ? ' Food' : ' Accessories' : null;
//                              StringBuffer _title = StringBuffer();
//                              _title.write(_searchKeyword.text.isNotEmpty ? _searchKeyword.text + " " : '');
//                              _title.write(_type ??  'Pet');
//
//
//                              _title.write( catTitle  ??  ' Food and Accessories');
//                              _title.write(" To Buy");
//
//                              String priceRange = "price[]=${_values.start.floor()}&price[]=${_values.end.floor()}";
//
//                              CustomNavigator.navigateTo(context, ProductListing(petName: _type,
//                                query: _searchKeyword.text,
//                                category: cat,listing: 11,
//                                title: _title.toString(),priceRange: priceRange,));
//
//                            },
//                          ),
//                        ),
//                      ),
//                    ),
//
//                  ],
//                ),
//              ),
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//}
//
