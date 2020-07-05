import 'package:agent_pet/src/models/pet-type.dart';
import 'package:agent_pet/src/pages/pets-listing/pet-listing_page.dart';
import 'package:agent_pet/src/services/misc-service.dart';
import 'package:agent_pet/src/services/pet-type_service.dart';
import 'package:agent_pet/src/utils/custom-navigator.dart';
import 'package:agent_pet/src/widgets/round-drop-down-button.dart';
import 'package:agent_pet/src/widgets/section-header.dart';
import 'package:agent_pet/src/utils/simple-future-builder.dart';
import 'package:flutter/material.dart';


class PetFilters extends StatefulWidget {
  @override
  _PetFiltersState createState() => _PetFiltersState();
}

class _PetFiltersState extends State<PetFilters> {

  var _searchKeyword = TextEditingController();
  List<String> petFor = ['Engage','Sell'];
  Future<List<PetType>> _petTypesFuture;
  List<PetType> _petTypes;
  PetType _selectedPetType;

  Future<List<PetType>> _petBreedsFuture;
  List<PetType> _petBreeds;
  PetType _selectedPetBreed;

  List<String> gender = ['Male','Female','Pair'];
  List<String> colors = ['Black','Brown','Grey','White','Other'];
  List<String> age = ['1','2','3','4','5','Over 5 Years'];
  List<String> group = ['Baby','Young','Adult','Senior'];
  List<String> trainingLevel = ['Has Basic Training','Well Trained'];
  List<String> energyLevel = ['Low','Moderate','High'];
  List<String> groomingLevel = ['Low','Moderate','High','Not Required'];
  String _petFor;
  String _gender;
  String _age;
  String _group;
  String _type;
  String _breed;
  String _trainingLevel='';
  String _energyLevel='';
  String _groomingLevel='';

  Future _citiesFuture;
  List<String> _cities;
  String _selectedCity;

  var _service = MiscService();

  int _colorValue;
  int _temperamentValue;
  int _compatibilityValue;
  int _trainingValue;
  int _energyValue;
  int _groomingValue;
  String _color = '';
  String _temperament;
  String _compatibility = '';
  String _training = '';
  String _energy = '';
  String _grooming = '';
  bool _black = false;
  bool _brown = false;
  bool _grey = false;
  bool _other = false;
  bool _white = false;

  void _colorChanges(int value) {
    setState(() {
      _colorValue = value;
      switch (value) {
        case 1:
          _color = 'Black';
          break;
        case 2:
          _color = 'Brown';
          break;
        case 3:
          _color = 'Grey';
          break;
        case 4:
          _color = 'White';
          break;
        case 5:
          _color = 'Other';
          break;
      }
    });
  }

  void _temperamentChanges(int value) {
    setState(() {
      _temperamentValue = value;
      switch (value) {
        case 1:
          _temperament = 'Protective';
          break;
        case 2:
          _temperament = 'Playful';
          break;
        case 3:
          _temperament = 'Affectionate';
          break;
        case 4:
          _temperament = 'Gentle';
          break;
      }
    });
  }

  void _trainingChanges(int value) {
    setState(() {
      _trainingValue = value;
      switch (value) {
        case 1:
          _training = 'Needs Training';
          break;
        case 2:
          _training = 'Has Basic Training';
          break;
        case 3:
          _training = 'Well Trained';
          break;
      }
    });
  }

  void _compatibilityChanges(int value) {
    setState(() {
      _compatibilityValue = value;
      switch (value) {
        case 1:
          _compatibility = 'Kids';
          break;
        case 2:
          _compatibility = 'Dogs';
          break;
        case 3:
          _compatibility = 'Cats';
          break;
        case 4:
          _compatibility = 'Apartments';
          break;
        case 5:
          _compatibility = 'Seniors';
          break;
      }
    });
  }

  void _energyChanges(int value) {
    setState(() {
      _energyValue = value;
      switch (value) {
        case 1:
          _energy = 'Low';
          break;
        case 2:
          _energy = 'Moderate';
          break;
        case 3:
          _energy = 'High';
          break;
      }
    });
  }

