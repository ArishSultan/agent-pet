import 'package:agent_pet/src/models/pet-images.dart';
import 'package:agent_pet/src/models/pet-type.dart';
import 'package:agent_pet/src/models/pet.dart';
import 'package:agent_pet/src/services/_service.dart';
import 'package:agent_pet/src/services/pet-type_service.dart';
import 'package:agent_pet/src/utils/simple-future-builder.dart';
import 'package:agent_pet/src/widgets/custom-flat-button.dart';
import 'package:agent_pet/src/widgets/image_selector.dart';
import 'package:agent_pet/src/widgets/loading-builder.dart';
import 'package:agent_pet/src/widgets/round-drop-down-button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'add-or-edit-pet-data.dart';

class InformationTab extends StatefulWidget {

  final TabController controller;
  final Pet petForEdit;
  final bool editMode;
  InformationTab({this.controller,this.petForEdit,this.editMode=false});

  @override
  InformationTabState createState() => InformationTabState();
}

class InformationTabState extends State<InformationTab> with AutomaticKeepAliveClientMixin {

  var infoFormKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  var imageSelector = ImageSelector();
  Future<List<PetType>> _petTypesFuture;
  List<PetType> _petTypes;
  PetType _selectedPetType;

  Future<List<PetType>> _petBreedsFuture;
  List<PetType> _petBreeds;
  PetType _selectedPetBreed;

  final _price = TextEditingController();
  final _nickName = TextEditingController();
  List<String> petFor = ['Engage','Sell','Both'];
  List<String> gender = ['Male','Female','Pair'];
  List<String> color = ['Black','Brown','Grey','White','Other'];
  List<String> age = ['1','2','3','4','5','Over 5 Years'];
  List<String> group = ['Baby','Young','Adult','Senior'];
  List<String> trainingLevel = ['Has Basic Training','Well Trained'];
  List<String> energyLevel = ['Low','Moderate','High'];
  List<String> groomingLevel = ['Low','Moderate','High','Not Required'];
  String _petFor;
  String _gender;
  String _color;
  String _age;
  String _group;
  String _trainingLevel;
  String _energyLevel;
  String _groomingLevel;
  List<PetImages> oldImages;

