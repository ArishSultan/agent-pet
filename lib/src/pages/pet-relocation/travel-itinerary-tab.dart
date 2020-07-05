import 'package:agent_pet/src/models/country.dart';
import 'package:agent_pet/src/services/misc-service.dart';
import 'package:agent_pet/src/services/country-service.dart';
import 'package:agent_pet/src/widgets/custom-datepicker.dart';
import 'package:agent_pet/src/widgets/custom-flat-button.dart';
import 'package:agent_pet/src/widgets/round-drop-down-button.dart';
import 'package:agent_pet/src/utils/simple-future-builder.dart';
import 'package:flutter/material.dart';
import 'pet_relocation-data.dart';

class TravelItinerary extends StatefulWidget {
  final TabController controller;
  TravelItinerary({this.controller});
  @override
  State<StatefulWidget> createState() {
    return TravelItineraryState();
  }
}

class TravelItineraryState extends State<TravelItinerary>with AutomaticKeepAliveClientMixin {

  var travelFormKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  Future<List<Country>> _countriesFuture;
  List<Country> _countries;
  TextEditingController departureCity= TextEditingController();
  TextEditingController arrivalCity= TextEditingController();
  TextEditingController comments= TextEditingController();
  List<String> cities;
  var _service = MiscService();
  DateTime dateOfTravel = DateTime.now();
  Country selectedDepartureCountry;
  Country selectedArrivalCountry;

  @override
  void initState() {
    super.initState();
    _countriesFuture = CountryService().getAll('countries');
    _countriesFuture.then((data) {
      _countries = data;
    });
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    InheritedPetRelocation.of(context).selectedDepartureCountry =  selectedDepartureCountry;
    InheritedPetRelocation.of(context).selectedArrivalCountry =  selectedArrivalCountry;
    InheritedPetRelocation.of(context).departureCity = departureCity;
    InheritedPetRelocation.of(context).arrivalCity = arrivalCity;
    dateOfTravel = InheritedPetRelocation.of(context).dateOfTravel;
    InheritedPetRelocation.of(context).comments =comments;

    return SingleChildScrollView(
      child: Padding(
          padding: EdgeInsets.all(8),
          child: Form(
            key: travelFormKey,
            autovalidate: _autoValidate,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                SimpleFutureBuilder<List<Country>>.simpler(
                  context: context,
                  future: _countriesFuture,
                  builder: (AsyncSnapshot<List<Country>> snapshot){
                    return Column(
                      children: <Widget>[
                        RoundDropDownButton<Country>(

                          hint: Text("Departure Country*"),
                          items: _countries == null? []: _countries.map((country) {
                            return DropdownMenuItem<Country>(
                              child: Text(country.name),
                              value: country,
                            );
                          }).toList(),
                          value: selectedDepartureCountry,
                          onChanged: (item) => setState(() { this.selectedDepartureCountry = item;
                          FocusScope.of(context).requestFocus( FocusNode());
                          }),
                        ),
                        SizedBox(height: 10),
                        RoundDropDownButton<Country>(
                          hint: Text("Arrival Country*"),
                          items: _countries == null? []: _countries.map((country) {
                            return DropdownMenuItem<Country>(
                              child: Text(country.name),
                              value: country,
                            );
                          }).toList(),
                          value: selectedArrivalCountry,
                          onChanged: (item) => setState(() { this.selectedArrivalCountry = item;
                          FocusScope.of(context).requestFocus( FocusNode());
                          }),
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: 10),
                _buildTextField(context, departureCity, "Departure City*"),

                SizedBox(height: 10),
                _buildTextField(context, arrivalCity, "Arrival City*"),
                SizedBox(height: 10),
                DatePickerField(
                  title: "Estimated Date Of Travel",
                  onChanged: (date) {
                    dateOfTravel = date;
                  },
                ),
                SizedBox(height: 10,),
                _buildTextField(context, comments, "Comments"),
                SizedBox(height: 20),
                CustomFlatButton(
                  title: 'Next',
                  onPressed: (){
                    if(travelFormKey.currentState.validate()){
                      setState(() {
                        isDisabledPetRelocation[widget.controller.index+1] = false;
                      });
                      widget.controller.animateTo(widget.controller.index+1);
                    }else{
                      setState(() {
                        _autoValidate = true;
                      });
                    }
                  },
                ),

              ],
            ),
          )
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
          if(labelText=='Comments'){
            return null;
          }
          return value.isEmpty ? 'Please enter $labelText' : null;
        },
        controller: textFieldController,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
        ),
      );

  @override
  bool get wantKeepAlive => true;
}
