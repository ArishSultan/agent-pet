import 'package:agent_pet/src/models/_model.dart';

class Message extends Model {
  int id;
  int senderId;
  String senderName;
  int receiverId;
  String receiverName;
  int petId;
  String description;
  DateTime createdAt;

  Message(
      {this.id,
        this.senderId,
        this.receiverId,
        this.senderName,
        this.receiverName,
        this.petId,
        this.description,
        this.createdAt,
        }):super(id);

  Message.fromJson(Map<String, dynamic> json) : this (
    id  :json['id'],
    senderId : json['sender_id'],
    senderName : json['sender_name'],
    receiverId : json['receiver_id'],
    receiverName : json['receiver_name'],
    petId : json['pet_id'],
    description : json['description'],
    createdAt : DateTime.parse(json['created_at']),
  );

  Map<String, dynamic> toJson() {

    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sender_id'] = this.senderId;
    data['receiver_id'] = this.receiverId;
    data['pet_id'] = this.petId;
    data['description'] = this.description;
    data['created_at'] = this.createdAt;
    return data;
  }
}