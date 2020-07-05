import 'package:agent_pet/src/models/alert.dart';
import 'package:agent_pet/src/services/_service.dart';
import 'package:agent_pet/src/services/alert-service.dart';
import 'package:agent_pet/src/widgets/appBar.dart';
import 'package:agent_pet/src/widgets/dialogs/loading-dialog.dart';
import 'package:agent_pet/src/utils/local-data.dart';
import 'package:agent_pet/src/utils/simple-future-builder.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class MyAlerts extends StatefulWidget {

  @override
  _MyAlertsState createState() => _MyAlertsState();
}

class _MyAlertsState extends State<MyAlerts> {
  Future<List<Alert>> alerts;
  var _service = AlertService();
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    alerts = _service.getSubscribedAlerts(LocalData.user.email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AgentPetAppbar(context,'My Alerts',false),
      body: RefreshIndicator(
        key: refreshKey,
        color: Colors.primaries[0],
        onRefresh: () async {
          alerts = _service.getAll('alerts/${LocalData.user.email}');
          await alerts;
          setState(() {});
        },
        child: SimpleFutureBuilder<List<Alert>>.simpler(
                  context: context,
                  future: alerts,
                  builder: (AsyncSnapshot<List<Alert>> snapshot) {
                    return snapshot.data.length > 0 ? ListView.builder(itemBuilder:(context, i) {
                          var alert = snapshot.data[i];
                          return ListTile(
                            title: Text("${alert.petName} in ${alert.city}"),
                            subtitle: Row(
                              children: <Widget>[
                                Icon(Icons.timer,color: Colors.grey,size: 16,),
                                Text(alert.frequency),
                              ],
                            ),
                            trailing: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(5)
                              ),

                              child: SizedBox(
                                child: IconButton(
                                    onPressed: () async {
                                      FormData _deleteAlert = FormData.fromMap({
                                        "id" : alert.id
                                      });
                                      openLoadingDialog(context, 'Deleting Alert...');
                                      await Service.post('delete-alert', _deleteAlert);
                                      refreshKey.currentState.show();
                                      Navigator.of(context).pop();
                                    },
                                    icon: Icon(Icons.delete, size: 16,color: Colors.white,)
                                ),
                              ),
                            )
                          );
                        },
                      itemCount: snapshot.data.length,
                    ): Center(child: Text("You haven't saved any alerts!"),);
                  }
              )
      ),
    );
  }
}
