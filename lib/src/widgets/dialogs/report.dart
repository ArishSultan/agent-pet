import 'package:agent_pet/src/services/_service.dart';
import 'package:agent_pet/src/widgets/dialogs/loading-dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ReportDialog extends StatefulWidget {
  final int petId;
  ReportDialog({this.petId});
  @override
  State createState() => new ReportDialogState();
}

class ReportDialogState extends State<ReportDialog> {
  var _reportKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  var inputReason = TextEditingController();
  int _radioValue;
  String choice;
  String reportOption;
  String reason = 'Duplicate';
  bool _other = false;
  @override
  void initState() {
    setState(() {
      _radioValue = 1;
    });
    super.initState();
  }

  void radioButtonChanges(int value) {
    setState(() {
      _radioValue = value;
      switch (value) {
        case 1:
          reason = 'Duplicate';
          _other = false;
          break;
        case 2:
          reason = 'Spam';
          _other = false;
          break;
        case 3:
          reason = 'Wrong Contact Info';
          _other = false;
          break;
        case 4:
          reason = 'Sold Already';
          _other = false;
          break;
        case 5:
          reason = 'Fake Ad';
          _other = false;
          break;
        case 6:
          reason = 'Wrong Category';
          _other = false;
          break;
        case 7:
          reason = 'Prohibited/Explicit Content';
          _other = false;
          break;
        case 8:
          _other = true;
          break;
        default:
          choice = null;
      }
    });
  }

  Widget build(BuildContext context) {
    return  AlertDialog(
        title: Text("Thanks for reporting this ad!",
            style: TextStyle(color: Theme.of(context).primaryColor)),
       content: ListView( children: <Widget>[
          _reportType(1, 'Duplicate'),
          _reportType(2, 'Spam'),
          _reportType(3, 'Wrong Contact Info'),
          _reportType(4, 'Sold Already'),
          _reportType(5, 'Fake Ad'),
          _reportType(6, 'Wrong Category'),
          _reportType(7, 'Prohibited/Explicit Content'),
          _reportType(8, 'Other:'),
         _other ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _reportKey,
              autovalidate: _autoValidate,
              child: TextFormField(
                autofocus: true,
                  validator: (value) {
                    return value.isEmpty ? 'Please input reason' : null;
                  },
                  controller: inputReason,
                  decoration: InputDecoration(
                    labelText: 'Reason',
                    labelStyle: TextStyle(fontSize: 12.0),
                    border: OutlineInputBorder(),
                  )),
            ),
          ) : SizedBox(),
          SizedBox(
            height: 40,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60.0),
              child: RaisedButton(
                child: Text("Submit",style: TextStyle(color: Colors.white),),
                onPressed: () async {
                  FormData _report = FormData.fromMap({
                    'pet_id' : widget.petId,
                    'description' : _other ? inputReason.text : reason,
                  });
//                  print(_report.fields);
                  if(_other){
                    if(_reportKey.currentState.validate()){
                      openLoadingDialog(context, "Reporting Ad...");
                      await Service.post('report-ad', _report);
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    }
                    else{
                      setState(() {
                        _autoValidate=true;
                      });
                    }
                  }else{
                    openLoadingDialog(context, "Reporting Ad...");
                    await Service.post('report-ad', _report);
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  }
                },
                color: Colors.primaries[0],
                shape: StadiumBorder(),
              ),
            ),
          ),

        ],
       )

    );
  }

  _reportType(int val, String title) {
    return RadioListTile(
              title: Text(title),
              groupValue: _radioValue,
              value: val,
              onChanged: radioButtonChanges,
              activeColor: Colors.primaries[0],
            );
  }
}
