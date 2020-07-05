import 'package:agent_pet/src/models/message.dart';

import '_service.dart';

class ChatService extends Service<Message> {
  @override
  Message parse(Map<String, dynamic> item) => Message.fromJson(item);


  Future<List<Message>> getPetChat(int petId,int userId){
  return this.getAll('messages-by-pet/$petId/$userId');
  }

}