
import 'package:agent_pet/src/models/messages.dart';

import '_service.dart';

class MessagesService extends Service<Messages> {
  @override
  Messages parse(Map<String, dynamic> item) => Messages.fromJson(item);



}