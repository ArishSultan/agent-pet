import 'dart:io';

import 'package:agent_pet/src/services/_service.dart';
import 'package:agent_pet/src/utils/local-data.dart';
import 'package:agent_pet/src/widgets/appBar.dart';
import 'package:agent_pet/src/widgets/custom-datepicker.dart';
import 'package:agent_pet/src/widgets/dialogs/loading-dialog.dart';
import 'package:agent_pet/src/widgets/loading-builder.dart';
import 'package:agent_pet/src/widgets/round-drop-down-button.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'manage-address_page.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AgentPetAppbar(context,"Edit Profile"),
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
            child: Column(
              children: <Widget>[
                EditFields(),
                AddressFields(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EditFields extends StatefulWidget {
  @override
  _EditFieldsState createState() => _EditFieldsState();
}

class _EditFieldsState extends State<EditFields> {

  Map<String, String> image = Map();

  var _key = GlobalKey<FormState>();
  bool _autoValidate = false;
  bool obscurePassword = true;

  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _password = TextEditingController();
  final _genders = <String>['Male', 'Female'];

  String selectedGender;
  DateTime _dob;


  @override
  void initState() {
    super.initState();

    if (LocalData.isSignedIn) {
//      print(LocalData.user.dateOfBirth);
      this._name.text = LocalData.user.name;
      this._email.text = LocalData.user.email;
      this._phone.text = LocalData.user.phone;
      if(LocalData.user.gender.isNotEmpty){
        selectedGender = LocalData.user.gender;
      }
      if(LocalData.user.dateOfBirth!=null){
        _dob = LocalData.user.dateOfBirth;
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _key,
      autovalidate: _autoValidate,
      child: Column(children: <Widget>[

        Padding(
          padding: EdgeInsets.only(top: 20.0),
          child:  Stack(fit: StackFit.loose, children: <Widget>[
             Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                 Container(
                    width: 140.0,
                    height: 140.0,
                    decoration:  BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.primaries[0])
                    ),
                 child: image.length==0 ? ClipRRect(
                   borderRadius: BorderRadius.circular(100),
                   child: LocalData.user.photo.isEmpty ? Image.asset(
                         'assets/icons/user.png',height: 140,width: 140,):Image.network(
                     Service.getConvertedImageUrl(LocalData.user.photo),
                     fit: BoxFit.cover,
                     loadingBuilder: circularImageLoader,
                   ),
                 ) : ClipRRect(
                   borderRadius: BorderRadius.circular(100),
                   child: Image.file(
                       File(image.values.first),
                       fit: BoxFit.cover,
                     ),
                 ),
                 ),
              ],
            ), InkWell(
                onTap: () async {
                  Map<String, String> tempImage;
                  try {
                    /// TODO: Fix Breaking Changes of FilePicker.
                    // tempImage = await FilePicker.getMultiFilePath(
                    //     type: FileType.IMAGE, fileExtension: '');
                  } on PlatformException catch (e) {
//                    print(e.message);
                    // Message Display.
                  }
                  if (mounted) setState(() {
                    image.clear();
                  tempImage!=null ? image.addAll(tempImage) : null;
                  });
//                  print(image.values);
                },
                child: Padding(
                    padding: EdgeInsets.only(top: 90.0, right: 100.0),
                    child:  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                         CircleAvatar(
                          backgroundColor: Colors.red,
                          radius: 25.0,
                          child:  Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                          ),
                        )
                      ],
                    )),
            ),
          ]),
        ),

        SizedBox(height: 10,),

        _buildTextField(context, _name, "Full Name*"),
        _buildTextField(context, _email, "Email*"),
        _buildTextField(context, _phone, "Phone*"),
        _buildTextField(context, _password, "Update Password"),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: RoundDropDownButton<String>(
            hint: Text("Gender*"),
            items: _genders.map((gender) {
              return DropdownMenuItem(
                child: Text(gender),
                value: gender,
              );
            }).toList(),
            value: selectedGender,

            onChanged: (item) => setState(() { this.selectedGender = item;
            FocusScope.of(context).requestFocus(new FocusNode());
            }),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DatePickerField(
            dob: _dob,
            title: "Date Of Birth",
            onChanged: (date) {
              _dob = date;
            },
          ),
        ),
        SizedBox(height: 10,),

        SizedBox(
          height: 40,
          child: RaisedButton(
            child: Text("Update Profile",style: TextStyle(color: Colors.white),),
            onPressed: () async {
              FocusScope.of(context).unfocus();
              if(_key.currentState.validate()){

                FormData _profile = FormData.fromMap({
                  "id" : LocalData.user.id,
                  "name" : _name.text,
                  "email" : _email.text,
                  "d_o_b" : _dob.toIso8601String(),
                  "gender" : selectedGender,
                  "password" : _password.text.isNotEmpty ? _password.text : null
                });

                if(image.length!=0){
                  _profile.files.add(MapEntry(
                      'profile_img',
                      await MultipartFile.fromFile(image.values.first, filename: "${image.values.first.split("/").last}")
                  ));
//                  print("image added");
                }

//                print(_profile.fields);

                openLoadingDialog(context, 'Updating Profile...');
                await Service.post('update-profile', _profile);
                LocalData.user.name = _name.text;
                LocalData.user.email = _email.text;
                LocalData.user.dateOfBirth = _dob;
                LocalData.user.gender = selectedGender;
                LocalData.writeData();
                Navigator.of(context).pop();
                Scaffold.of(context).showSnackBar(SnackBar(content: Text("Profile Updated!"),
                  behavior: SnackBarBehavior.floating,
                  shape:RoundedRectangleBorder(),));
                Future.delayed(Duration(seconds: 2),
                        () => Navigator.pop(context,"Updated")
                );

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
        SizedBox(height: 10,),
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
            inputFormatters: labelText == 'Phone*' ?  [WhitelistingTextInputFormatter.digitsOnly] : null,
            validator: (value){
              if(labelText=='Update Password'){
                return null;
              }
              if(value.isEmpty){
                return 'Please enter $labelText';
              }
              if(labelText=='Email*' && !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)){
                return 'Please provide a valid email';
              }
              return null;
            },
            obscureText: (labelText=='Update Password') ? obscurePassword : false,
            controller: textFieldController,
            keyboardType: labelText == 'Email*' ? TextInputType.emailAddress : ( labelText == 'Phone*' ? TextInputType.phone : TextInputType.text),
            decoration: InputDecoration(
                labelText: labelText,
                labelStyle: TextStyle(fontSize: 12.0),
                border: OutlineInputBorder(),
                prefixIcon: labelText == 'Full Name*' ? Icon(Icons.person) : (labelText == 'Email*' ? Icon(Icons.email) : (labelText == 'Phone*' ? Icon(Icons.phone) : null)),
              suffixIcon: (labelText=='Password') ? IconButton(
                icon: obscurePassword ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
                tooltip: 'Show Password',
                onPressed: ()=>  setState(() {
                  obscurePassword = !obscurePassword;
                }),
              ) : null,
            ),

          ));
}

