import 'package:agent_pet/src/models/pet.dart';
import 'package:agent_pet/src/services/_service.dart';
import 'package:agent_pet/src/services/misc-service.dart';
import 'package:agent_pet/src/utils/local-data.dart';
import 'package:agent_pet/src/utils/simple-future-builder.dart';
import 'package:agent_pet/src/widgets/dialogs/image-not-selected.dart';
import 'package:agent_pet/src/widgets/dialogs/loading-dialog.dart';
import 'package:agent_pet/src/widgets/dialogs/message-dialog.dart';
import 'package:agent_pet/src/widgets/round-drop-down-button.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'add-or-edit-pet-data.dart';

class OwnerDetails extends StatefulWidget {
  final TabController controller;
  final Pet petForEdit;
  final bool editMode;
  OwnerDetails({this.controller,this.petForEdit,this.editMode=false});
  @override
  State<StatefulWidget> createState() {
    return OwnerDetailsState();
  }
}

class OwnerDetailsState extends State<OwnerDetails> with AutomaticKeepAliveClientMixin {

  var ownerFormKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  Future _citiesFuture;
  List<String> _cities;
  String _selectedCity;
  TextEditingController phoneNum = TextEditingController();
  var _service = MiscService();

  List<int> oldImages = [];


  @override
  void initState() {
    if(widget.editMode){
      phoneNum.text = widget.petForEdit.ownerPhone;
      _selectedCity = widget.petForEdit.ownerCity;
    }
    super.initState();
    _citiesFuture = _service.getCities();
    _citiesFuture.then((e){
      setState(() {
        _cities = e;
      });
    });

  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    var _petData = InheritedAddPet.of(context);
    return SingleChildScrollView(
      child: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            key: ownerFormKey,
            autovalidate: _autoValidate,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: phoneNum,
                  inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Phone No*",
                  ),
                  validator: (value){
                    return value.isEmpty ? 'Please input phone no' : null;
                  },
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(
                  height: 20,
                ),
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
                      onChanged: (item) =>
                          setState(() {
                            this._selectedCity = item;
                            FocusScope.of(context).requestFocus(
                                new FocusNode());
                          }),
                    );
                  }
                ),
                SizedBox(
                  height: 15,
                ),

                Center(
                  child: FlatButton(
                    color: Colors.red,
                    child: Text("Submit", style: TextStyle(color: Colors.white),),
                    onPressed: () async {
//                      FocusScope.of(context).requestFocus(FocusNode());
                      var _data = InheritedAddPet.of(context);
                      var _newImgs = _data.imageSelector.images.values.length;

                      if(widget.editMode){
                        _data.oldImages.forEach((img){
                          oldImages.add(img.id);
                        });
                        print(oldImages);
                      }


                      bool _editModeValidate(){
                        var _oldImgs = _data.oldImages.length;
                        if(_oldImgs > 0 || _newImgs > 0){
                          print("edit mode images validated");
                          return true;
                        }else{
                          return false;
                        }
                      }


                      bool _imgCheck(){
                        if(_data.nickName.text.isEmpty){
                          openMessageDialog(context,'Nickname cannot be empty.');
                          widget.controller.animateTo(0);
                          return false;
                        }
                        if(widget.editMode && _editModeValidate() || !widget.editMode && _newImgs >0 ){
                          return true;
                        }else{
                          showDialog(context: context,child: ImageNotSelected());
                          widget.controller.animateTo(0);
                          return false;
                        }
                      }



                      if(ownerFormKey.currentState.validate() && _imgCheck() ){

                        var _images = _data.imageSelector.images.values.toList();

                        FormData _addPet = FormData.fromMap({
                          "type_id" : _data.selectedPetType.id,
                          "user_id" : LocalData.user.id,
                          "name" : _data.nickName.text,
                          //Todo: Change status from Approved to New at deployment
                          "status" : widget.editMode ? widget.petForEdit.status : 'New',
                          "description" : _data.moreAboutPet.text.isNotEmpty ? _data.moreAboutPet.text : "",
                          "pet_for" : _data.selectedPetFor,
                          "primary_breed" : _data.selectedPetBreed.name,
                          "gender" : _data.selectedGender,
                          "color" : _data.selectedColor,
                          "age" : _data.selectedAge == 'Over 5 Years' ? 6 : int.parse(_data.selectedAge),
                          "group" : _data.selectedGroup,
                          "training_level" : _data.selectedTrainingLevel,
                          "energy_level" : _data.selectedEnergyLevel,
                          "grooming_level" : _data.selectedGroomingLevel,
                          "price" : _data.price.text.isNotEmpty ? _data.price.text : '0',
                          "owner_name" : LocalData.user.name,
                          "owner_phone" : phoneNum.text,
                          "owner_city" : _selectedCity,
                          "protective" : _data.protective ? 1 : 0,
                          "playful" : _data.playful ? 1 : 0,
                          "affectionate" : _data.affectionate ? 1 : 0,
                          "gentle" : _data.gentle ? 1 : 0,
                          "okay_with_kids" : _data.okayWithKids ? 1 : 0,
                          "okay_with_dogs" : _data.okayWithDogs ? 1 : 0,
                          "okay_with_cats" : _data.okayWithCats ? 1 : 0,
                          "okay_with_appartments" : _data.okayWithApartments ? 1 : 0,
                          "okay_with_seniors" : _data.okayWithSeniors ? 1 : 0,
                          "hypoallergenic" : _data.hypoallergenic ? 1 : 0,
                          "house_trained" : _data.houseTrained ? 1 : 0,
                          "declawed" : _data.declawed ? 1 : 0,
                          "special_diet" : _data.specialDiet ? 1 : 0,
                          "likes_to_lap" : _data.likesToLap ? 1 : 0,
                          "ongoing_medical" : _data.ongoingMedical ? 1 : 0,
                          "neutered" : _data.neutered ? 1 : 0,
                          "vaccinated" : _data.vaccinated ? 1 : 0,
                          "high_risk" : _data.highRisk ? 1 : 0,
                          "featured" : 0,
                          "oldimages" : widget.editMode ? oldImages : null
                        });



                        for(var image in _images) {
                          _addPet.files.add(MapEntry(
                            'product_imgs[]',
                            await MultipartFile.fromFile(image, filename: "${image.split("/").last}")
                          ));
                        }


                        openLoadingDialog(context, widget.editMode ? 'Editing your ad...' : 'Posting your ad...');

                       !widget.editMode ? await Service.post("add-pet", _addPet) :
                       await Service.post("edit-pet/${widget.petForEdit.id}}", _addPet);

                        Navigator.of(context).pop();

//                         openMessageDialog(context,widget.editMode ?  "Edited Successfully." : "Ad Posted Successfully.");

                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text(widget.editMode ?"Pet Updated Successfully" : "Ad Posted Successfully"),
                          behavior: SnackBarBehavior.floating,
                          shape:RoundedRectangleBorder(),
                        ));

                        Future.delayed(Duration(seconds: 2),
                                () => Navigator.of(context).pop());


                      }else{
                        setState(() {
                          _autoValidate=true;
                        });
                      }
                    },
                  ),
                ),
                SizedBox(height: 20,),
                Container(color: Colors.grey.shade200, child: Padding(padding: EdgeInsets.all(15), child: Column(
                  children: <Widget>[
                    Text("AgentPet Ad Publishing Policy", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),),
                    SizedBox(height: 25,),
                    Row(children: <Widget>[
                      Container(height: 8,width: 8, decoration: BoxDecoration(borderRadius: BorderRadius.circular(40), color: Colors.red),),
                      SizedBox(width: 15,),
                      Text("We don't allow duplicates of same ad.")
                    ],),
                    SizedBox(height: 15,),
                    Row(children: <Widget>[
                      Container(height: 8,width: 8, decoration: BoxDecoration(borderRadius: BorderRadius.circular(40), color: Colors.red),),
                      SizedBox(width: 15,),
                      Container(
                          width: MediaQuery.of(context).size.width - 96,
                          child: Text("We don't allow promotional message that is not relevant to ad.", ))
                    ],),
                    SizedBox(height: 15,),
                    Row(children: <Widget>[
                      Container(height: 8,width: 8, decoration: BoxDecoration(borderRadius: BorderRadius.circular(40), color: Colors.red),),
                      SizedBox(width: 15,),
                      Container(
                          width: MediaQuery.of(context).size.width - 96,
                          child: Text("We don't allow Cartoonic Pictures, pictures with human facial impressions and irrelevent pictures."))
                    ],)
                  ],
                ),),)
              ],
            ),
          )
      ),
    );
  }



  @override
  bool get wantKeepAlive => true;
}

