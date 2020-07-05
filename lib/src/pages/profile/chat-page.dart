import 'package:agent_pet/src/models/message.dart';
import 'package:agent_pet/src/services/_service.dart';
import 'package:agent_pet/src/services/chat-service.dart';
import 'package:agent_pet/src/widgets/chat_bubble.dart';
import 'package:agent_pet/src/utils/local-data.dart';
import 'package:agent_pet/src/utils/simple-future-builder.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class ChatPage extends StatefulWidget {
  final int petId;
  final int receiverId;
  final String receiverName;
  ChatPage({this.petId,this.receiverId,this.receiverName});
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController textMessage;
  ScrollController _scrollController;
  String studentId;
  List<String> _messages = [];
  var _service = ChatService();
  Future<List<Message>> _messagesFuture;
  @override
  void initState() {
    textMessage = TextEditingController();
    _scrollController = ScrollController();
    _messagesFuture = _service.getPetChat(widget.petId,LocalData.user.id);
    super.initState();
    print(widget.petId);

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          title: widget.receiverName!=null ? Text(widget.receiverName) : SizedBox(),
          centerTitle: true,
          actions: [
            IconButton(
              icon:  Icon(Icons.refresh),
              tooltip: 'Refresh Chat',
              onPressed: () async {
                _openLoadingDialog(context, 'Refreshing...');
                _messagesFuture = _service.getPetChat(widget.petId, LocalData.user.id);
                await _messagesFuture;
                setState(() {});
                Navigator.of(context).pop();
              },
            ),
          ]
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(height: 30,),
            Expanded(
              child: SimpleFutureBuilder<List<Message>>.simpler(
                context: context,
                future: _messagesFuture,
                builder: (AsyncSnapshot<List<Message>> snapshot) {
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      controller: _scrollController,
                      itemBuilder: (context, index) {
                        Timer(Duration(milliseconds: 300), () =>  _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent,
                          curve: Curves.easeOut,
                          duration: Duration(milliseconds: 300),
                        ));
                        var _message = snapshot.data[index];
//                        print(_message.description);
                        return Bubble(
                          time: ((DateTime date) =>
                          "${date.hour % 12}:${date.minute} ${date.hour > 12
                              ? 'PM'
                              : 'AM'}")(
                              _message.createdAt),
                          isMe: _message.senderId == LocalData.user.id ? true : false,
                          message: _message.description,
                        );
                      }
                  );
                }
              ),
            ) ,
            Material(
              elevation: 20,
              child: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding:
                        EdgeInsets.only(bottom: 12.0, left: 8, right: 8),
                        child: Material(
                          elevation: 1,
                          borderRadius: BorderRadius.circular(50),
                          child: TextFormField(
                            controller: textMessage,
                            maxLines: null,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(
                                  top: 13.0, bottom: 13.0, left: 20),
                              hintText: 'Type a message...',
                              hintStyle: TextStyle(color: Colors.black54),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.transparent, width: 5.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide:
                                  BorderSide(color: Colors.primaries[0])),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 45,
                      height: 45,
                      margin: EdgeInsets.only(right: 10, bottom: 13),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.primaries[0]),
                      child: IconButton(
                          padding: EdgeInsets.only(
                              left: 4, right: 11, top: 0, bottom: 13),
                          alignment: Alignment.bottomRight,
                          iconSize: 20,
                          icon: Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            if(textMessage.text.isNotEmpty){
                              FormData _message = FormData.fromMap({
                                "sender_id": LocalData.user.id,
                                "receiver_id": widget.receiverId,
                                "pet_id": widget.petId,
                                "description": textMessage.text,
                              });
                              _openLoadingDialog(context, 'Sending Message...');
                              await Service.post('send-message', _message);
                              textMessage.clear();
                              _messagesFuture = _service.getPetChat(widget.petId,LocalData.user.id);
                              await _messagesFuture;
                              setState(() {});
                              Navigator.of(context).pop();
                            }
                          }
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _openLoadingDialog(BuildContext context, String text) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          content: Row(children: <Widget>[
            SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                    strokeWidth: 1,
                    valueColor: AlwaysStoppedAnimation(Colors.black)
                )
            ),

            SizedBox(width: 10),

            Text(text)
          ]),
        )
    );
  }

}