  void _groomingChanges(int value) {
    setState(() {
      _groomingValue = value;
      switch (value) {
        case 1:
          _grooming = 'Low';
          break;
        case 2:
          _grooming = 'Not Required';
          break;
        case 3:
          _grooming = 'Moderate';
          break;
        case 4:
          _grooming = 'High';
          break;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _petTypesFuture = PetTypeService().getAll('pet-types');

    _petTypesFuture.then((data) {
      _petTypes = data;
    });
    _citiesFuture = _service.getCities().then((e){
      setState(() {
        _cities = e;
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
                    hintText: 'Pet Name',
                    border: OutlineInputBorder()
                ),
                controller: _searchKeyword,
              ),
              SectionHeader('Pet'),
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
                    value: _selectedPetType,

                    onChanged: (item) => setState(() {
                      FocusScope.of(context).requestFocus( FocusNode());

                      this._selectedPetType = item;
                      this._petBreeds = null;
                      this._selectedPetBreed = null;

                      this._petBreedsFuture = PetTypeService().getAll('pet-breeds/${item.id}');
                      this._petBreedsFuture.then((data) {
                        setState(() => this._petBreeds = data);
                      });
                    }),
                  );
                },
              ),
              SectionHeader('Pet Breed'),
              RoundDropDownButton<PetType>(
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
              SectionHeader('Pet For'),
              RoundDropDownButton<String>(
                hint: Text("Pet For"),
                items: petFor
                    .map((i) => DropdownMenuItem<String>(
                    child: Text(i), value: i))
                    .toList(),
                value: _petFor,
                onChanged: (item) => setState(() {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  this._petFor = item;
                }),
              ),
              SectionHeader('City'),
              RoundDropDownButton<String>(
                hint: Text("Select City"),
                items: _cities == null ? []: _cities.map((city) {
                  return DropdownMenuItem<String>(
                    child: Text(city),
                    value: city,
                  );
                }).toList(),
                value: _selectedCity,
                onChanged: (item) => setState(() { this._selectedCity = item;
                FocusScope.of(context).requestFocus(new FocusNode());
                }),
              ),
              SectionHeader('Color'),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Radio(
                      groupValue: _colorValue,
                      activeColor: Colors.primaries[0],
                      value: 1,
                      onChanged: _colorChanges,
                    ),
                  ),
                  Text("Black"),
                  Expanded(
                    child: Radio(
                      groupValue: _colorValue,
                      activeColor: Colors.primaries[0],
                      value: 2,
                      onChanged: _colorChanges,
                    ),
                  ),
                  Text("Brown"),
                  Expanded(
                    child: Radio(
                      groupValue: _colorValue,
                      activeColor: Colors.primaries[0],
                      value: 3,
                      onChanged: _colorChanges,
                    ),
                  ),
                  Text("Grey"),
                  Expanded(
                    child: Radio(
                      groupValue: _colorValue,
                      activeColor: Colors.primaries[0],
                      value: 5,
                      onChanged: _colorChanges,
                    ),
                  ),
                  Text("Other"),
                  Expanded(
                    child: Radio(
                      groupValue: _colorValue,
                      activeColor: Colors.primaries[0],
                      value: 4,
                      onChanged: _colorChanges,
                    ),
                  ),
                  Text("White"),

                ],
              ),
              SectionHeader('Gender'),
              RoundDropDownButton<String>(
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
              SectionHeader('Age & Group'),
              Row(
                children: <Widget>[
                  Expanded(
                    child: RoundDropDownButton<String>(
                      hint: Text("Age"),
                      items: age
                          .map((i) => DropdownMenuItem<String>(
                          child: Text(i), value: i))
                          .toList(),
                      value: _age,
                      onChanged: (item) => setState((){ this._age = item;
                      FocusScope.of(context).requestFocus(new FocusNode());
                      }),
                    ),
                  ),
                  SizedBox(width: 2,),
                  Expanded(
                    child: RoundDropDownButton<String>(
                      hint: Text("Group"),
                      items: group
                          .map((i) => DropdownMenuItem<String>(
                          child: Text(i), value: i))
                          .toList(),
                      value: _group,
                      onChanged: (item) => setState(() { this._group = item;
                      FocusScope.of(context).requestFocus(new FocusNode());
                      }),
                    ),
                  ),
                ],
              ),
              Text('Behaviour', style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              )),
              SectionHeader('Temperament'),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Radio(
                      groupValue: _temperamentValue,
                      activeColor: Colors.primaries[0],
                      value: 1,
                      onChanged: _temperamentChanges,
                    ),
                  ),
                  Text("Protective"),
                  Expanded(
                    child: Radio(
                      groupValue: _temperamentValue,
                      activeColor: Colors.primaries[0],
                      value: 2,
                      onChanged: _temperamentChanges,
                    ),
                  ),
                  Text("Playful"),
                  Expanded(
                    child: Radio(
                      groupValue: _temperamentValue,
                      activeColor: Colors.primaries[0],
                      value: 3,
                      onChanged: _temperamentChanges,
                    ),
                  ),
                  Text("Affectionate"),
                  Expanded(
                    child: Radio(
                      groupValue: _temperamentValue,
                      activeColor: Colors.primaries[0],
                      value: 4,
                      onChanged: _temperamentChanges,
                    ),
                  ),
                  Text("Gentle"),
                ],
              ),

              SectionHeader('Compatability: Okay with'),

              Row(
                children: <Widget>[
                  Expanded(
                    child: Radio(
                      groupValue: _compatibilityValue,
                      activeColor: Colors.primaries[0],
                      value: 1,
                      onChanged: _compatibilityChanges,
                    ),
                  ),
                  Text("Kids"),
                  Expanded(
                    child: Radio(
                      groupValue: _compatibilityValue,
                      activeColor: Colors.primaries[0],
                      value: 2,
                      onChanged: _compatibilityChanges,
                    ),
                  ),
                  Text("Dogs"),
                  Expanded(
                    child: Radio(
                      groupValue: _compatibilityValue,
                      activeColor: Colors.primaries[0],
                      value: 3,
                      onChanged: _compatibilityChanges,
                    ),
                  ),
                  Text("Cats"),
                  Expanded(
                    child: Radio(
                      groupValue: _compatibilityValue,
                      activeColor: Colors.primaries[0],
                      value: 4,
                      onChanged: _compatibilityChanges,
                    ),
                  ),
                  Text("Apartments"),
                  Expanded(
                    child: Radio(
                      groupValue: _compatibilityValue,
                      activeColor: Colors.primaries[0],
                      value: 5,
                      onChanged: _compatibilityChanges,
                    ),
                  ),
                  Text("Seniors"),

                ],
              ),

              SectionHeader('Training'),

              Row(
                children: <Widget>[
                  Expanded(
                    child: Radio(
                      groupValue: _trainingValue,
                      activeColor: Colors.primaries[0],
                      value: 1,
                      onChanged: _trainingChanges,
                    ),
                  ),
                  Text("Needs Training"),
                  Expanded(
                    child: Radio(
                      groupValue: _trainingValue,
                      activeColor: Colors.primaries[0],
                      value: 2,
                      onChanged: _trainingChanges,
                    ),
                  ),
                  Text("Has Basic Training"),
                  Expanded(
                    child: Radio(
                      groupValue: _trainingValue,
                      activeColor: Colors.primaries[0],
                      value: 3,
                      onChanged: _trainingChanges,
                    ),
                  ),
                  Text("Well Trained"),

                ],
              ),

              SectionHeader('Energy'),

              Row(
                children: <Widget>[
                   Radio(
                      groupValue: _energyValue,
                      activeColor: Colors.primaries[0],
                      value: 1,
                      onChanged: _energyChanges,
                  ),
                  Text("Low"),
                  Radio(
                      groupValue: _energyValue,
                      activeColor: Colors.primaries[0],
                      value: 2,
                      onChanged: _energyChanges,
                    ),

                  Text("Moderate"),
                   Radio(
                      groupValue: _energyValue,
                      activeColor: Colors.primaries[0],
                      value: 3,
                      onChanged: _energyChanges,
                    ),

                  Text("High"),

                ],
              ),

              SectionHeader('Grooming'),

              Row(
                children: <Widget>[
                  Expanded(
                    child: Radio(
                      groupValue: _groomingValue,
                      activeColor: Colors.primaries[0],
                      value: 1,
                      onChanged: _groomingChanges,
                    ),
                  ),
                  Text("Low"),
                  Expanded(
                    child: Radio(
                      groupValue: _groomingValue,
                      activeColor: Colors.primaries[0],
                      value: 2,
                      onChanged: _groomingChanges,
                    ),
                  ),
                  Text("Not Required"),
                  Expanded(
                    child: Radio(
                      groupValue: _groomingValue,
                      activeColor: Colors.primaries[0],
                      value: 3,
                      onChanged: _groomingChanges,
                    ),
                  ),
                  Text("Moderate"),

                  Expanded(
                    child: Radio(
                      groupValue: _groomingValue,
                      activeColor: Colors.primaries[0],
                      value: 4,
                      onChanged: _groomingChanges,
                    ),
                  ),
                  Text("High"),

                ],
              ),


              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20,bottom: 20),
                  child: Container(
                    width: 130,
                    child: FlatButton(
                      child: Text("Apply Filters", style: TextStyle(color: Colors.white)),
                      color: Theme.of(context).primaryColor,
                      onPressed: (){
                        StringBuffer query = StringBuffer('');
                        query.write('pet-list?');
                        query.write('city=');
                        _selectedCity!=null ? query.write(Uri.encodeQueryComponent(_selectedCity)) :null;
                        query.write('&pet=');
                        _selectedPetType!=null ? query.write(Uri.encodeQueryComponent(_selectedPetType.name)) : null;
                        query.write('&breed=');
                        _selectedPetBreed!=null ? query.write(Uri.encodeQueryComponent(_selectedPetBreed.name)):null;
                        query.write('&gender=');
                        _gender!=null ? query.write(Uri.encodeQueryComponent(_gender)) : null;
                        query.write('&search_term=');
                        query.write(Uri.encodeQueryComponent(_searchKeyword.text));
                        query.write('&color=');
                        query.write(Uri.encodeQueryComponent(_color));
                        query.write('&age=');
                        if(_age!=null){
                          _age==age.last ? query.write(Uri.encodeQueryComponent("6")) :query.write(Uri.encodeQueryComponent(_age));
                        }
                        query.write('&group=');
                        _group!=null ?  query.write(Uri.encodeQueryComponent(_group)) : null;
                        query.write('&pet_for=');
                        _petFor!=null ?  query.write(Uri.encodeQueryComponent(_petFor)) : null;
                        switch(_temperamentValue){
                          case 1:
                            query.write('&protective=');
                            query.write(Uri.encodeQueryComponent("1"));
                            break;
                          case 2:
                            query.write('&playful=');
                            query.write(Uri.encodeQueryComponent("1"));
                            break;
                          case 3:
                            query.write('&affectionate=');
                            query.write(Uri.encodeQueryComponent("1"));
                            break;
                          case 4:
                            query.write('&gentle=');
                            query.write(Uri.encodeQueryComponent("1"));
                            break;
                        }

                        switch(_compatibilityValue){
                          case 1:
                            query.write('&okay_with_kids=');
                            query.write(Uri.encodeQueryComponent("1"));
                            break;
                          case 2:
                            query.write('&okay_with_dogs=');
                            query.write(Uri.encodeQueryComponent("1"));
                            break;
                          case 3:
                            query.write('&okay_with_cats=');
                            query.write(Uri.encodeQueryComponent("1"));
                            break;
                          case 4:
                            query.write('&okay_with_appartments=');
                            query.write(Uri.encodeQueryComponent("1"));
                            break;
                          case 5:
                            query.write('&okay_with_seniors=');
                            query.write(Uri.encodeQueryComponent("1"));
                            break;
                        }
                        query.write('&training_level=');
                        query.write(Uri.encodeQueryComponent(_training));

                        query.write('&energy_level=');
                        query.write(Uri.encodeQueryComponent(_energy));

                        query.write('&grooming_level=');
                        query.write(Uri.encodeQueryComponent(_grooming));


                        //Title
                        StringBuffer _titleBuffer = StringBuffer('');
                        _gender!=null  ? _titleBuffer.write(_gender+ ' ') : null;
                        _selectedPetBreed!=null ? _titleBuffer.write(_selectedPetBreed.name+ ' ') : null;
                        _selectedPetType==null ? _titleBuffer.write('Pets ') : _titleBuffer.write(_selectedPetType.name+'s ');
                        if(_petFor!=null ){
                          _petFor=='Engage' ?
                          _titleBuffer.write('For Adoption ' ) : _titleBuffer.write('For Sale ') ;
                        }else{
                          _titleBuffer.write('For Sale & Adoption ' );
                        }

                        _selectedCity==null ? _titleBuffer.write('in Pakistan') : _titleBuffer.write('in ' + _selectedCity+' ');
//                        Navigator.of(context).pop();
//                        Navigator.of(context).pop();
                        CustomNavigator.navigateTo(context, PetListing(listing: 2,query: query.toString(),title: _titleBuffer.toString(),));

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