  @override
  void initState() {
    super.initState();
    if(widget.editMode){
      print(widget.petForEdit.images);
       oldImages = widget.petForEdit.images;
      _petFor = widget.petForEdit.petFor;
      _price.text = widget.petForEdit.price;
      _nickName.text =widget.petForEdit.name;
      _selectedPetType = widget.petForEdit.type;
      _selectedPetBreed = PetType(name: widget.petForEdit.primaryBreed);
      this._petTypes = <PetType>[_selectedPetType];
      this._petBreeds = <PetType>[_selectedPetBreed];
      _gender=widget.petForEdit.gender;
      _color = widget.petForEdit.color;
      _age= widget.petForEdit.age == '6' ? 'Over 5 Years' : widget.petForEdit.age;
      _group = widget.petForEdit.group;
      _trainingLevel = widget.petForEdit.trainingLevel;
      _energyLevel = widget.petForEdit.energyLevel;
      _groomingLevel=widget.petForEdit.groomingLevel;
    }

    _petTypesFuture = PetTypeService().getAll('pet-types');

    _petTypesFuture.then((data) {
      if(this.mounted){
        setState(() {
          _petTypes = data;

          if (widget.editMode) {
            _petTypes.forEach((type) {
              if (type.name == widget.petForEdit.type.name) {
                _selectedPetType = type;
                this._petBreedsFuture = PetTypeService().getAll('pet-breeds/${_selectedPetType.id}')..then((breeds) {
                  setState(() {
                    this._petBreeds = breeds;
                    breeds.forEach((breed) {
                      if (breed.name == widget.petForEdit.primaryBreed) {
                        setState(() => this._selectedPetBreed = breed);
                      }
                    });
                  });
                });
              }
            });

          }
        });
      }
    });
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    var _petData = InheritedAddPet.of(context);
    _petData.oldImages = oldImages;
//    _petData.petForEdit = widget.petForEdit;
    _petData.selectedPetFor = _petFor;
    _petData.price = _price;
    _petData.nickName = _nickName;
    _petData.selectedPetType = _selectedPetType;
    _petData.selectedPetBreed = _selectedPetBreed;
    _petData.selectedGender = _gender;
    _petData.selectedColor = _color;
    _petData.selectedAge = _age;
    _petData.selectedGroup = _group;
    _petData.selectedTrainingLevel = _trainingLevel;
    _petData.selectedEnergyLevel = _energyLevel;
    _petData.selectedGroomingLevel = _groomingLevel;
    _petData.imageSelector = imageSelector;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          autovalidate: _autoValidate,
          key: infoFormKey,
          child: Column(children: <Widget>[
            widget.editMode && oldImages.length > 0 ? ConstrainedBox(
              constraints: BoxConstraints.expand(height: 150),
          child:
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    color: Colors.grey.shade200,
                    child: Center(
                      child: oldImages.length == 0
                          ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.image),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 3),
                          ),
                          Text("No Images Selected!",style: TextStyle(fontWeight: FontWeight.w400)),
                        ],
                      )
                          :
                              ListView.builder(
                        itemCount: oldImages.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, i) => SizedBox(
                                  width: 150,
                                  height: 150,
                                  child: Stack(
                                    overflow: Overflow.clip,
                                    children: <Widget>[
                                      Image.network(
                                        Service.getConvertedImageUrl(oldImages[i].src),
                                        fit: BoxFit.cover,
                                        loadingBuilder: circularImageLoader,
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 16,
                                        child:Container(
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius: BorderRadius.circular(5)
                                          ),

                                          child: SizedBox(
                                            child: MaterialButton(
                                              shape: RoundedRectangleBorder(),
                                              padding: EdgeInsets.all(0),
                                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                onPressed: () {
                                                setState(() {
                                                  oldImages.removeAt(i);
                                                });
//                                                  setState(() => LocalData.removeFromCart(i));
                                                },
                                                child: Icon(Icons.delete, size: 12,color: Colors.white,)
                                            ),
                                          ),
                                        )
                                      ),
                                    ],
                                  ),
                        ),
                      ),


                    )),
              ),
