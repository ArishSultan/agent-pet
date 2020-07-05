import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SortBottomSheet extends StatefulWidget {
  final int selectedSort;
  SortBottomSheet({this.selectedSort});
  @override
  _SortBottomSheetState createState() => _SortBottomSheetState();
}

class _SortBottomSheetState extends State<SortBottomSheet> {


  int _sortValue;
  String _orderBy = '';
  void _sortChanges(int value) {
    print("sda");
    setState(() {
      _sortValue = value;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child:  Wrap(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:8.0,vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("SORT BY",style: TextStyle(color: Colors.primaries[0],fontWeight: FontWeight.bold,fontSize: 15),),
                ),
                FlatButton(
                  splashColor: Colors.grey.shade200,
                  child: Text("Cancel",style: TextStyle(color: Colors.primaries[0]),),
                  onPressed: ()=> Navigator.pop(context),

                ),
              ],),
          ),
          Divider(),

          RadioListTile(
            controlAffinity: ListTileControlAffinity.trailing,
            title:   Text('Date Updated: (New to Old)'),
              groupValue: widget.selectedSort==null ? _sortValue:widget.selectedSort,
              activeColor: Colors.primaries[0],
              selected: widget.selectedSort==null ? (_sortValue == 1 ? true: false) : (widget.selectedSort == 1 ? true: false),
              value: 1,
              onChanged: (int val){
                setState(() {
                  _sortValue=1;
                });
                _orderBy = 'desc';
                Navigator.pop(context, _orderBy);

              },
            ),

          RadioListTile(
           controlAffinity: ListTileControlAffinity.trailing,
              title: Text('Date Updated: (Old to New)'),
              groupValue: widget.selectedSort==null ? _sortValue:widget.selectedSort,
            selected: widget.selectedSort==null ? (_sortValue == 2 ? true: false) : (widget.selectedSort == 2 ? true: false),
            activeColor: Colors.primaries[0],
              value: 2,
              onChanged: (int val){
                  setState(() {
                    _sortValue=2;
                  });
                  _orderBy = 'asc';
                  Navigator.pop(context, _orderBy);
              },
            ),

        ],
      ),
    );
  }
}

