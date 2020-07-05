import 'package:agent_pet/src/pages/pets-listing/pet-listing_page.dart';
import 'package:agent_pet/src/utils/custom-navigator.dart';
import 'package:flutter/material.dart';
import 'package:agent_pet/src/models/pet-type.dart';
import 'package:agent_pet/src/services/misc-service.dart';
import 'package:agent_pet/src/services/pet-type_service.dart';
import 'package:agent_pet/src/widgets/round-drop-down-button.dart';
import 'package:agent_pet/src/utils/simple-future-builder.dart';
import '../home_page.dart';
import '../pet-relocation/main-pet-relocation.dart';
import '../pets-and-vets_page.dart';

class PetSearchPage extends StatefulWidget {
  @override
  _PetSearchPageState createState() => _PetSearchPageState();
}

class _PetSearchPageState extends State<PetSearchPage>with SingleTickerProviderStateMixin {

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
                  CustomNavigator.navigateTo(context, PetListing(query: value,listing: 3,));
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
            ),

            SliverFillRemaining(
              child: PetAdvancedSearch()
            )
          ],
        ),
      ),
    );
  }
}




class PetAdvancedSearch extends StatefulWidget {
  @override
  _PetAdvancedSearchState createState() => _PetAdvancedSearchState();
}

class _PetAdvancedSearchState extends State<PetAdvancedSearch> {

  int _petFor;
  String _searchType = 'Sell';
  Future _citiesFuture;
  List<String> _cities;
  String _selectedCity;
  var _service = MiscService();
  Future<List<PetType>> _petTypesFuture;
  List<PetType> _petTypes;
  PetType _selectedPetType;
  String petsCount = '';
  Future<List<PetType>> _petBreedsFuture;
  List<PetType> _petBreeds;
  PetType _selectedPetBreed;
  List<String> gender = ['Male','Female'];
  String _gender;
  int _value= 0;


