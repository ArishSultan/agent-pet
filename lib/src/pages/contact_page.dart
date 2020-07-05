import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Contact extends StatefulWidget {
  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  var _formKey = GlobalKey<FormState>();
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _autoValidate = false;

  TextEditingController fullName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController subject = TextEditingController();
  TextEditingController message = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar( 
        title: Text("Contact Us"),
        leading: IconButton(
          icon: Icon(
            CupertinoIcons.back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body:  SingleChildScrollView(
        child: Form(
          key: _formKey,
          autovalidate: _autoValidate,
          child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RichText(
                    text: TextSpan(
                        text: 'Feel free to drop by or call to say ',
                        style: TextStyle(color: Colors.primaries[0], fontSize: 24),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Hello!',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ]),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                _buildTextField(context, fullName, "Full Name"),
                _buildTextField(context, email, "Your Email"),
                _buildTextField(context, subject, "Subject"),
                _buildTextField(context, message, "Message"),
                SizedBox(
                  height: 20,
                ),


                FlatButton(

                  onPressed: (){
                    if(_formKey.currentState.validate()){
                      FocusScope.of(context).requestFocus(FocusNode());
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text("We have received your message and will contact you shortly."),
                      ));
                      Future.delayed(Duration(seconds: 2),
                              () => Navigator.of(context).pop());
                    }else{
                      setState(() {
                        _autoValidate=true;
                      });
                    }
                  },
                  color: Colors.primaries[0],
                  child: Text(
                    "SUBMIT",
                    style: TextStyle(color: Colors.white),
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
            validator: (value){
              if(value.isEmpty){
                return 'Please enter $labelText';
              }
              if(labelText=='Your Email' && !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)){
                return 'Please provide a valid email';
              }
              return null;
            },
            controller: textFieldController,
            keyboardType: labelText == 'Your Email' ? TextInputType.emailAddress : TextInputType.text,
            decoration: InputDecoration(
              labelText: labelText,
              labelStyle: TextStyle(fontSize: 12.0),
              border: OutlineInputBorder(),
              prefixIcon: labelText == 'Full Name' ? Icon(Icons.person) : (labelText == 'Your Email' ? Icon(Icons.email) : (labelText == 'Message' ? Icon(Icons.message) : Icon(Icons.subject)))
            ),
          ));
}
