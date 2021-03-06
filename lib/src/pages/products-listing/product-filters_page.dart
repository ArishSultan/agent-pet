import 'package:agent_pet/src/models/pet-type.dart';
import 'package:agent_pet/src/pages/pets-listing/pet-listing_page.dart';
import 'package:agent_pet/src/pages/products-listing/product-listing_page.dart';
import 'package:agent_pet/src/services/misc-service.dart';
import 'package:agent_pet/src/services/pet-type_service.dart';
import 'package:agent_pet/src/utils/custom-navigator.dart';
import 'package:agent_pet/src/widgets/round-drop-down-button.dart';
import 'package:agent_pet/src/widgets/section-header.dart';
import 'package:agent_pet/src/utils/simple-future-builder.dart';
import 'package:flutter/material.dart';


class ProductFilters extends StatefulWidget {
  @override
  _ProductFiltersState createState() => _ProductFiltersState();
}

class _ProductFiltersState extends State<ProductFilters> {

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
  }

  var _bold = TextStyle(
      fontWeight: FontWeight.bold
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text("Filter"),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.filter_list),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SectionHeader('Search by Keyword'),
              TextField(
                decoration: InputDecoration(
                    suffixIcon: Icon(Icons.search),
                    isDense: true,
                    hintText: 'Product Name',
                    border: OutlineInputBorder()
                ),
                controller: _searchKeyword,
              ),
              SectionHeader('Product For'),
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

              SectionHeader('Category'),
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
              SectionHeader('Price (PKR)'),
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
                    child: FlatButton(
                      child: Text("Apply Filters", style: TextStyle(color: Colors.white)),
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
//
                      },
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
