import 'package:agent_pet/src/models/pet.dart';
import 'package:agent_pet/src/widgets/custom-flat-button.dart';
import 'package:flutter/material.dart';

import 'add-or-edit-pet-data.dart';

class Features extends StatefulWidget {
  final TabController controller;
  final Pet petForEdit;
  final bool editMode;
  Features({this.controller,this.editMode,this.petForEdit});

  @override
  FeaturesState createState() => FeaturesState();
}


class FeaturesState extends State<Features> with AutomaticKeepAliveClientMixin{

  //Pet Features
  bool protective=false;
  bool playful=false;
  bool affectionate=false;
  bool gentle=false;
  bool okayWithKids=false;
  bool okayWithDogs=false;
  bool okayWithCats=false;
  bool okayWithApartments=false;
  bool okayWithSeniors=false;
  //Special Pet Features
  bool hypoallergenic=false;
  bool hypoallergenicNo=false;
  bool hypoallergenicYes=true;
  bool houseTrained=false;
  bool houseTrainedNo=false;
  bool houseTrainedYes=true;
  bool declawed=false;
  bool declawedNo=false;
  bool declawedYes=true;
  bool specialDiet=false;
  bool specialDietNo=false;
  bool specialDietYes=true;
  bool likesToLap=false;
  bool likesToLapNo=false;
  bool likesToLapYes=true;
  bool specialNeeds=false;
  bool specialNeedsNo=false;
  bool specialNeedsYes=true;
  bool ongoingMedical=false;
  bool ongoingMedicalNo=false;
  bool ongoingMedicalYes=true;
  bool neutered=false;
  bool neuteredNo=false;
  bool neuteredYes=true;
  bool vaccinated=false;
  bool vaccinatedNo=false;
  bool vaccinatedYes=true;
  bool highRisk=false;
  bool highRiskNo=false;
  bool highRiskYes=true;

  TextEditingController moreAboutPet = TextEditingController();

