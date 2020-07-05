import 'package:agent_pet/src/services/_service.dart';
import 'package:agent_pet/src/utils/validators.dart';
import 'package:agent_pet/src/widgets/dialogs/loading-dialog.dart';
import 'package:agent_pet/src/widgets/dialogs/message-dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ForgotPasswordDialog extends StatefulWidget {
  @override
  State createState() => new ForgotPasswordDialogState();
}

class ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  var _reportKey = GlobalKey<FormState>();
  bool _autoValidate =  false;
  var email = TextEditingController();

  Widget build(BuildContext context) {
    return  AlertDialog(
      title: Text("Please provide email to reset password",style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16
      ),),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _reportKey,
                autovalidate: _autoValidate,
                child: TextFormField(
                    validator: (value) => emailValidator(value),
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(fontSize: 12.0),
                      border: OutlineInputBorder(),
                    )),
              ),
            ) ,
            SizedBox(
              height: 40,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60.0),
                child: RaisedButton(
                  child: Text("Submit",style: TextStyle(color: Colors.white),),
                  onPressed: () async {
//                  FormData _report = FormData.fromMap({
//                    'email' : email.text,
//                  });
////                  print(_report.fields);
//                    if(_reportKey.currentState.validate()){
//                      openLoadingDialog(context, "Reporting Ad...");
//                      await Service.post('report-ad', _report);
//                      Navigator.of(context).pop();
//                      Navigator.of(context).pop();
//                    }
//                    else{
//                      setState(() {
//                        _autoValidate=true;
//                      });
//                    }
                  Navigator.pop(context);
                  openLoadingDialog(context, 'Submitting..');
                  Future.delayed(Duration(seconds: 2),()=> Navigator.of(context).pop()
                  );
                  Future.delayed(Duration(seconds: 2),()=> openMessageDialog(context, 'Please see your email for resetting your password')
                  );


                  },
                  color: Colors.primaries[0],
                  shape: StadiumBorder(),
                ),
              ),
            ),

          ],
          ),
    );
  }

}
