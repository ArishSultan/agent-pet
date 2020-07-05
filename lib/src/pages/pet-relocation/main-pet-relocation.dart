import 'package:agent_pet/src/widgets/chevron-clipper.dart';
import 'package:agent_pet/src/widgets/dialogs/confirmation-dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'pet-details-tab.dart';
import 'pet-owner-tab.dart';
import 'pet_relocation-data.dart';
import 'travel-itinerary-tab.dart';

class PetRelocationPage extends StatefulWidget {
  @override
  _PetRelocationPageState createState() => _PetRelocationPageState();
}

class _PetRelocationPageState extends State<PetRelocationPage>
    with SingleTickerProviderStateMixin {

  TabController _tabController;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    isDisabledPetRelocation = [false,true,true];
    this._tabController = TabController(
      length: 3,
      vsync: this
    );
    _tabController.addListener((){

      if (isDisabledPetRelocation[_tabController.index]) {
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

    return InheritedPetRelocation(
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
                builder: (context) =>ConfirmationDialog(message :'leave relocation form'));
            return _confirmed;          }
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back,color: Colors.black,),
              onPressed: () async {
                if(_tabController.index>0){
                  _tabController.animateTo(_tabController.index-1);
                }else{
                  var _confirmed = await showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) =>ConfirmationDialog(message :'leave relocation form'));
                  _confirmed == true ? Navigator.of(context).pop() : null;
                }
              }
            ),
            backgroundColor: Colors.white,
            title: Text("Pet Relocation", style: TextStyle(color: Colors.black)),
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
                          child: Center(child: Text("   Pet Details")),
                        ),
                      ),
                      Chevron(
                        triangleHeight: 20,
                        child: Container(
                          color: _index == 1 ? Colors.primaries[0] : Colors.grey.shade200,
                          child: Center(child: Text("   Travel Itinerary")),
                        ),
                      ),
                      Chevron(
                        triangleHeight: 20,
                        child: Container(
                          color: _index == 2 ? Colors.primaries[0] : Colors.grey.shade200,
                          child: Center(child: Text("   Pet Owner")),
                        ),
                      ),

                    ],

                ),
              ),
              preferredSize: Size.fromHeight(50),
            )
          ),
          body:  TabBarView(
              controller: this._tabController,
              children: <Widget>[
                PetDetails(controller:_tabController),
                TravelItinerary(controller:_tabController),
                PetOwner(tabController: this._tabController,)
              ],
              physics: NeverScrollableScrollPhysics(),
            ),
        ),
      ),
    );
  }

}