//              Positioned(
//                bottom: 2,
//                child: FlatButton(
//                  padding: EdgeInsets.all(8),
//                  shape: CircleBorder(),
//                  color: Colors.primaries[0],
//                  onPressed: () async {
//
//                  },
//                  child: Icon(
//                    Icons.add,
//                    color: Colors.white,
//                  ),
//                ),
//              ),

        ): SizedBox(),
            imageSelector,
            SizedBox(height: 30),
            RoundDropDownButton<String>(
              hint: Text("Pet For*"),
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
            SizedBox(height: 10),
            _buildTextField(context, _price, "Price"),
            SizedBox(height: 10),
            _buildTextField(context, _nickName, "Nick Name*"),

            SizedBox(height: 10),

            SimpleFutureBuilder<List<PetType>>.simpler(
              context: context,
              future: _petTypesFuture,
              builder: (AsyncSnapshot<List<PetType>> snapshot) {
                return RoundDropDownButton<PetType>(

                  hint: Text("Pet Type*"),
                  items: _petTypes.map((item) {
                    return DropdownMenuItem<PetType>(
                      child: Text(item.name),
                      value: item,
                    );
                  }).toList(),
                  value: _selectedPetType,

                  onChanged: (item) =>
                      setState(() {
                        FocusScope.of(context).requestFocus(FocusNode());

                        this._selectedPetType = item;
                        this._petBreeds = null;
                        this._selectedPetBreed = null;

                        this._petBreedsFuture = PetTypeService().getAll(
                            'pet-breeds/${item.id}');
                        this._petBreedsFuture.then((data) {
                          setState(() => this._petBreeds = data);
                        });
                      }),
                );
              }
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
              value: _selectedPetBreed,
              onChanged: (item) => setState(() { this._selectedPetBreed = item;
              FocusScope.of(context).requestFocus(new FocusNode());
              }),
            ),
            SizedBox(height: 10),
            RoundDropDownButton<String>(
              hint: Text("Gender*"),
              items: gender
                  .map((i) => DropdownMenuItem<String>(
                  child: Text(i), value: i))
                  .toList(),
              value: _gender,
              onChanged: (item) => setState(() {

               this._gender = item;


              FocusScope.of(context).requestFocus(new FocusNode());
              }),
            ),
            SizedBox(height: 10),
            RoundDropDownButton<String>(
              hint: Text("Color*"),
              items: color
                  .map((i) => DropdownMenuItem<String>(
                  child: Text(i), value: i))
                  .toList(),
              value:  _color,
              onChanged: (item) => setState(() {
               this._color = item;
                FocusScope.of(context).requestFocus(new FocusNode());
              }),
            ),
            SizedBox(height: 10),
            RoundDropDownButton<String>(
              hint: Text("Age*"),
              items: age
                  .map((i) => DropdownMenuItem<String>(
                  child: Text(i), value: i))
                  .toList(),
              value:  _age,
              onChanged: (item) => setState((){

             this._age = item;

              FocusScope.of(context).requestFocus(new FocusNode());
              }),
            ),
            SizedBox(height: 10),
            RoundDropDownButton<String>(
              hint: Text("Group*"),
              items: group
                  .map((i) => DropdownMenuItem<String>(
                  child: Text(i), value: i))
                  .toList(),
              value:  _group ,
              onChanged: (item) => setState(() {
                this._group = item;
               this._group = item;

                FocusScope.of(context).requestFocus(new FocusNode());
              }),
            ),
            SizedBox(height: 10),
            RoundDropDownButton<String>(
              hint: Text("Training Level*"),
              items: trainingLevel
                  .map((i) => DropdownMenuItem<String>(
                  child: Text(i), value: i))
                  .toList(),
              value: _trainingLevel,
              onChanged: (item) => setState(() {
              this._trainingLevel = item;
              FocusScope.of(context).requestFocus(new FocusNode());
              }),
            ),
            SizedBox(height: 10),
            RoundDropDownButton<String>(
              hint: Text("Energy Level*"),
              items: energyLevel
                  .map((i) => DropdownMenuItem<String>(
                  child: Text(i), value: i))
                  .toList(),
              value:  _energyLevel,

              onChanged: (item) => setState(() =>  this._energyLevel = item),
            ),
            SizedBox(height: 10),
            RoundDropDownButton<String>(
              hint: Text("Grooming Level*"),
              items: groomingLevel
                  .map((i) => DropdownMenuItem<String>(
                  child: Text(i), value: i))
                  .toList(),
              value:_groomingLevel,
              onChanged: (item) => setState(() { this._groomingLevel = item;

              this._groomingLevel = item;

              FocusScope.of(context).requestFocus(new FocusNode());
              }),
            ),
            SizedBox(height: 10),
            CustomFlatButton(
              title: 'Next',
              onPressed: (){
                if(infoFormKey.currentState.validate()){

                  setState(() {
                    isDisabledAddPet[widget.controller.index+1] = false;
                  });
                  widget.controller.animateTo(widget.controller.index+1);

                }else{
                  setState(() {
                    _autoValidate=true;
                  });
                }
            },),

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
        validator: (value){
          if(labelText!="Price"){
            return value.isEmpty ? 'Please enter $labelText' : null;
          }
          return null;
        },

        controller: textFieldController,
        textInputAction: TextInputAction.go,
        inputFormatters:  labelText == 'Price' ? <TextInputFormatter>[
          WhitelistingTextInputFormatter.digitsOnly
        ]: null,
        keyboardType: labelText == 'Price' ? TextInputType.phone : TextInputType.text,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
        ),
      );

  @override
  bool get wantKeepAlive => true;



}