  @override
  void initState() {
    super.initState();
    if(widget.editMode){
      moreAboutPet.text = widget.petForEdit.description;
      protective= widget.petForEdit.protective;
      playful=widget.petForEdit.playful;
      affectionate=widget.petForEdit.affectionate;
      gentle=widget.petForEdit.gentle;
      okayWithKids=widget.petForEdit.okayWithKids;
      okayWithDogs=widget.petForEdit.okayWithDogs;
      okayWithCats=widget.petForEdit.okayWithCats;
      okayWithApartments=widget.petForEdit.okayWithAppartments;
      okayWithSeniors=widget.petForEdit.okayWithSeniors;
      hypoallergenic=widget.petForEdit.hypoallergenic;
      houseTrained=widget.petForEdit.houseTrained;
      declawed=widget.petForEdit.declawed;
      specialDiet=widget.petForEdit.specialDiet;
      likesToLap=widget.petForEdit.likesToLap;
      specialNeeds=widget.petForEdit.specialNeeds;
      ongoingMedical=widget.petForEdit.ongoingMedical;
      neutered=widget.petForEdit.neutered;
      vaccinated=widget.petForEdit.vaccinated;
      highRisk=widget.petForEdit.highRisk;
    }
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    var _petData = InheritedAddPet.of(context);
    _petData.protective = protective;
    _petData.playful = playful;
    _petData.affectionate = affectionate;
    _petData.gentle = gentle;
    _petData.okayWithKids = okayWithKids;
    _petData.okayWithDogs = okayWithDogs;
    _petData.okayWithCats = okayWithCats;
    _petData.okayWithApartments = okayWithApartments;
    _petData.okayWithSeniors = okayWithSeniors;
    _petData.hypoallergenic = hypoallergenic;
    _petData.houseTrained = houseTrained;
    _petData.declawed = declawed;
    _petData.specialDiet = specialDiet;
    _petData.likesToLap = likesToLap;
    _petData.specialNeeds = specialNeeds;
    _petData.ongoingMedical = ongoingMedical;
    _petData.neutered = neutered;
    _petData.vaccinated = vaccinated;
    _petData.highRisk = highRisk;
    _petData.moreAboutPet = moreAboutPet;
    return SafeArea(
        child: ListView(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(left: 8,right: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 40,),
                        Text("Pet Features",style: TextStyle(fontSize: 20,color: Colors.primaries[0],fontWeight: FontWeight.bold)),

                        SizedBox(height: 20,),
                        Text("Temperament",style: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.bold)),

                      ],
                    ),
                  ),


                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Checkbox(
                          activeColor: Colors.primaries[0],
                          value: protective,
                          onChanged: (bool value){
                            setState(() {
                              protective = value;
                            });
                          },
                        ),
                      ),

                      Text("Protective"),
                      Expanded(
                        child: Checkbox(
                          activeColor: Colors.primaries[0],
                          value: playful,
                          onChanged: (bool value){
                            setState(() {
                              playful = value;
                            });
                          },
                        ),
                      ),
                      Text("Playful"),
                      Expanded(
                        child: Checkbox(
                          activeColor: Colors.primaries[0],
                          value: affectionate,
                          onChanged: (bool value){
                            setState(() {
                              affectionate = value;
                            });
                          },
                        ),
                      ),
                      Text("Affectionate"),
                      Expanded(
                        child: Checkbox(
                          activeColor: Colors.primaries[0],
                          value: gentle,
                          onChanged: (bool value){
                            setState(() {
                              gentle = value;
                            });
                          },
                        ),
                      ),
                      Text("Gentle"),

                    ],
                  ),


                  Text("Compatibility",style: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.bold)),



                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Checkbox(
                          activeColor: Colors.primaries[0],
                          value: okayWithKids,
                          onChanged: (bool value){
                            setState(() {
                              okayWithKids = value;
                            });
                          },
                        ),
                      ),
                      Text("Okay With Kids"),
                      Expanded(
                        child: Checkbox(
                          activeColor: Colors.primaries[0],
                          value: okayWithDogs,
                          onChanged: (bool value){
                            setState(() {
                              okayWithDogs = value;
                            });
                          },
                        ),
                      ),
                      Text("Okay With Dogs"),
                      Expanded(
                        child: Checkbox(
                          activeColor: Colors.primaries[0],
                          value: okayWithCats,
                          onChanged: (bool value){
                            setState(() {
                              okayWithCats = value;
                            });
                          },
                        ),
                      ),
                      Text("Okay With Cats"),


                    ],

                  ),
                  Row(
                    children: <Widget>[

                      Checkbox(
                        activeColor: Colors.primaries[0],
                        value: okayWithApartments,
                        onChanged: (bool value){
                          setState(() {
                            okayWithApartments = value;
                          });
                        },
                      ),
                      Text("Okay With Apartments"),

                      Checkbox(
                        activeColor: Colors.primaries[0],
                        value: okayWithSeniors,
                        onChanged: (bool value){
                          setState(() {
                            okayWithSeniors = value;
                          });
                        },
                      ),


                      Text("Okay With Seniors"),
                    ],
                  ),
                  Divider(thickness: 2,),

                  Text("Special Pet Features",style: TextStyle(fontSize: 20,color: Colors.primaries[0],fontWeight: FontWeight.bold)),
                  SizedBox(height: 20,),


                  Table(
                    children: [
                      TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left:5.0),
                              child: Text("Hypoallergenic",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left:5.0),
                              child: Text("House Trained",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left:5.0),
                              child: Text("Declawed",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                            ),

                          ]
                      ),
                      TableRow(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Radio(
                                    value: hypoallergenicYes,
                                    onChanged: (bool value){
                                      setState(() {
                                        hypoallergenic=value;

                                      });
                                    },
                                    groupValue: hypoallergenic,
                                    activeColor: Colors.primaries[0],

                                  ),
                                ),
                                Expanded(child: Text("Yes")),
                                Expanded(
                                  child: Radio(
                                    value: hypoallergenicNo,
                                    onChanged: (bool value){
                                      setState(() {
                                        hypoallergenic=value;
//                                        print(hypoallergenic);

                                      });
                                    },
                                    groupValue: hypoallergenic,
                                    activeColor: Colors.primaries[0],

                                  ),
                                ),
                                Expanded(child: Text("No")),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Radio(
                                    value: houseTrainedYes,
                                    onChanged: (bool value){
                                      setState(() {
                                        houseTrained=value;
                                      });
                                    },
                                    groupValue: houseTrained,
                                    activeColor: Colors.primaries[0],

                                  ),
                                ),
                                Expanded(child: Text("Yes")),
                                Expanded(
                                  child: Radio(
                                    value: houseTrainedNo,
                                    onChanged: (bool value){
                                      setState(() {
                                        houseTrained=value;
                                      });
                                    },
                                    groupValue: houseTrained,
                                    activeColor: Colors.primaries[0],

                                  ),
                                ),
                                Expanded(child: Text("No")),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Radio(
                                    value: declawedYes,
                                    onChanged: (bool value){
                                      setState(() {
                                        declawed=value;
                                      });
                                    },
                                    groupValue: declawed,
                                    activeColor: Colors.primaries[0],

                                  ),
                                ),
                                Expanded(child: Text("Yes")),
                                Expanded(
                                  child: Radio(
                                    value: declawedNo,
                                    onChanged: (bool value){
                                      setState(() {
                                        declawed=value;
                                      });
                                    },
                                    groupValue: declawed,
                                    activeColor: Colors.primaries[0],

                                  ),
                                ),
                                Text("No"),
                              ],
                            ),
                          ]
                      ),




                      //Row 2 Special Diet, Likes To Lap, Special Needs

                      TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left:5.0),
                              child: Text("Special Diet",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left:5.0),
                              child: Text("Likes To Lap",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left:5.0),
                              child: Text("Special Needs",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                            ),

                          ]
                      ),
                      TableRow(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Radio(
                                    value: specialDietYes,
                                    onChanged: (bool value){
                                      setState(() {
                                        specialDiet=value;
                                      });
                                    },
                                    groupValue: specialDiet,
                                    activeColor: Colors.primaries[0],

                                  ),
                                ),
                                Expanded(child: Text("Yes")),
                                Expanded(
                                  child: Radio(
                                    value: specialDietNo,
                                    onChanged: (bool value){
                                      setState(() {
                                        specialDiet=value;
                                      });
                                    },
                                    groupValue: specialDiet,
                                    activeColor: Colors.primaries[0],

                                  ),
                                ),
                                Expanded(child: Text("No")),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Radio(
                                    value: likesToLapYes,
                                    onChanged: (bool value){
                                      setState(() {
                                        likesToLap=value;
                                      });
                                    },
                                    groupValue: likesToLap,
                                    activeColor: Colors.primaries[0],

                                  ),
                                ),
                                Expanded(child: Text("Yes")),
                                Expanded(
                                  child: Radio(
                                    value: likesToLapNo,
                                    onChanged: (bool value){
                                      setState(() {
                                        likesToLap=value;
                                      });
                                    },
                                    groupValue: likesToLap,
                                    activeColor: Colors.primaries[0],

                                  ),
                                ),
                                Expanded(child: Text("No")),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Radio(
                                    value: specialNeedsYes,
                                    onChanged: (bool value){
                                      setState(() {
                                        specialNeeds=value;
                                      });
                                    },
                                    groupValue: specialNeeds,
                                    activeColor: Colors.primaries[0],

                                  ),
                                ),
                                Expanded(child: Text("Yes")),
                                Expanded(
                                  child: Radio(
                                    value: specialNeedsNo,
                                    onChanged: (bool value){
                                      setState(() {
                                        specialNeeds=value;
                                      });
                                    },
                                    groupValue: specialNeeds,
                                    activeColor: Colors.primaries[0],

                                  ),
                                ),
                                Text("No"),
                              ],
                            ),
                          ]
                      ),



                      //Row 3 Ongoing Medical, Neutered, Vaccinated

                      TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left:5.0),
                              child: Text("Ongoing Medical",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left:5.0),
                              child: Text("Neutered",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left:5.0),
                              child: Text("Vaccinated",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                            ),

                          ]
                      ),
                      TableRow(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Radio(
                                    value: ongoingMedicalYes,
                                    onChanged: (bool value){
                                      setState(() {
                                        ongoingMedical=value;

                                      });
                                    },
                                    groupValue: ongoingMedical,
                                    activeColor: Colors.primaries[0],

                                  ),
                                ),
                                Expanded(child: Text("Yes")),
                                Expanded(
                                  child: Radio(
                                    value: ongoingMedicalNo,
                                    onChanged: (bool value){
                                      setState(() {
                                        ongoingMedical=value;

                                      });
                                    },
                                    groupValue: ongoingMedical,
                                    activeColor: Colors.primaries[0],

                                  ),
                                ),
                                Expanded(child: Text("No")),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Radio(
                                    value: neuteredYes,
                                    onChanged: (bool value){
                                      setState(() {
                                        neutered=value;
                                      });
                                    },
                                    groupValue: neutered,
                                    activeColor: Colors.primaries[0],

                                  ),
                                ),
                                Expanded(child: Text("Yes")),
                                Expanded(
                                  child: Radio(
                                    value: neuteredNo,
                                    onChanged: (bool value){
                                      setState(() {
                                        neutered=value;
                                      });
                                    },
                                    groupValue: neutered,
                                    activeColor: Colors.primaries[0],

                                  ),
                                ),
                                Expanded(child: Text("No")),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Radio(
                                    value: vaccinatedYes,
                                    onChanged: (bool value){
                                      setState(() {
                                        vaccinated=value;
                                      });
                                    },
                                    groupValue: vaccinated,
                                    activeColor: Colors.primaries[0],

                                  ),
                                ),
                                Expanded(child: Text("Yes")),
                                Expanded(
                                  child: Radio(
                                    value: vaccinatedNo,
                                    onChanged: (bool value){
                                      setState(() {
                                        vaccinated=value;
                                      });
                                    },
                                    groupValue: vaccinated,
                                    activeColor: Colors.primaries[0],

                                  ),
                                ),
                                Text("No"),
                              ],
                            ),
                          ]
                      ),
                      TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left:5.0),
                              child: Text("High Risk",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                            ),
                            SizedBox(),
                            SizedBox(),
                          ]
                      ),
                      TableRow(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Radio(
                                    value: highRiskYes,
                                    onChanged: (bool value){
                                      setState(() {
                                        highRisk=value;
                                      });
                                    },
                                    groupValue: highRisk,
                                    activeColor: Colors.primaries[0],

                                  ),
                                ),
                                Expanded(child: Text("Yes")),
                                Expanded(
                                  child: Radio(
                                    value: highRiskNo,
                                    onChanged: (bool value){
                                      setState(() {
                                        highRisk=value;
                                      });
                                    },
                                    groupValue: highRisk,
                                    activeColor: Colors.primaries[0],
                                  ),
                                ),
                                Expanded(child: Text("No")),
                              ],
                            ),
                            SizedBox(),
                            SizedBox(),
                          ]
                      ),

                    ],
                  ),
                  SizedBox(height: 20,),

                  Text("More About Your Pet",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    controller: moreAboutPet,
                  ),
                  SizedBox(height: 10,),
                  CustomFlatButton(
                    title: 'Next',
                    onPressed: (){
                      setState(() {
                        isDisabledAddPet[widget.controller.index+1] = false;
                      });
                      widget.controller.animateTo(widget.controller.index+1);
                    },
                  ),

                ],
              ),
            ),
          ],
        )
    );
  }

  @override
  bool get wantKeepAlive => true;
}

