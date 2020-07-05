import 'package:agent_pet/src/models/alert.dart';
import 'package:agent_pet/src/models/brand.dart';

import '_service.dart';

class AlertService extends Service<Alert> {
  @override
  Alert parse(Map<String, dynamic> item) => Alert.fromJson(item);


  Future<List<Alert>> getSubscribedAlerts(String email){
    return this.getAll("alerts/$email");
  }
}