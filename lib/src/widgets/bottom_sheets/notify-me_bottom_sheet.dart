import 'package:agent_pet/src/models/pet-type.dart';
import 'package:agent_pet/src/services/_service.dart';
import 'package:agent_pet/src/services/misc-service.dart';
import 'package:agent_pet/src/services/pet-type_service.dart';
import 'package:agent_pet/src/utils/simple-future-builder.dart';
import 'package:agent_pet/src/widgets/dialogs/loading-dialog.dart';
import 'package:agent_pet/src/widgets/round-drop-down-button.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotifyBottomSheet extends StatefulWidget {
  final GlobalKey<ScaffoldState> listingKey;
  NotifyBottomSheet({this.listingKey});
  @override
  _NotifyBottomSheetState createState() => _NotifyBottomSheetState();
}

class _NotifyBottomSheetState extends State<NotifyBottomSheet> {

  final _email = TextEditingController();

  int _selectedInterval = 0;
  final _intervals = <bool>[true, false, false];
  int _sortValue;
  Future<List<PetType>> _petTypesFuture;
  List<PetType> _petTypes;
  PetType _selectedPetType;
  Future _citiesFuture;
  List<String> _cities;
  String _selectedCity;
  var _service = MiscService();
  var _emailFormKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  void _sortChanges(int value) {
    setState(() {
      _sortValue = value;
    });
  }

  var _style = TextStyle(color: Colors.white);

  @override
  void initState() {
    super.initState();
    _petTypesFuture = PetTypeService().getAll('pet-types');

    _petTypesFuture.then((data) {
      _petTypes = data;
    });

    _citiesFuture = _service.getCities().then((e){
      if(this.mounted){
        setState(() {
          _cities = e;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child:  Form(
        key: _emailFormKey,
        autovalidate: _autoValidate,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:8.0,vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Create Email Alert",style: TextStyle(color: Colors.primaries[0],fontWeight: FontWeight.bold,fontSize: 15),),
                  ),
                  FlatButton(
                    splashColor: Colors.grey.shade200,
                    child: Text("Cancel",style: TextStyle(color: Colors.primaries[0]),),
                    onPressed: ()=> Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Divider(),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text("Receive Email updated for latest ads related to pets.",style: TextStyle(fontWeight: FontWeight.bold),),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(12, 10, 12, MediaQuery.of(context).viewInsets.bottom),
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  isDense: true,
                  fillColor: Colors.grey.shade200,
                  hintText: 'name@email.com',
                  suffixIcon: Icon(Icons.search),
                  border: OutlineInputBorder()
                ),
                validator: (value) {
                  if(value.isEmpty){
                    return 'Please enter email';
                  }
                  if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)){
                    return 'Please provide a valid email';
                  }
                  return null;
                },
                controller: _email,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              child:
                SimpleFutureBuilder<List<PetType>>.simpler(
                  context: context,
                  future: _petTypesFuture,
                  builder: (AsyncSnapshot<List<PetType>> snapshot) {
                    return Row(
                      children: <Widget>[
                        Expanded(
                          child: RoundDropDownButton<PetType>(
                            hint: Text("Pet Type*"),
                            items: _petTypes.map((petType) {
                              return DropdownMenuItem<PetType>(
                                child: Text(petType.name),
                                value: petType,
                              );
                            }).toList(),
                            value: _selectedPetType,
                            onChanged: (item) => setState(() {
                              _selectedPetType = item;
                              FocusScope.of(context).requestFocus( FocusNode());
                            }),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(child:  RoundDropDownButton<String>(
                          hint: Text("Select City*"),
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
                        ),)
                      ],
                    );
                  },
                ),


            ),

            ToggleButtons(
              borderWidth: 10,
              borderColor: Colors.transparent,
              selectedBorderColor: Colors.transparent,
              fillColor: Colors.transparent,
              children: <Widget>[
                _Chip(icon: Icon(Icons.done, size: 20,color: Colors.white,), text: Text('Daily',style: _style,), b: _intervals[0]),
                _Chip(icon: Icon(Icons.done, size: 20,color: Colors.white,), text: Text('Weekly',style: _style), b: _intervals[1]),
                _Chip(icon: Icon(Icons.done, size: 20,color: Colors.white,), text: Text('Monthly',style: _style), b: _intervals[2])
              ],
              onPressed: (v) {
                setState(() {
                  if (this._selectedInterval > -1)
                    this._intervals[this._selectedInterval] = false;
                  this._intervals[v] = true;

                  print(this._intervals);

                  this._selectedInterval = v;
                });
              },
              isSelected: this._intervals
            ),

            Divider(indent: 10, endIndent: 10),

            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: ConstrainedBox(
                constraints: BoxConstraints.expand(height: 40),
                child: FlatButton(

                  child: Text('Create'),
                  color: Colors.primaries[0],
                  onPressed: () async {

                    if(_emailFormKey.currentState.validate()){
                      FocusScope.of(context).requestFocus(new FocusNode());
                      var _frequency = _intervals[0] ? 'Daily' : (_intervals[1] ? 'Weekly' : 'Monthly');
                      FormData _emailAlert = FormData.fromMap({
                        'type_id' : _selectedPetType!=null ? _selectedPetType.id : null,
                        'email': _email.text,
                        'city': _selectedCity,
                        'frequency' : _frequency
                      });
                       openLoadingDialog(context,'Saving Alert...');
                       await Service.post('save-alert',_emailAlert);
                       Navigator.of(context).pop();
                       Navigator.of(context).pop();

                       widget.listingKey.currentState.showSnackBar(SnackBar(
                         content: Text("Alert Saved!"),duration: Duration(seconds: 3),
                         behavior: SnackBarBehavior.floating,
                         shape:RoundedRectangleBorder(),
                       ));

                    }else{
                      setState(() {
                        _autoValidate=true;
                      });
                    }

                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _Chip extends Chip {
  _Chip({final Icon icon, final Text text, final bool b = false}): super(
    avatar: b ? icon: null,
    label: text,

    backgroundColor: b? Colors.red: Colors.grey
  );
}

