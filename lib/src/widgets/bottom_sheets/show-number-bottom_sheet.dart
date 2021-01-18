import 'package:agent_pet/src/base/theme.dart';
import 'package:agent_pet/src/utils/dial-phone-or-sms.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OwnerContactNumberSheet extends StatelessWidget {
  final String number;

  OwnerContactNumberSheet(this.number);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(children: [
          Text(
            "Seller's Number",
            style: TextStyle(
              color: Colors.primaries[0],
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Spacer(),
          OutlinedButton(
            child: Text('Cancel'),
            style: TextButton.styleFrom(
              primary: AppTheme.primaryColor,
              onSurface: AppTheme.primaryColor,
              visualDensity: VisualDensity.compact,
            ),
            onPressed: Navigator.of(context).pop,
          )
        ]),
        Divider(height: 20),
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            number,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Text(
            'Mention AgentPet.com when calling seller to get a good deal.',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ),
        ConstrainedBox(
          constraints: BoxConstraints.expand(height: 40),
          child: TextButton.icon(
            label: Text('Call Now'),
            style: TextButton.styleFrom(
              primary: Colors.white,
              backgroundColor: AppTheme.primaryColor,
            ),
            onPressed: () => dial("tel:$number"),
            icon: Icon(CupertinoIcons.phone_arrow_up_right, size: 19),
          ),
        )
      ]),
    );
  }
}

class ShowNumberSheet extends StatefulWidget {
  final String phoneNum;

  ShowNumberSheet({this.phoneNum});

  @override
  _ShowNumberSheetState createState() => _ShowNumberSheetState();
}

class _ShowNumberSheetState extends State<ShowNumberSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FlatButton(
                  splashColor: Colors.grey.shade200,
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.primaries[0]),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Center(
                child: Text(
              widget.phoneNum,
              style: TextStyle(fontSize: 20),
            )),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              "Mention AgentPet.com when calling seller to get a good deal.",
              style: TextStyle(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: ConstrainedBox(
              constraints: BoxConstraints.expand(height: 40),
              child: FlatButton(
                child: Text('CALL NOW'),
                color: Colors.primaries[0],
                onPressed: () {
                  dial("tel:${widget.phoneNum}");
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
