//import 'package:agent_pet/src/models/country.dart';
//import 'package:agent_pet/src/services/country-service.dart';
//import 'package:agent_pet/src/ui/widgets/appBar.dart';
//import 'package:agent_pet/src/ui/widgets/custom-form-field.dart';
//import 'package:agent_pet/src/ui/widgets/round-drop-down-button.dart';
//import 'package:agent_pet/src/utils/local-data.dart';
//import 'package:agent_pet/src/utils/simple-future-builder.dart';
//import 'package:flutter/material.dart';
//
//class ManageAddressPage extends StatefulWidget {
//  @override
//  _ManageAddressPageState createState() => _ManageAddressPageState();
//}
//
//class _ManageAddressPageState extends State<ManageAddressPage> {
//  Country _selectedCountry;
//  Future<List<Country>> _countriesFuture;
//
//  final _countryController = TextEditingController();
//
//  @override
//  void initState() {
//    super.initState();
//
//    /// Initialize and wait for the future to finish.
//    this._countriesFuture = CountryService().getAll('countries')
//      ..then((countries) {
//
//        /// Find-out the selected country is user is
//        /// Signed in
//        if (LocalData.isSignedIn) {
//          for (final country in countries) {
//            if (country.id == LocalData.user.id) {
//              this._selectedCountry = country;
//              break;
//            }
//          }
//        }
//      });
//
//    /// Initialize fields if user is logged In.
//    if (LocalData.isSignedIn) {
//
//    }
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AgentPetAppbar(context, "Manage Address"),
//
//      body: SimpleFutureBuilder<List<Country>>.simpler(
//        future: this._countriesFuture,
//        context: context,
//        builder: (AsyncSnapshot<List<Country>> snapshot) {
//          return SingleChildScrollView(child: Padding(
//            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
//            child: Form(
//              child: Column(children: <Widget>[
//                RoundDropDownButton<Country>(
//                  items: snapshot.data.map((country) =>
//                    DropdownMenuItem(child: Text(country.name))
//                  )
//
//                ),
//
//                CustomFormField(
//                  dense: true,
//                  label: "City*",
//                ),
//                SizedBox(height: 10),
//                CustomFormField(
//                  dense: true,
//                  label: "Address*"
//                ),
//                SizedBox(height: 10),
//                CustomFormField(
//                  dense: true,
//                  label: "Zip Code*"
//                ),
//
//                SizedBox(height: 30),
//                Align(
//                  alignment: Alignment.centerRight,
//                  child: RaisedButton.icon(
//                    icon: Icon(Icons.done),
//                    label: Text("Update"),
////                    shape: StadiumBorder(),
//                    color: Colors.accents[0],
//                    onPressed: () async {
//
//                    },
//                  ),
//                )
//              ]),
//            ),
//          ));
//        }
//      )
//    Simple(
//        child: SingleChildScrollView(child: Padding(
//          padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
//          child: Column(children: <Widget>[
//            RoundDropDownButton(),
//          ]),
//        )),
//      ),
//    );
//  }
//}

import 'package:agent_pet/src/models/country.dart';
import 'package:agent_pet/src/services/_service.dart';
import 'package:agent_pet/src/services/country-service.dart';
import 'package:agent_pet/src/widgets/appBar.dart';
import 'package:agent_pet/src/widgets/dialogs/loading-dialog.dart';
import 'package:agent_pet/src/widgets/round-drop-down-button.dart';
import 'package:agent_pet/src/utils/local-data.dart';
import 'package:agent_pet/src/utils/simple-future-builder.dart';
import 'package:agent_pet/src/widgets/section-header.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

class ManageAddressPage extends StatefulWidget {
  @override
  _ManageAddressPageState createState() => _ManageAddressPageState();
}

class _ManageAddressPageState extends State<ManageAddressPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AgentPetAppbar(context,"Manage Address"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.shade200,
                      offset: Offset(0.0, 15.0),
                      blurRadius: 15.0),
                  BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0.0, -10.0),
                      blurRadius: 10.0),
                ]),
            child: AddressFields(),
          ),
        ),
      ),
    );
  }
}







class AddressFields extends StatefulWidget {
  @override
  _AddressFieldsState createState() => _AddressFieldsState();
}

class _AddressFieldsState extends State<AddressFields> {

