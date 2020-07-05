import 'dart:async';
import 'package:agent_pet/src/models/pet-images.dart';
import 'package:agent_pet/src/models/pet-type.dart';
import 'package:agent_pet/src/models/pet.dart';
import 'package:agent_pet/src/widgets/image_selector.dart';
import 'package:flutter/material.dart';


List<bool> isDisabledAddPet = [false,true,true];


class AddPetData {

  List<PetImages> oldImages;
  Pet petForEdit;
  String selectedPetFor;
  TextEditingController price = TextEditingController();
  TextEditingController nickName = TextEditingController();
  String selectedGender;
  PetType selectedPetType;
  PetType selectedPetBreed;
  String selectedColor;
  String selectedAge;
  String selectedGroup;
  String selectedTrainingLevel;
  String selectedEnergyLevel;
  String selectedGroomingLevel;

  var imageSelector = ImageSelector();

  // Can be accessed at submit page
//  String selectedCity;
//  TextEditingController phoneNum = TextEditingController();

  // PET FEATURES
  bool protective=false;
  bool playful=false;
  bool affectionate=false;
  bool gentle=false;
  bool okayWithKids=false;
  bool okayWithDogs=false;
  bool okayWithCats=false;
  bool okayWithApartments=false;
  bool okayWithSeniors=false;

  // SPECIAL PET FEATURES

  bool hypoallergenic=false;
  bool houseTrained=false;
  bool declawed=false;
  bool specialDiet=false;
  bool likesToLap=false;
  bool specialNeeds=false;
  bool ongoingMedical=false;
  bool neutered=false;
  bool vaccinated=false;
  bool highRisk=false;

  TextEditingController moreAboutPet = TextEditingController();


  // ignore: close_sinks
  final StreamController _streamController = StreamController.broadcast();

  Stream get stream => _streamController.stream;

  Sink get sink => _streamController.sink;
}

class InheritedAddPet extends InheritedWidget {
  final AddPetData data;

  InheritedAddPet({
    Key key,
    @required Widget child,
  })  : assert(child != null),
        data = AddPetData(),
        super(key: key, child: child);

  static AddPetData of(BuildContext context) => (context.inheritFromWidgetOfExactType(InheritedAddPet) as InheritedAddPet).data;

  @override
  bool updateShouldNotify(InheritedAddPet old) => false;
}
