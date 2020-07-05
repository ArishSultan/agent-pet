import 'dart:async';
import 'package:agent_pet/src/models/country.dart';
import 'package:agent_pet/src/models/pet-type.dart';
import 'package:agent_pet/src/widgets/saved-badged-icon.dart';
import 'package:flutter/material.dart';

List<bool> isDisabledPetRelocation = [false,true,true];

class PetRelocationData {
  TextEditingController weight = TextEditingController();
  TextEditingController length = TextEditingController();
  TextEditingController width = TextEditingController();
  TextEditingController height = TextEditingController();
  PetType selectedPetType;
  PetType selectedPetBreed;
  String selectedGender;
  String selectedAge;

  TextEditingController departureCity = TextEditingController();
  TextEditingController arrivalCity = TextEditingController();
  DateTime dateOfTravel = DateTime.now();
  TextEditingController comments= TextEditingController();
  Country selectedDepartureCountry;
  Country selectedArrivalCountry;

  TextEditingController name= TextEditingController();
  TextEditingController email= TextEditingController();
  TextEditingController phone= TextEditingController();

  // ignore: close_sinks
  final StreamController _streamController = StreamController.broadcast();

  Stream get stream => _streamController.stream;

  Sink get sink => _streamController.sink;
}

class InheritedPetRelocation extends InheritedWidget {
  final PetRelocationData data;

  InheritedPetRelocation({
    Key key,
    @required Widget child,
  })  : assert(child != null),
        data = PetRelocationData(),
        super(key: key, child: child);

  static PetRelocationData of(BuildContext context) => (context.inheritFromWidgetOfExactType(InheritedPetRelocation) as InheritedPetRelocation).data;

  @override
  bool updateShouldNotify(InheritedPetRelocationold) => false;
}
