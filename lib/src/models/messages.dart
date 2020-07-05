import 'package:agent_pet/src/models/message.dart';

import '_model.dart';

class Messages extends Model{
  List<Message> sentMessages;
  List<Message> receivedMessages;

  Messages({this.sentMessages, this.receivedMessages}) : super(0);

  Messages.fromJson(Map<String, dynamic> json) : this (

      sentMessages: (json['sent_messages'] as List)
          ?.map((i) => Message.fromJson(i))
          ?.toList(),
      receivedMessages: (json['received_messages'] as List)
          ?.map((i) => Message.fromJson(i))
          ?.toList(),
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.sentMessages != null) {
      data['sent_messages'] = this.sentMessages.map((v) => v.toJson()).toList();
    }
    if (this.receivedMessages != null) {
      data['received_messages'] =
          this.receivedMessages.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