  void radioButtonChanges(int value) {
    setState(() {
      _petFor = value;
      switch (value) {
        case 1:
          _searchType = 'Sell';
          break;
        case 2:
          _searchType = 'Engage';
          break;
        default:

      }
    });
  }
  @override
  void initState() {
    super.initState();
    setState(() {
      _petFor = 1;
    });
    _citiesFuture = _service.getCities().then((e){
      if(this.mounted){
        setState(() {
          _cities = e;
        });
      }

    });
    _service.getPetsCount().then((e){
      if(this.mounted){
        petsCount=e.toString();
      }
    });
    _petTypesFuture = PetTypeService().getAll('pet-types');

    _petTypesFuture.then((data) {
      _petTypes = data;
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
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10,),

                  petsCount.isNotEmpty ? RichText(
                    text: TextSpan(
                        text: '$petsCount Pets ',
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
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      MaterialButton(
                        minWidth: 0,
                        color: _value == 0 ? Colors.primaries[0] : Colors.grey.shade50,                        child: Row(
                        children: <Widget>[
                          CircleAvatar(maxRadius: 16,backgroundColor: Colors.white,child: Image.asset("assets/icons/buy-sell-icon.png",scale:2,color: _value == 0 ? Colors.primaries[0] : Colors.grey.shade800,),),

                          Padding(
                            padding: const EdgeInsets.only(left:5.0),
                            child: Text('Buy',style: TextStyle(color: _value == 0 ? Colors.white : Colors.grey.shade800,),),
                          ),
                        ],
                      ),
                        onPressed: (){
                          setState(() {
                            _value=0;
                            _searchType='Sell';
                          });
                        },
                      ),

                      SizedBox(width: 20),
                      MaterialButton(
                        minWidth: 0,

                        color: _value == 1 ? Colors.primaries[0] : Colors.grey.shade50,                        child: Row(
                          children: <Widget>[
                            CircleAvatar(maxRadius: 16,backgroundColor: Colors.white,child: Image.asset("assets/icons/mate.png",scale:2,color: _value == 1 ? Colors.primaries[0] : Colors.grey.shade800,),),

                            Padding(
                              padding: const EdgeInsets.only(left:5.0),
                              child: Text('Adopt',style: TextStyle(color: _value == 1 ? Colors.white : Colors.grey.shade800,),),
                            ),
                          ],
                        ),
                        onPressed: (){
                            setState(() {
                              _value=1;
                              _searchType='Engage';
                            });
                        },
                      ),
//                      Radio(
//                        groupValue: _petFor,
//                        value: 1,
//                        onChanged: radioButtonChanges,
//                        activeColor: Colors.primaries[0],
//                      ),
//
//                      CircleAvatar(maxRadius: 16,backgroundColor: Colors.white,child: Image.asset("assets/icons/buy-sell-icon.png",scale:2,color: Colors.grey.shade800,),),
//                      Text('Buy'),
//                      Radio(
//                        groupValue: _petFor,
//                        value: 2,
//                        onChanged: radioButtonChanges,
//                        activeColor: Colors.primaries[0],
//                      ),
//                      CircleAvatar(maxRadius: 16,backgroundColor: Colors.white,child:  Image.asset("assets/icons/mate.png",scale:2,color: Colors.grey.shade800,),),
//                      Text('Adopt'),
                    ],
                  ),
                  SizedBox(height: 10,),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RoundDropDownButton<String>(
                      hint: Text("Select City*"),
                      items: _cities == null ? []: _cities.map((city) {
                        return DropdownMenuItem<String>(
                          child: Text(city),
                          value: city,
                        );
                      }).toList(),
                      value: _selectedCity,
                      onChanged: (item) => setState(() { this._selectedCity = item;
                      }),
                    ),
                  ),
                  SizedBox(height: 5,),
                  SimpleFutureBuilder<List<PetType>>.simpler(
                    context: context,
                    future: _petTypesFuture,

                    builder: (AsyncSnapshot<List<PetType>> snapshot) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RoundDropDownButton<PetType>(
                          hint: Text("Pet Type"),
                          items: _petTypes.map((petType) {
                            return DropdownMenuItem<PetType>(
                              child: Text(petType.name),
                              value: petType,
                            );
                          }).toList(),
                          value: _selectedPetType,

                          onChanged: (item) => setState(() {

                            this._selectedPetType = item;
                            this._petBreeds = null;
                            this._selectedPetBreed = null;

                            this._petBreedsFuture = PetTypeService().getAll('pet-breeds/${item.id}');
                            this._petBreedsFuture.then((data) {
                              setState(() => this._petBreeds = data);
                            });
                          }),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RoundDropDownButton<PetType>(
                      hint: Text("Pet Breed"),
                      items: _petBreeds == null? []: _petBreeds.map((breed) {
                        return DropdownMenuItem<PetType>(
                          child: Text(breed.name),
                          value: breed,
                        );
                      }).toList(),
                      value: _selectedPetBreed,
                      onChanged: (item) => setState(() { this._selectedPetBreed = item;
                      FocusScope.of(context).requestFocus(new FocusNode());
                      }),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RoundDropDownButton<String>(
                      hint: Text("Gender"),
                      items: gender
                          .map((i) => DropdownMenuItem<String>(
                          child: Text(i), value: i))
                          .toList(),
                      value: _gender,
                      onChanged: (item) => setState(() { this._gender = item;
                      FocusScope.of(context).requestFocus(new FocusNode());
                      }),
                    ),
                  ),

                  RaisedButton(
                    color: Colors.primaries[0],
                    shape: StadiumBorder(),
                    onPressed: (){
                      StringBuffer buffer = StringBuffer('');
                      buffer.write('pet-list?');
                      buffer.write('city=');
                      buffer.write(Uri.encodeQueryComponent(_selectedCity!=null ? _selectedCity : ''));
                      buffer.write('&pet=');
                      buffer.write(Uri.encodeQueryComponent(_selectedPetType!=null ? _selectedPetType.name : ''));
                      buffer.write('&breed=');
                      buffer.write(Uri.encodeQueryComponent(_selectedPetBreed!=null ? _selectedPetBreed.name : ''));
                      buffer.write('&gender=');
                      buffer.write(Uri.encodeQueryComponent(_gender!=null ? _gender : ''));
                      buffer.write('&pet_for=');
                      buffer.write(Uri.encodeQueryComponent(_searchType));

                      print(buffer.toString());

                      StringBuffer _titleBuffer = StringBuffer('');
                      _gender!=null ? _titleBuffer.write(_gender+ ' ') : null;
                      _selectedPetBreed!=null ? _titleBuffer.write(_selectedPetBreed.name + ' ') : null;
                      _selectedPetType==null ? _titleBuffer.write('Pets ') : _titleBuffer.write(_selectedPetType.name+' ');
                      _searchType=='Engage' ?
                      _titleBuffer.write('For ' + 'Adoption' + ' ') : _titleBuffer.write('For Sale ') ;
                      _selectedCity==null ? _titleBuffer.write('in Pakistan') : _titleBuffer.write('in ' + _selectedCity+' ');
                      CustomNavigator.navigateTo(context, PetListing(listing: 2,
                        query: buffer.toString(),title: _titleBuffer.toString(),));
                    },
                    child: Text("Search"),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//}
//
//class _PetSearchPageState extends State<PetSearchPage>with SingleTickerProviderStateMixin {
//  TabController _tabController;
//
//  var _keyword = TextEditingController();
//
//  @override
//  void initState() {
//    _tabController =TabController(vsync: this,length:2 );
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
//
//
//              actions: <Widget>[
//                SizedBox(width: 20,)
//                ],
//              title: TextFormField(
//                controller: _keyword,
//                cursorColor: Colors.white,
//                style: TextStyle(color: Colors.white),
//                onFieldSubmitted: (value){
//                  CustomNavigator.navigateTo(context, PetListing(query: value,listing: 3,));
//                },
//                autofocus: true,
//                decoration: InputDecoration(
//                  prefixIcon: Icon(Icons.search,color: Colors.white,),
//                  suffixIcon: IconButton(icon: Icon(Icons.clear),color: Colors.white,
//                    onPressed: (){
//                      _keyword.clear();
//                    },),
//                  focusedBorder: UnderlineInputBorder(
//                    borderSide: BorderSide(
//                      color: Colors.white,
//                    ),
//                  ),
//                ),
//                textInputAction: TextInputAction.search,
//              ),
//              bottom: TabBar(tabs: <Widget>[
//                Tab(child: Text("Home")),
//                Tab(child: Text("Advanced Search")),
//
//              ],controller: _tabController,
//                indicator: BoxDecoration(color: Colors.white),
//                unselectedLabelColor: Colors.white,
//                indicatorColor: Colors.primaries[0],
//              labelColor: Colors.black,),
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
//                  ]),                  PetAdvancedSearch(),
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
//class PetAdvancedSearch extends StatefulWidget {
//  @override
//  _PetAdvancedSearchState createState() => _PetAdvancedSearchState();
//}
//
//class _PetAdvancedSearchState extends State<PetAdvancedSearch> {
//
//  int _petFor;
//  String _searchType = 'Sell';
//  Future _citiesFuture;
//  List<String> _cities;
//  String _selectedCity;
//  var _service = MiscService();
//  Future<List<PetType>> _petTypesFuture;
//  List<PetType> _petTypes;
//  PetType _selectedPetType;
//  String petsCount = '';
//  Future<List<PetType>> _petBreedsFuture;
//  List<PetType> _petBreeds;
//  PetType _selectedPetBreed;
//  List<String> gender = ['Male','Female'];
//  String _gender;
//
//
//  void radioButtonChanges(int value) {
//    setState(() {
//      _petFor = value;
//      switch (value) {
//        case 1:
//          _searchType = 'Sell';
//          break;
//        case 2:
//          _searchType = 'Engage';
//          break;
//        default:
//
//      }
//    });
//  }
//  @override
//  void initState() {
//    super.initState();
//    setState(() {
//      _petFor = 1;
//    });
//    _citiesFuture = _service.getCities().then((e){
//      if(this.mounted){
//        setState(() {
//          _cities = e;
//        });
//      }
//
//    });
//    _service.getPetsCount().then((e){
//      if(this.mounted){
//        petsCount=e.toString();
//      }
//    });
//    _petTypesFuture = PetTypeService().getAll('pet-types');
//
//    _petTypesFuture.then((data) {
//      _petTypes = data;
//    });
//
//  }
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
//              child: Column(
//                children: <Widget>[
//                  SizedBox(height: 10,),
//
//                 petsCount.isNotEmpty ? RichText(
//                    text: TextSpan(
//                        text: '$petsCount Pets ',
//                        style: TextStyle(
//                          color: Colors.primaries[0],
//                          fontSize: 25,
//                          fontWeight: FontWeight.bold,
//                        ),
//                        children: <TextSpan>[
//                          TextSpan(
//                            text: 'to choose from',
//                            style: TextStyle(color: Colors.primaries[0], fontSize: 24,fontWeight: FontWeight.normal),
//                          ),
//                        ]),
//                  ): SizedBox(),
//                  SizedBox(height: 10,),
//                  Padding(
//                    padding: const EdgeInsets.all(8.0),
//                    child: RoundDropDownButton<String>(
//                      hint: Text("Select City*"),
//                      items: _cities == null ? []: _cities.map((city) {
//                        return DropdownMenuItem<String>(
//                          child: Text(city),
//                          value: city,
//                        );
//                      }).toList(),
//                      value: _selectedCity,
//                      onChanged: (item) => setState(() { this._selectedCity = item;
//                      }),
//                    ),
//                  ),
//                  SizedBox(height: 5,),
//                  SimpleFutureBuilder<List<PetType>>.simpler(
//                    context: context,
//                    future: _petTypesFuture,
//
//                    builder: (AsyncSnapshot<List<PetType>> snapshot) {
//                      return Padding(
//                        padding: const EdgeInsets.all(8.0),
//                        child: RoundDropDownButton<PetType>(
//                          hint: Text("Pet Type"),
//                          items: _petTypes.map((petType) {
//                            return DropdownMenuItem<PetType>(
//                              child: Text(petType.name),
//                              value: petType,
//                            );
//                          }).toList(),
//                          value: _selectedPetType,
//
//                          onChanged: (item) => setState(() {
//
//                            this._selectedPetType = item;
//                            this._petBreeds = null;
//                            this._selectedPetBreed = null;
//
//                            this._petBreedsFuture = PetTypeService().getAll('pet-breeds/${item.id}');
//                            this._petBreedsFuture.then((data) {
//                              setState(() => this._petBreeds = data);
//                            });
//                          }),
//                        ),
//                      );
//                    },
//                  ),
//                  SizedBox(height: 10),
//                  Padding(
//                    padding: const EdgeInsets.all(8.0),
//                    child: RoundDropDownButton<PetType>(
//                      hint: Text("Pet Breed"),
//                      items: _petBreeds == null? []: _petBreeds.map((breed) {
//                        return DropdownMenuItem<PetType>(
//                          child: Text(breed.name),
//                          value: breed,
//                        );
//                      }).toList(),
//                      value: _selectedPetBreed,
//                      onChanged: (item) => setState(() { this._selectedPetBreed = item;
//                      FocusScope.of(context).requestFocus(new FocusNode());
//                      }),
//                    ),
//                  ),
//                  SizedBox(height: 10),
//                  Padding(
//                    padding: const EdgeInsets.all(8.0),
//                    child: RoundDropDownButton<String>(
//                      hint: Text("Gender"),
//                      items: gender
//                          .map((i) => DropdownMenuItem<String>(
//                          child: Text(i), value: i))
//                          .toList(),
//                      value: _gender,
//                      onChanged: (item) => setState(() { this._gender = item;
//                      FocusScope.of(context).requestFocus(new FocusNode());
//                      }),
//                    ),
//                  ),
//                  Row(
//                    mainAxisAlignment: MainAxisAlignment.center,
//                    children: <Widget>[
//
//                      Radio(
//                        groupValue: _petFor,
//                        value: 1,
//                        onChanged: radioButtonChanges,
//                        activeColor: Colors.primaries[0],
//                      ),
//
//                      Text('Buy'),
//                      Radio(
//                        groupValue: _petFor,
//                        value: 2,
//                        onChanged: radioButtonChanges,
//                        activeColor: Colors.primaries[0],
//                      ),
//                      Text('Engage'),
//                    ],
//                  ),
//                  RaisedButton(
//                    color: Colors.primaries[0],
//                    shape: StadiumBorder(),
//                    onPressed: (){
//                      StringBuffer buffer = StringBuffer('');
//                      buffer.write('pet-list?');
//                      buffer.write('city=');
//                      buffer.write(Uri.encodeQueryComponent(_selectedCity!=null ? _selectedCity : ''));
//                      buffer.write('&pet=');
//                      buffer.write(Uri.encodeQueryComponent(_selectedPetType!=null ? _selectedPetType.name : ''));
//                      buffer.write('&breed=');
//                      buffer.write(Uri.encodeQueryComponent(_selectedPetBreed!=null ? _selectedPetBreed.name : ''));
//                      buffer.write('&gender=');
//                      buffer.write(Uri.encodeQueryComponent(_gender!=null ? _gender : ''));
//                      buffer.write('&pet_for=');
//                      buffer.write(Uri.encodeQueryComponent(_searchType));
//
//                      print(buffer.toString());
//
//                      StringBuffer _titleBuffer = StringBuffer('');
//                      _gender!=null ? _titleBuffer.write(_gender+ ' ') : null;
//                      _selectedPetBreed!=null ? _titleBuffer.write(_selectedPetBreed.name + ' ') : null;
//                      _selectedPetType==null ? _titleBuffer.write('Pets ') : _titleBuffer.write(_selectedPetType.name+' ');
//                      _searchType=='Engage' ?
//                      _titleBuffer.write('For ' + _searchType + ' ') : _titleBuffer.write('For Sale ') ;
//                      _selectedCity==null ? _titleBuffer.write('in Pakistan') : _titleBuffer.write('in ' + _selectedCity+' ');
//                      CustomNavigator.navigateTo(context, PetListing(listing: 2,
//                          query: buffer.toString(),title: _titleBuffer.toString(),));
//                    },
//                    child: Text("Search"),
//                  )
//                ],
//              ),
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//}
//
