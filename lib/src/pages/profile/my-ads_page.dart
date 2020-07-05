import 'package:agent_pet/src/models/pet.dart';
import 'package:agent_pet/src/pages/add-or-edit-pet/main-add-or-edit-pet.dart';
import 'package:agent_pet/src/services/_service.dart';
import 'package:agent_pet/src/services/pet-service.dart';
import 'package:agent_pet/src/utils/custom-navigator.dart';
import 'package:agent_pet/src/utils/date-formatter.dart';
import 'package:agent_pet/src/utils/local-data.dart';
import 'package:agent_pet/src/utils/local-data.dart';
import 'package:agent_pet/src/widgets/appBar.dart';
import 'package:agent_pet/src/utils/simple-future-builder.dart';
import 'package:agent_pet/src/widgets/dialogs/confirmation-dialog.dart';
import 'package:agent_pet/src/widgets/dialogs/loading-dialog.dart';
import 'package:agent_pet/src/widgets/icon-text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../pet-detail_page.dart';

class MyAds extends StatefulWidget {

  @override
  _MyAdsState createState() => _MyAdsState();
}

enum PageEnum {
  Edit,
  Delete,
}

class _MyAdsState extends State<MyAds> {
  Future<List<Pet>> pets;
  var _service = PetService();
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    pets = _service.getUserPets(LocalData.user.id);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AgentPetAppbar(context,'My Ads',false),
      body: RefreshIndicator(
          key: refreshKey,
          color: Colors.primaries[0],
          onRefresh: () async {
            pets = _service.getUserPets(LocalData.user.id);
            await pets;
            setState(() {});
          },
          child:
              SimpleFutureBuilder<List<Pet>>.simpler(
                  context: context,
                  future: pets,
                  builder: (AsyncSnapshot<List<Pet>> snapshot) {
                    return snapshot.data.length>0 ? ListView.builder(itemBuilder:(context, i) {
                      var pet = snapshot.data[i];
                      return  ListTile(
                        leading: ConstrainedBox(
                          constraints: BoxConstraints.expand(width: 60),
                          child: Image.network(Service.getConvertedImageUrl(pet.images.isNotEmpty ? pet.images.first.src : 'img/no-image2.png'), fit: BoxFit.fill, loadingBuilder: (context, widget, event) {
                            if (event != null) {
                              return   Center(
                                child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation(Colors.black),
                                    value: event.cumulativeBytesLoaded / event.expectedTotalBytes
                                ),
                              );
                            } else if (widget != null) {
                              return widget;
                            } return CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.black),
                            );
                          }),
                        ),
                        title: Text("${pet.name[0].toUpperCase()}${pet.name.substring(1)}"),
                        subtitle: Column(children: <Widget>[
                          Text(pet.description ?? '', overflow: TextOverflow.ellipsis,),
                          Row(children: <Widget>[
                            Expanded(child: IconText(
                                padding: const EdgeInsets.only(right: 2),
                                icon: Icon(Icons.loop, size: 12, color: Colors.grey),
                                text: Expanded(child: Text("${getFormattedDate(pet.updatedAt)}", style: TextStyle(fontSize: 9)))),
                            ),
                            Expanded(
                                child: Text("Status: ${pet.status}", style: TextStyle(fontSize: 9)
                                )
                            ),
                          ])
                        ], crossAxisAlignment: CrossAxisAlignment.start),
                        trailing:  PopUpMenu(
                          onDelete: () async {
                        FormData _petDelete = FormData.fromMap({
                          "pet_id" : pet.id,
                        });

                        var _confirmed = await showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) =>ConfirmationDialog(message :'delete this ad'));
                         if(_confirmed){
                           openLoadingDialog(context, 'Deleting ad...');
                           await Service.post('pet-delete', _petDelete);
                           refreshKey.currentState.show();
                           Navigator.of(context).pop();
                         }
                            },
                          onEdit: () async {
                            await CustomNavigator.navigateTo(context, AddPetPage(petForEdit: pet,editMode: true,));
                            refreshKey.currentState.show();

                          },
                        ),
                        isThreeLine: true,
                        onTap: () {
                          CustomNavigator.navigateTo(context, PetDetailPage(pet: pet));
                        },
                      );
                    },
                      itemCount: snapshot.data.length,
                    ) : Center(child: Text("You haven't posted any ads!"),);
                  }
              )
      ),
    );


  }


}


class PopUpMenu extends StatelessWidget {
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  PopUpMenu({this.onDelete,this.onEdit});

  void showMenuSelection(PageEnum value) {
    switch (value) {
      case PageEnum.Delete:
        onDelete();
        break;
      case PageEnum.Edit:
        onEdit();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<PageEnum>(
      offset: Offset(0,40),
      onSelected: showMenuSelection,
      icon: Icon(Icons.more_vert),
      itemBuilder: (context) => <PopupMenuEntry<PageEnum>>[
        PopupMenuItem<PageEnum>(
            value: PageEnum.Edit,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Icon(Icons.edit),
                Text("Edit"),
              ],
            )
        ),
        PopupMenuItem<PageEnum>(
            value: PageEnum.Delete,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Icon(Icons.delete),
                Text("Delete"),
              ],
            )
        ),
      ],
    );
  }}