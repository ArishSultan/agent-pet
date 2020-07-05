
import 'package:agent_pet/src/models/pets-and-vets-shops.dart';
import 'package:agent_pet/src/services/misc-service.dart';
import 'package:agent_pet/src/services/pets-and-vets-service.dart';
import 'package:agent_pet/src/pages/map-page.dart';
import 'package:agent_pet/src/widgets/icon-text.dart';
import 'package:agent_pet/src/utils/custom-navigator.dart';
import 'package:agent_pet/src/utils/simple-future-builder.dart';
import 'package:agent_pet/src/widgets/round-drop-down-button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PetAndVetPage extends StatefulWidget {

  @override
  _PetAndVetPageState createState() => _PetAndVetPageState();
}

class _PetAndVetPageState extends State<PetAndVetPage> with TickerProviderStateMixin{


  TabController _tabController;
  var  _service = PetsAndVetsService();
  Future _vetClinic;
  Future _petShops;
  Future _citiesFuture;
  List<String> _cities;
  String _selectedCity;
  var _cityService = MiscService();
  var _keyword = TextEditingController();

  void initState() {
    super.initState();
    _citiesFuture = _cityService.getShopCities();
    _citiesFuture.then((e){
      if(this.mounted){
        setState(() {
          _cities = e;
        });
      }
    });
   _petShops = _service.getPetAndVetShops("");
   _vetClinic = _service.getPetAndVetShops("?type2=Vet+Shop");
    _tabController =TabController(vsync: this,length:2 );
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(title: Text("Find Pet & Vet Clinic") ,
          bottom: TabBar(tabs: <Widget>[
            Tab(child: IconText(icon: Icon(Icons.store), text: Text("Pet Shop"), padding: EdgeInsets.only(right: 20))),
            Tab(child: Row(
              children: <Widget>[
                Image.asset("assets/icons/veterinary.png",scale: 3,color: Colors.white,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Vet Clinic"),
                )
              ],
            ), ),
          ],controller: _tabController,) ,
        ),
        body: Column(children: <Widget>[

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _keyword,
                  onFieldSubmitted: (value) async {

                      if(_selectedCity==null){
                        _petShops = _service.getPetAndVetShops("?search_term=${_keyword.text}&city=");
                        _vetClinic = _service.getPetAndVetShops("?search_term=${_keyword.text}&type2=Vet+Shop&city=");
                      }else{
                        _petShops = _service.getPetAndVetShops("?search_term=${_keyword.text}&city=$_selectedCity");
                        _vetClinic = _service.getPetAndVetShops("?search_term=${_keyword.text}&type2=Vet+Shop&city=$_selectedCity");
                      }
                      await _petShops;
                      await _vetClinic;
                      setState(() {

                      });
                      print(_keyword.text);
                      print(_selectedCity);

                  },
                  decoration: InputDecoration(
                    isDense: true,

                    hintText: 'Search',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),

                  ),
                  textInputAction: TextInputAction.search,
                ),
                SizedBox(height: 10,),
                SimpleFutureBuilder.simpler(
                    context: context,
                    future: _citiesFuture,
                    builder: (AsyncSnapshot snapshot) {
                      return RoundDropDownButton<String>(
                        hint: Text("Select City*"),
                        items: _cities.map((city) {
                          return DropdownMenuItem<String>(
                            child: Text(city),
                            value: city,
                          );
                        }).toList(),
                        value: _selectedCity,
                        onChanged: (item) {
                          setState(() {
                            this._selectedCity = item;
                            FocusScope.of(context).requestFocus(
                                new FocusNode());
                          });

                          _petShops = _service.getPetAndVetShops("?city=$item");
                          _vetClinic = _service.getPetAndVetShops("?type2=Vet+Shop&city=$item");

                        }



                      );
                    }
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                   shopTiles(_petShops),
                   shopTiles(_vetClinic),
              ],
            ),
          )
        ]),
    );
  }


  Widget shopTiles(Future future){
    return SimpleFutureBuilder<List<PetsAndVetsShop>>.simpler(
        context: context,
        future: future,
        builder: (AsyncSnapshot<List<PetsAndVetsShop>> snapshot) {
          return ListView.builder(
              itemBuilder:
              (context, i) {
            var _shop = snapshot.data[i];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal:8.0,vertical: 2),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(Icons.pets,size: 15,),
                            SizedBox(width: 10,),
                            Text(_shop.name,style: TextStyle(fontWeight: FontWeight.w500),),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Text(_shop.address),
                      ],
                    ),
                    subtitle: Row(
                      children: <Widget>[
                        Icon(Icons.phone,size: 15,),
                        SizedBox(width: 5,),
                        Text("Phone: ${_shop.phone}"),
                      ],
                    ),
                    dense: true,
                    onTap: (){
                      CustomNavigator.navigateTo(context, MapPage(
                        shopLatLng: LatLng(double.parse(_shop.lat),double.parse(_shop.lng)),
                        shopAddress: _shop.address,
                        shopPhoneNumber: _shop.phone,
                        shopTitle: _shop.name,
                      ));
                    },
                  ),
              ),
            );
          },
              itemCount: snapshot.data.length);

        }
    );
  }
}
