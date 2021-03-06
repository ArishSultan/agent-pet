import 'package:agent_pet/src/models/user.dart';
import 'package:agent_pet/src/pages/auth/sign-up_page.dart';
import 'package:agent_pet/src/services/auth_service.dart';
import 'package:agent_pet/src/utils/custom-navigator.dart';
import 'package:agent_pet/src/widgets/dialogs/forgot-password-dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _username = TextEditingController();
  var _loginFormKey = GlobalKey<FormState>();
  bool _autovalidate = false;
  final _password = TextEditingController();

  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In"),
      ),
      body: Material(
        color: Colors.white,

        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),

          child: Center(
            child: SingleChildScrollView(
              child: Form(
                autovalidate: _autovalidate,
                key: _loginFormKey,
                child: Column(

                    children: <Widget>[
//                SizedBox(height: 20),

                  Image.asset('assets/agent-pet-background.png', width: 250),

                  SizedBox(height: 40),
                  _buildTextField(context, this._username, 'Email Address'),

                  SizedBox(height: 7),
                  _buildTextField(context, this._password, 'Password'),

                  GestureDetector(
                    onTap: (){

                      showDialog(
                          context: context,
                        child:  ForgotPasswordDialog(),

                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical:8.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                          child: Text("Forgot Password?",style: TextStyle(color: Colors.primaries[0]),)),
                    ),
                  ),

                  SizedBox(height: 5),

                  MaterialButton(
                    elevation: 0,
                    highlightElevation: 0,
                    child: Text('Log In'),
                    minWidth: double.infinity,
                    color: Theme.of(context).primaryColor,
                    onPressed: () async {
                      FocusScope.of(context).requestFocus( FocusNode());
                      FocusScope.of(context).requestFocus( FocusNode());
                      if(_loginFormKey.currentState.validate()){
                        try {
                          await AuthService().logIn(User(
                              email: _username.text,
                              password: _password.text
                          ), context);
                        } catch (e) {}
                        Navigator.of(context).pop();
                      }else{
                        setState(() {
                          _autovalidate=true;
                        });
                      }
                    },
                  ),

                  SizedBox(height: 10),

                  Row(children: <Widget>[
                    Expanded(child: Divider()),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('or sign in with', style: TextStyle(color: Colors.grey)),
                    ),

                    Expanded(child: Divider())
                  ]),

                  SizedBox(height: 10),

                  _LogInWithButton(name: 'facebook', color: Color(0xff45619D), onPressed: () {
                    AuthService.facebookAuth(context);
                  }),
//              _LogInWithButton(name: 'twitter', color: Color(0xff55ACEE), onPressed: () {
//
//              }),
                  _LogInWithButton(name: 'google', color: Color(0xffF1574A), onPressed: () {
                    AuthService.googleAuth(context);
                  }),

                  SizedBox(height: 10),

                  Row(children: <Widget>[
                    Expanded(child: Divider()),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('register', style: TextStyle(color: Colors.grey)),
                    ),

                    Expanded(child: Divider())
                  ]),

                  SizedBox(height: 10),

                  Row(children: <Widget>[
                    Text("New User ? ", style: TextStyle(color: Colors.grey)),
                    GestureDetector(
                      child: Text("Sign up here", style: TextStyle(
                        color: Theme.of(context).primaryColor)
                      ),

                      onTap: () {
                        CustomNavigator.navigateTo(context, SignUpPage());
                      },
                    ),
                  ])
                ]),
              )
            ),
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
      TextFormField(
        validator: (value){
          if(value.isEmpty){
            return 'Please enter $labelText';
          }
          if(labelText=='Email Address' && !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)){
            return 'Please provide a valid email';
          }
          return null;
        },
        controller: textFieldController,

        obscureText: labelText == 'Password' ? obscurePassword : false,
        keyboardType: labelText == 'Email Address' ? TextInputType.emailAddress : TextInputType.text,
        decoration: InputDecoration(
          isDense: true,
          labelText: labelText,
          border: OutlineInputBorder(),
          suffixIcon: (labelText=='Password') ? IconButton(
            icon: obscurePassword ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
            tooltip: 'Show Password',
            onPressed: ()=>  setState(() {
              obscurePassword = !obscurePassword;
            }),
          ) : null,
        ),
      );
}

class _LogInWithButton extends MaterialButton {
  _LogInWithButton({
    String name,
    Color color,
    Function onPressed
  }): super(
    elevation: 0,
    highlightElevation: 0,
    child: Row(children: <Widget>[
      Expanded(flex: 2, child: Image.asset('assets/social/$name-logo.png', height: 25)),
      Expanded(flex: 5, child: Text('Log in with ${name[0].toUpperCase() + name.substring(1)}', style: TextStyle(color: Colors.white)))
    ], mainAxisAlignment: MainAxisAlignment.center),
    minWidth: double.infinity,
    color: color,
    onPressed: onPressed
  );
}