  var _key = GlobalKey<FormState>();
  bool _autoValidate = false;

  Future<List<Country>> _countriesFuture;
  List<Country> _countries;
  Country _selectedCountry;

  TextEditingController _city = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _zipCode = TextEditingController();
  bool _useSameForShip = false;

  @override
  void initState() {
    super.initState();
//    print(LocalData.user.zipCode);
    _countriesFuture = CountryService().getAll('countries');
    _countriesFuture.then((data) {
      _countries = data;

      data.forEach((element) {
        if (element.id == LocalData.user.countryId) {
          this._selectedCountry = element;
          return;
        }
      });
    });


      this._city.text = LocalData.user.city;
      this._address.text = LocalData.user.address;
      this._zipCode.text = LocalData.user.zipCode;
      this._useSameForShip = LocalData.user.userForShip == 1? true: false;

  }


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _key,
      autovalidate: _autoValidate,
      child: Column(children: <Widget>[
        Text("Manage Address",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
        SizedBox(height: 10,),
        SimpleFutureBuilder<List<Country>>.simpler(
          context: context,
          future: _countriesFuture,
          builder: (AsyncSnapshot<List<Country>> snapshot){
            return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RoundDropDownButton<Country>(
                    hint: Text("Country"),
                    items: _countries == null? []: _countries.map((country) {
                      return DropdownMenuItem<Country>(
                        child: Text(country.name),
                        value: country,
                      );
                    }).toList(),
                    value: _selectedCountry,
                    onChanged: (item) => setState(() { this._selectedCountry = item;
                    FocusScope.of(context).requestFocus( FocusNode());
                    }),
                  ),
                );
          },
        ),
        _buildTextField(context, _city, "City*"),
        _buildTextField(context, _address, "Address*"),
        _buildTextField(context, _zipCode, "Zip Code*"),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Checkbox(
              value: _useSameForShip,
              checkColor: Colors.primaries[0],
              onChanged: (bool value){
                setState(() {
                  _useSameForShip=value;
                });
//                print(_useSameForShip);
              },
            ),
            Text('Use Same Address For Shipping'),
          ],
        ),
        SizedBox(
          height: 40,
          child: RaisedButton(
              child: Text("Update Address",style: TextStyle(color: Colors.white),),
              onPressed: () async {
                FocusScope.of(context).unfocus();
                if(_key.currentState.validate()){

                  FormData _updateAddress = FormData.fromMap({
                    'id': LocalData.user.id,
                    'country_id' : _selectedCountry.id,
                    'city' : _city.text,
                    'zip_code' : _zipCode.text,
                    'address' : _address.text,
                    'use_for_ship' : _useSameForShip ? 1 : 0,
                  });

                  openLoadingDialog(context, "Updating Address...");
                  await Service.post('update-address', _updateAddress);
                  LocalData.user.city = _city.text;
                  LocalData.user.address = _address.text;
                  LocalData.user.zipCode = _zipCode.text;
                  LocalData.user.countryId = _selectedCountry.id;
                  LocalData.user.userForShip = _useSameForShip? 1: 0;
                  LocalData.writeData();
                  Navigator.of(context).pop();
                  Scaffold.of(context).showSnackBar(SnackBar(content: Text("Address Updated!"),
                    behavior: SnackBarBehavior.floating,
                    shape:RoundedRectangleBorder(),));
                  Future.delayed(Duration(seconds: 2), () {
                    Navigator.of(context).pop('Updated');
                  });

//                  print(_updateAddress.fields);

                }else{
                  setState(() {
                    _autoValidate=true;
                  });
                }


              },
              color: Colors.primaries[0],
              shape: StadiumBorder(),
            ),
          ),
        SizedBox(height: 20,),
      ],),
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
          validator: (value){
              return value.isEmpty ? 'Please enter $labelText' : null;
          },
          controller: textFieldController,
          inputFormatters:  labelText == 'Zip Code*' ? <TextInputFormatter>[
            WhitelistingTextInputFormatter.digitsOnly
          ]: null,
          keyboardType: labelText == 'Zip Code*' ? TextInputType.phone : TextInputType.text,
          decoration: InputDecoration(
            labelText: labelText,
            border: OutlineInputBorder(),
          ),
        ),
      );
}

