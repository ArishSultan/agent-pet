import 'package:agent_pet/src/base/assets.dart';
import 'package:agent_pet/src/pages/pet-relocation/main-pet-relocation.dart';
import 'package:agent_pet/src/services/_service.dart';
import 'package:agent_pet/src/utils/custom-navigator.dart';
import 'package:agent_pet/src/widgets/bullet-point-widget.dart';
import 'package:agent_pet/src/widgets/dialogs/loading-dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'search-pages/pet-search-page.dart';

class Relocation extends StatefulWidget {
  @override
  _RelocationState createState() => _RelocationState();
}

class _RelocationState extends State<Relocation> {
  var _formKey = GlobalKey<FormState>();
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _autoValidate = false;
  TextEditingController fullName = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 70),
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.primaries[0],
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: (){
                  CustomNavigator.navigateTo(context, PetSearchPage());
                },
                child: Container(
                  height: 48.0,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0,right: 8),
                        child: Icon(Icons.search,size: 22,),
                      ),
                      Text("Search",style: TextStyle(fontSize: 16),),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Form(
                key: _formKey,
                autovalidate: _autoValidate,
                child: Column(

                  children: <Widget>[

                    Text("Pet Reloctaion Made Easy",style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                    ),),

                    SizedBox(
                      height: 20,
                    ),
                    ClipRRect(child:
                    Image.asset(Assets.howItWorks3, scale: 3),
                      borderRadius: BorderRadius.circular(10),),
                    Center(child: Text("Now along with your luggage you can move your pets too! You don’t have to say your good-byes or sell your beloved pets, all you have to do is contact our website Agentpet.com",style: TextStyle(
                        fontSize: 15
                    ),)),
                    SizedBox(height: 6,),
                    bulletPoint(title: 'Dedicated team of multilingual experienced and knowledgeable specialists.'),
                    bulletPoint(title: 'Full consultation on animal import and export regulations.'),
                    bulletPoint(title: 'Veterinary and travel document compliance review.'),
                    bulletPoint(title: 'Preparation and submission of all necessary documentation (i.e. pet animal import license).'),
                    bulletPoint(title: 'Consultation and planning of routing and transport options.'),

                    SizedBox(height: 20,),

                    Text("Relocate Your Pet",style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                    ),),
                    _buildTextField(context, fullName, 'Name*'),
                    _buildTextField(context, email, 'Email*'),
                    _buildTextField(context, phone, 'Phone*'),

                    FlatButton(

                      onPressed: () async {
                        if(_formKey.currentState.validate()){
                          FocusScope.of(context).requestFocus(FocusNode());

                          openLoadingDialog(context, 'Sending your request...');
                          var _callBack = FormData.fromMap({
                            'owner_name': fullName.text,
                            'owner_email' : email.text,
                            'owner_phone' : phone.text,
                          });
//                          await Service.post('pet-move-callback', _callBack);
//                          fullName.clear();
//                          email.clear();
//                          phone.clear();
                          Navigator.of(context).pop();
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text("Request Submitted Successfully"),
                            behavior: SnackBarBehavior.floating,
                            shape:RoundedRectangleBorder(),
                          ));

                        }else{
                          setState(() {
                            _autoValidate=true;
                          });
                        }
                      },
                      color: Colors.primaries[0],
                      child: Text(
                        "Request a Callback",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("OR",style: TextStyle(color: Colors.white),),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black
                        ),
                      ),
                    ),
                    RaisedButton(
                      onPressed: (){
                        CustomNavigator.navigateTo(context, PetRelocationPage());
                      },
                      color: Colors.primaries[0],
                      child: Text(
                        "Get a Quote",
                        style: TextStyle(color: Colors.white,),
                      ),
                    ),

                    SizedBox(height: 20,),


                  ],
                ),
              ),
            ),
          ),
        ],
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
            textInputAction: TextInputAction.go,
            controller: textFieldController,
            keyboardType: labelText == 'Email*' ? TextInputType.emailAddress : ( labelText == 'Phone*' ? TextInputType.phone : TextInputType.text),
            decoration: InputDecoration(
              isDense: true,
                labelText: labelText,
                labelStyle: TextStyle(fontSize: 12.0),
                border: OutlineInputBorder(),
            ),
          ));

}
