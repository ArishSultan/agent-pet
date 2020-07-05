import 'package:agent_pet/src/models/pet-type.dart';
import 'package:agent_pet/src/services/pet-type_service.dart';
import 'package:agent_pet/src/widgets/custom-flat-button.dart';
import 'package:agent_pet/src/widgets/round-drop-down-button.dart';
import 'package:agent_pet/src/widgets/section-header.dart';
import 'package:agent_pet/src/utils/simple-future-builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'pet_relocation-data.dart';

class PetDetails extends StatefulWidget  {
  final TabController controller;

  PetDetails({this.controller});

  @override
  PetDetailsState createState() => PetDetailsState();
}

class PetDetailsState extends State<PetDetails> with AutomaticKeepAliveClientMixin {
  
  var petDetailFormKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  TextEditingController weight = TextEditingController();
  TextEditingController length= TextEditingController();
  TextEditingController width= TextEditingController();
  TextEditingController height= TextEditingController();
  PetRelocationData data;
  Future<List<PetType>> _petTypesFuture;
  List<PetType> _petTypes;
  PetType selectedPetType;
  PetType selectedPetBreed;
  String selectedGender;
  String selectedAge;

  Future<List<PetType>> _petBreedsFuture;
  List<PetType> _petBreeds;

  final _ages = <String>['1', '2', '3', '4', '5', 'Over 5 Years'];

  final _genders = <String>['Male', 'Female', 'Pair'];



  @override
  void initState() {
    super.initState();

    _petTypesFuture = PetTypeService().getAll('pet-types');

    _petTypesFuture.then((data) {
      _petTypes = data;
    });
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    var _relocationData = InheritedPetRelocation.of(context);
    _relocationData.weight = weight;
    _relocationData.length = length;
    _relocationData.width = width;
    _relocationData.height = height;
    _relocationData.selectedPetType =  selectedPetType ;
    _relocationData.selectedPetBreed = selectedPetBreed;
    _relocationData.selectedGender = selectedGender;
    _relocationData.selectedAge = selectedAge;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          autovalidate: _autoValidate,
          key: petDetailFormKey,
          child: Column(children: <Widget>[
            SimpleFutureBuilder<List<PetType>>.simpler(
              context: context,
              future: _petTypesFuture,

              builder: (AsyncSnapshot<List<PetType>> snapshot) {
                return RoundDropDownButton<PetType>(
                  hint: Text("Pet Type*"),
                  items: _petTypes.map((petType) {
                    return DropdownMenuItem<PetType>(
                      child: Text(petType.name),
                      value: petType,
                    );
                  }).toList(),
                  value: selectedPetType,

                  onChanged: (item) => setState(() {
                    this.selectedPetType = item;
                    this._petBreeds = null;
                    this.selectedPetBreed = null;

                    this._petBreedsFuture = PetTypeService().getAll('pet-breeds/${item.id}');
                    this._petBreedsFuture.then((data) {
                      setState(() {this._petBreeds = data;
                      FocusScope.of(context).requestFocus( FocusNode());
                      });
                    });
                  }),
                );
              },
            ),

            SizedBox(height: 10),

            RoundDropDownButton<String>(
              hint: Text("Gender*"),
              items: _genders.map((gender) {
                return DropdownMenuItem(
                  child: Text(gender),
                  value: gender,
                );
              }).toList(),
              value: selectedGender,

              onChanged: (item) => setState(() { this.selectedGender = item;
              FocusScope.of(context).requestFocus(new FocusNode());
              }),
            ),

            SizedBox(height: 10),

            RoundDropDownButton<PetType>(
              hint: Text("Pet Breed*"),
              items: _petBreeds == null? []: _petBreeds.map((breed) {
                return DropdownMenuItem<PetType>(
                  child: Text(breed.name),
                  value: breed,
                );
              }).toList(),
              value: selectedPetBreed,
              onChanged: (item) => setState(() { this.selectedPetBreed = item;
              FocusScope.of(context).requestFocus(new FocusNode());
              }),
            ),

            SizedBox(height: 10),
            RoundDropDownButton<String>(
              hint: Text("Age"),
              items: _ages.map((age) {
                return DropdownMenuItem(
                    child: Text(age),
                    value: age
                );
              }).toList(),
              value: selectedAge,
              onChanged: (item) => setState(() { this.selectedAge = item;
              FocusScope.of(context).requestFocus(new FocusNode());
              }),
            ),
            SizedBox(height: 10),
            _buildTextField(context, weight, "Weight(KG)*"),
            SizedBox(height: 10),
            SectionHeader("Cage Dimension (inches)"),
            SizedBox(height: 10),
            Row(
              children: <Widget>[
                Expanded(child: _buildTextField(context, length, "Length")),
                Expanded(child: _buildTextField(context, width, "Width")),
                Expanded(child: _buildTextField(context, height, "Height")),
              ],
            ),
            SizedBox(height: 20,),
            CustomFlatButton(
              title: 'Next',
              onPressed: (){
                if(petDetailFormKey.currentState.validate()){
//                      print("pet type: ${selectedPetType.id}"
//                          "gender $selectedGender"
//                          "pet breed $selectedPetBreed"
//                          "age $selectedAge"
//                          "cage dimensions length: ${length.text} "
//                          "${width.text} "
//                          "${height.text} "
//                      );
                  setState(() {
                    isDisabledPetRelocation[widget.controller.index+1] = false;
                  });
                  widget.controller.animateTo(widget.controller.index+1);
                }
                else{
                  setState(() {
                    _autoValidate=true;
                  });
                }
              },
            ),

          ], crossAxisAlignment: CrossAxisAlignment.end),
        ),
      ),
    );

  }
  _buildTextField(
      context,
      textFieldController,
      labelText,
      ) =>
      TextFormField(
          inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
          validator: (value){
            if(labelText=='Length' || labelText=='Width' || labelText=='Height'){
              return null;
            }
            return value.isEmpty ? 'Please enter $labelText' : null;
          },
          controller: textFieldController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: TextStyle(fontSize: 12.0),
            border: OutlineInputBorder(),
          ));

  @override
  bool get wantKeepAlive => true;
}