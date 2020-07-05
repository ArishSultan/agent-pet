
import 'package:agent_pet/src/services/_service.dart';
import 'package:agent_pet/src/widgets/dialogs/loading-dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pet_relocation-data.dart';

class PetOwner extends StatefulWidget  {
  final TabController tabController;
  PetOwner({
  this.tabController
  });
  @override
  _PetOwnerState createState() => _PetOwnerState();
}

class _PetOwnerState extends State<PetOwner> with AutomaticKeepAliveClientMixin  {

  bool _autoValidate = false;
  var petOwnerFormKey = GlobalKey<FormState>();
  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _phone = TextEditingController();



  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    var _relocationData = InheritedPetRelocation.of(context);
    _relocationData.name =  _name;
    _relocationData.email = _email;
    _relocationData.phone = _phone;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: petOwnerFormKey,
          autovalidate: _autoValidate,
          child: Column(
            children: <Widget>[
              _buildTextField(context, _name, 'Name*'),
              _buildTextField(context, _email, 'Email*'),
              _buildTextField(context, _phone, 'Phone*'),
               Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FlatButton(
                    child: Text("Send"),
                    color: Colors.primaries[0],
                    onPressed: () async {
                      var _data = InheritedPetRelocation.of(context);

                      bool relocationValidate(){
                        if(_data.weight.text==''){
                          widget.tabController.animateTo(0);
                          return false;
                        }
                        if(_data.departureCity.text=='' ||_data.arrivalCity.text=='' ){
                          widget.tabController.animateTo(1);
                          return false;
                        }
                        return true;
                      }

                      if(petOwnerFormKey.currentState.validate() && relocationValidate()){
                        FormData _petReloForm = FormData.fromMap({
                          "type_id": _data.selectedPetType.id,
                          "gender": _data.selectedGender,
                          "weight": _data.weight.text,
                          "primary_breed": "Pure Breed",
                          "age": _data.selectedAge == 'Over 5 Years' ? 6 : int.parse(_data.selectedAge),
                          "departure_country_id": _data.selectedDepartureCountry.id,
                          "arrival_country_id": _data.selectedArrivalCountry.id,
                          "departure_city": _data.departureCity.text,
                          "arrival_city": _data.arrivalCity.text,
                          "cage_length" :  _data.length.text!='' ? _data.length.text : null,
                          "cage_width" : _data.width.text!='' ?  _data.width.text : null,
                          "cage_height" : _data.height.text!='' ? _data.height.text : null,
                          "travel_date": _data.dateOfTravel.toIso8601String(),
                          "comments": _data.comments.text!='' ? _data.comments.text: null,
                          "owner_name": _data.name.text,
                          "owner_email": _data.email.text,
                          "owner_phone": _data.phone.text
                        });
                        FocusScope.of(context).requestFocus(FocusNode());
                        openLoadingDialog(context,'Submitting your request...');

                        await Service.post("pet-move", _petReloForm);
                       Navigator.of(context).pop();

                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text("We have received your request to move your pet."),
                          behavior: SnackBarBehavior.floating,
                          shape:RoundedRectangleBorder(),
                        ));
                        Future.delayed(Duration(seconds: 2),
                                () => Navigator.of(context).pop());

                      }
                      else{
                        setState(() {
                          _autoValidate=true;
                        });
                      }
                      }
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildTextField(
      context,
      textFieldController,
      labelText,
      ) =>
      Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            inputFormatters: labelText == 'Phone*' ?  [WhitelistingTextInputFormatter.digitsOnly] : null,
            validator: (value){
              if(value.isEmpty){
                return 'Please enter $labelText';
              }
              if(labelText=='Email*' && !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)){

                return 'Please provide a valid email"';
              }
              return null;
            },
            controller: textFieldController,
            keyboardType: labelText == 'Email*' ? TextInputType.emailAddress : ( labelText == 'Phone*' ? TextInputType.phone : TextInputType.text),
            decoration: InputDecoration(
                labelText: labelText,
                labelStyle: TextStyle(fontSize: 12.0),
                border: OutlineInputBorder(),
                prefixIcon: labelText == 'Name*' ? Icon(Icons.person) : (labelText == 'Email*' ? Icon(Icons.email) : Icon(Icons.phone))
            ),
          ));

  @override
  bool get wantKeepAlive => true;
}




