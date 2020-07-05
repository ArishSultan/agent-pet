import 'dart:convert';
import 'package:agent_pet/src/models/user.dart';
import 'package:agent_pet/src/services/_service.dart';
import 'package:agent_pet/src/utils/local-data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;


class AuthService {
  logIn(User user, BuildContext context, [dialog = true]) async {
    if (dialog) {
      _openLoadingDialog(context, 'Logging In...');
    }

    http.Response res;

    try {
      /// Make Auth Request to REST API.
      res = await http.post('$apiUrl/api/login', body: {
        'email': user.email,
        'password': user.password
      });

      if (res.statusCode > 400)
        throw Exception(res.body);

      /// Set Login to true;
      LocalData.signIn(User.fromJson(jsonDecode(res.body)["user"][0]));
      Navigator.of(context).pop();
    } catch (e) {
      print(e);
      print(      res.statusCode
      );

      switch(res.statusCode){

        case 401:
         await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text('Authentication failed. You entered an incorrect username or password.'),
                      Align(
                        child: FlatButton(onPressed: ()=> Navigator.of(context).pop(),
                          child: Text("Ok"),
                        ),
                        alignment: Alignment.bottomRight,
                      )
                    ],
                  ),
                );
              }
          );
         break;
        case 404:
        default: await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("Error: ${e.toString()}"),
                  Align(
                    child: FlatButton(onPressed: ()=> Navigator.of(context).pop(),
                      child: Text("Ok"),
                    ),
                    alignment: Alignment.bottomRight,
                  )
                ],
              ),
            );
          }
      );

      }

//      await showDialog(
//        context: context,
//        builder: (context) {
//          return AlertDialog(
//            title: Text('Error while logging in'),
//            content: Text('Check your network and credentials'),
//
//            actions: <Widget>[
//              FlatButton(child: Text('Ok'), onPressed: () { Navigator.of(context).pop(); })
//            ],
//          );
//        }
//      );

      throw e;
    }
  }

  register(User user, BuildContext context, [dialog = true]) async {
    if (dialog) {
      _openLoadingDialog(context, 'Registering User');
    }

    http.Response res;

    try {
      /// Make Auth Request to REST API.
      res = await http.post('$apiUrl/api/register', body: {
        'name': user.name,
        'email': user.email,
        'phone': user.phone,
        'password': user.password
      });


      if (res.body=='User Exists'){
        Navigator.of(context).pop();
        await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('User Already Exists!'),
                content: Text('Please login'),

                actions: <Widget>[
                  FlatButton(child: Text('Ok'), onPressed: () {
                    FocusNode().unfocus();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();

                  })
                ],
              );
            }
        );
      }

      else if (res.statusCode > 400){
        throw Exception(res.body);
      }


      else{
        //Successfully Registered
        print(res.body);

        res = await http.post('$apiUrl/api/login', body: {
          'email': user.email,
          'password': user.password
        });

        LocalData.signIn(User.fromJson(jsonDecode(res.body)["user"][0]));



        Navigator.of(context).pop();
      print("Registered and logged in");
//        await showDialog(
//            context: context,
//            builder: (context) {
//              return AlertDialog(
//                title: Text('Registered!'),
//                content: Text('You may login now!'),
//
//                actions: <Widget>[
//                  FlatButton(child: Text('Ok'), onPressed: () {
//                    FocusNode().unfocus();
//                    Navigator.of(context).pop();
//                    Navigator.of(context).pop();
//
//                  })
//                ],
//              );
//            }
//        );
      }

      /// Set the Bearer Token for the Global Fetcher.
      ///
//      LocalData.token = jsonDecode(res.body)['token'];
//      LocalData.writeData();
    } catch (e) {
      print(e);
      Navigator.of(context).pop();

      await showDialog(
          context: context,
          builder: (context) {
        return AlertDialog(
          title: Text('Error while Registering'),
          content: Text('Error: ${e.toString()}'),

          actions: <Widget>[
            FlatButton(child: Text('Ok'), onPressed: () { Navigator.of(context).pop(); })
          ],
        );
      }
    );

    throw e;
  }
  }

  logOut() {
    LocalData.signOut();
  }

  _openLoadingDialog(BuildContext context, String text) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(children: <Widget>[
          SizedBox(
            width: 30,
            height: 30,
            child: CircularProgressIndicator(
              strokeWidth: 1,
              valueColor: AlwaysStoppedAnimation(Colors.black)
            )
          ),

          SizedBox(width: 10),

          Text(text)
        ]),
      )
    );
  }

  static facebookAuth(BuildContext context ) async {
    final facebookLogin = FacebookLogin();

    final authResult = await facebookLogin.logIn(["email", "public_profile"]);

    switch (authResult.status) {
      case FacebookLoginStatus.loggedIn:
        var token = authResult.accessToken.token;
        final graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=$token');
        final profile = json.decode(graphResponse.body);
        int _userId= int.parse(profile['id']);
        print(_userId);

          await AuthService().socialAuth(User(
              name: profile['name'],
              email: profile['email'],
              id: _userId,
          ), context);


        break;
      case FacebookLoginStatus.cancelledByUser:
        break;
      case FacebookLoginStatus.error:
        print("FB login error");
        print(authResult.errorMessage);
        print(FacebookLoginStatus.error.toString());
        break;
    }
  }

  static googleAuth(BuildContext context) async {
    final authentication = await GoogleSignIn().signIn().catchError((e){
      print(e);
      throw e;
    });
    print(authentication);
    await AuthService().socialAuth(User(
      name: authentication.displayName,
      email: authentication.email,
      id: 00000,
    ), context);

  }



  socialAuth(User user, BuildContext context,[bool signu] ) async {
    print(user.id);
    print(user.email);
    print(user.name);

      _openLoadingDialog(context, 'Logging In...');


    http.Response res;

    try {
      /// Make Auth Request to REST API.
      ///
      res = await http.post('$apiUrl/api/social-auth', body: {
        'name': user.name,
        'email': user.email,
        'id': user.id.toString()
      });


      if (res.statusCode > 400){
        throw Exception(res.body);
      }


      else{
        //Successfully Signed Up / Logged In
        print(res.body);


        LocalData.signIn(User.fromJson(jsonDecode(res.body)));

        Navigator.of(context).pop();
        Navigator.of(context).pop();

//        print("Social Auth Completed");
      }

    } catch (e) {
      throw e;
      print(e);
      Navigator.of(context).pop();

      await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error while authenticating via Social Auth'),
              content: Text('Error: ${e.toString()}'),
              actions: <Widget>[
                FlatButton(child: Text('Ok'), onPressed: () { Navigator.of(context).pop(); })
              ],
            );
          }
      );

      throw e;
    }
  }


}