
import 'package:agent_pet/src/models/user.dart';
import 'package:agent_pet/src/services/auth_service.dart';
import 'package:agent_pet/src/widgets/custom-form-field.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  // Validation Key
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _key = GlobalKey<FormState>();

  bool _autovalidate=false;

  bool _sendUpdates = false;
  bool passObscure = true;
  bool obscureCheck = false;

  bool confirmPassObscure = true;

  final _name = TextEditingController();

  final _phone = TextEditingController();

  final _username = TextEditingController();

  final _password = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign Up"),),
      body: Material(
        color: Colors.white,

        child: SingleChildScrollView(
            child: Form(
              autovalidate: _autovalidate,
              key: _key,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(children: <Widget>[

                      SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(
                          icon: Icon(Icons.mail),
                          isDense: true,
                          labelText: 'Email Address',
                          hintText: 'Enter Email ',

                        ),
                        keyboardType:TextInputType.emailAddress ,

                        controller: this._username,
                        validator: (val) {
                          if (val.isEmpty)
                            return "Please enter email";
                          if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val)){
                            return 'Please provide a valid email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        decoration: InputDecoration(
                          icon: Icon(Icons.person),
                          isDense: true,
                          labelText: 'Name ',
                          hintText: 'Enter Name ',
                        ),
                        validator: (val) {
                          if (val.isEmpty)
                            return "Please enter full name";
                          return null;
                        },
                        controller: this._name,
                      ),

                      SizedBox(height: 7),
                      TextFormField(
                        decoration: InputDecoration(
                          icon: Icon(Icons.local_phone),
                          isDense: true,
                          labelText: 'Phone ',
                          hintText: 'Enter Phone Number ',
                        ),
                        keyboardType:TextInputType.phone ,
                        validator: (val) {
                          if (val.isEmpty)
                            return "Please enter phone number";
                          if (val.length < 11)
                            return "Phone number must be at least 11";
                          return null;
                        },
                        controller: this._phone,
                      ),

                      SizedBox(height: 7),
                      TextFormField(
                        decoration: InputDecoration(
                          icon: Icon(Icons.vpn_key),
                          isDense: true,
                          labelText: 'Password ',
                          hintText: 'Enter Password',
                        ),
                        obscureText: passObscure,
                        validator: (val){
                          if (val.isEmpty)
                            return "Please enter password";
                          if(val.length < 6)
                           return " The password must be at least 6 characters.";
                          return null;
                        },
                        controller: this._password,
                      ),

                      SizedBox(height: 7),

                    ]),
                  ),

                  CheckboxListTile(
                    dense: true,
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text("Show Password"),
                    value: obscureCheck,
                    checkColor: Colors.primaries[0],
                    onChanged: (bool val){
                      setState(() {
                        obscureCheck =val;
                        passObscure=!passObscure;
                      });
                    },

                  ),


                  CheckboxListTile(
                    dense: true,
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text("Send me useful updates"),
                    value: _sendUpdates,
                    checkColor: Colors.primaries[0],
                    onChanged: (bool val){
                      setState(() {
                        _sendUpdates=val;
                      });
                    },

                  ),

                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: <Widget>[
                        MaterialButton(
                          elevation: 0,
                          highlightElevation: 0,
                          child: Text('Sign Up'),
                          minWidth: double.infinity,
                          color: Theme.of(context).primaryColor,
                          onPressed: () async {
                            if (this._key.currentState.validate()) {
                              try {
                                await AuthService().register(User(
                                    name: _name.text,
                                    phone: _phone.text,
                                    email: _username.text,
                                    password: _password.text,
                                    sendUpdates: _sendUpdates ? 1 : 0
                                ), context);

//                        CustomNavigator.navigateTo(context, HomePage());

                              } catch (e) {print(e.toString());}
                            }else{
                              setState(() {
                                _autovalidate=true;
                              });
                            }
                          },
                        ),

                        SizedBox(height: 10),

//                        Row(children: <Widget>[
//                          Expanded(child: Divider()),
//
//                          Padding(
//                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                            child: Text('or sign up with', style: TextStyle(color: Colors.grey)),
//                          ),
//
//                          Expanded(child: Divider())
//                        ]),
//
//                        SizedBox(height: 10),
//
//                        _SignUpWithButton(name: 'facebook', color: Color(0xff45619D), onPressed: () {
//                          AuthService.facebookAuth(context);
//
//                        }),
////                _SignUpWithButton(name: 'twitter', color: Color(0xff55ACEE), onPressed: () {
////
////                }),
//                        _SignUpWithButton(name: 'google', color: Color(0xffF1574A), onPressed: () {
//                          AuthService.googleAuth(context);
//                        }),
//
//                        SizedBox(height: 10),
//
//                        Row(children: <Widget>[
//                          Expanded(child: Divider()),
//
//                          Padding(
//                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                            child: Text('log in', style: TextStyle(color: Colors.grey)),
//                          ),
//
//                          Expanded(child: Divider())
//                        ]),
//
//                        SizedBox(height: 10),
//
//                        Row(children: <Widget>[
//                          Text("Already a member ? ", style: TextStyle(color: Colors.grey)),
//                          GestureDetector(
//                            child: Text("Log in here", style: TextStyle(
//                                color: Theme.of(context).primaryColor)
//                            ),
//
//                            onTap: () {
//                              Navigator.of(context).pop();
//                            },
//                          ),
//                        ]),
//
//                        SizedBox(height: 20),
                      ],
                    ),
                  )

                ],
              ),
            )
        ),
      ),
    );
  }
}

class _SignUpWithButton extends MaterialButton {
  _SignUpWithButton({
    String name,
    Color color,
    Function onPressed
  }): super(
      elevation: 0,
      highlightElevation: 0,
      child: Row(children: <Widget>[
        Expanded(flex: 2, child: Image.asset('assets/social/$name-logo.png', height: 25)),
        Expanded(flex: 5, child: Text('Sign up with ${name[0].toUpperCase() + name.substring(1)}', style: TextStyle(color: Colors.white)))
      ], mainAxisAlignment: MainAxisAlignment.center),
      minWidth: double.infinity,
      color: color,
      onPressed: onPressed
  );
}



