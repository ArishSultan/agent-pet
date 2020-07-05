import 'package:agent_pet/src/models/pet.dart';
import 'package:agent_pet/src/widgets/chevron-clipper.dart';
import 'package:agent_pet/src/widgets/dialogs/confirmation-dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'add-or-edit-pet-data.dart';
import 'features-tab.dart';
import 'information-tab.dart';
import 'owner-details-tab.dart';

class AddPetPage extends StatefulWidget {
  final Pet petForEdit;
  final bool editMode;
  AddPetPage({this.petForEdit,this.editMode=false});
  @override
  _AddPetPageState createState() => _AddPetPageState();
}

class _AddPetPageState extends State<AddPetPage>
    with SingleTickerProviderStateMixin {

  TabController _tabController;
  int _index = 0;
  @override
  void initState() {
    super.initState();

    isDisabledAddPet = [false,true,true];

    this._tabController = TabController(
      length: 3,
      vsync: this
    );

    _tabController.addListener((){

      if (isDisabledAddPet[_tabController.index]) {
        int index = _tabController.previousIndex;
        setState(() {
          _tabController.index = index;
        });
      }
      setState(() {
        _index = _tabController.index;
      });

      if(_tabController.indexIsChanging)
      {
        FocusScope.of(context).unfocus();
      }

    });

  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InheritedAddPet(
      child: WillPopScope(
        onWillPop: () async {
          if(_tabController.index>0){
            _tabController.animateTo(_tabController.index-1);
            return false;
          }
          else{
            var _confirmed = await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) =>ConfirmationDialog(message :!widget.editMode ? 'leave ad posting' : 'leave ad editing'));
            return _confirmed;
          }
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () async {
                if(_tabController.index>0){
                  _tabController.animateTo(_tabController.index-1);
                }
                else{
                  var _confirmed = await showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) =>ConfirmationDialog(message :!widget.editMode ? 'leave ad posting' : 'leave ad editing'));
                   _confirmed == true ? Navigator.of(context).pop() : null;
                }
              },
              icon: Icon(Icons.arrow_back,color: Colors.black,),
            ),
            backgroundColor: Colors.white,
            title: Text(!widget.editMode ? "Add Pet" : 'Edit Pet', style: TextStyle(color: Colors.black)),

            bottom: PreferredSize(
              child: Container(
                constraints: BoxConstraints.expand(height: 50),
                color: Colors.white,
                child: TabBar(
                  labelPadding: EdgeInsets.all(0),
                  unselectedLabelColor: Colors.black,
                  controller: this._tabController,
                  indicatorPadding: EdgeInsets.all(0),

                  tabs: <Widget>[
                    Chevron(
                      triangleHeight: 20,
                      child: Container(
                        color: _index == 0 ? Colors.primaries[0] : Colors.grey.shade200,
                        child: Center(child: Text("   Information")),
                      ),
                    ),
                    Chevron(
                      triangleHeight: 20,
                      child: Container(
                        color: _index == 1 ? Colors.primaries[0] : Colors.grey.shade200,
                        child: Center(child: Text("   Features")),
                      ),
                    ),
                    Chevron(
                      triangleHeight: 20,
                      child: Container(
                        color: _index == 2 ? Colors.primaries[0] : Colors.grey.shade200,
                        child: Center(child: Text("   Owner Details")),
                      ),
                    ),
                  ],

                ),
              ),
              preferredSize: Size.fromHeight(50),
            )
          ),
          body: TabBarView(
            controller: this._tabController,
            children: <Widget>[
              InformationTab(controller:_tabController,petForEdit: widget.petForEdit,editMode: widget.editMode,),
              Features(controller:_tabController,petForEdit: widget.petForEdit,editMode: widget.editMode,),
              OwnerDetails(controller:_tabController,petForEdit: widget.petForEdit,editMode: widget.editMode,)
            ],
            physics: NeverScrollableScrollPhysics(),
          )
        ),
      ),
    );
  }



}

