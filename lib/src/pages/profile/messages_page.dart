import 'package:agent_pet/src/models/messages.dart';
import 'package:agent_pet/src/services/messages-service.dart';
import 'package:agent_pet/src/widgets/cross_fade_navigator.dart';
import 'package:agent_pet/src/utils/date-formatter.dart';
import 'package:agent_pet/src/utils/local-data.dart';
import 'package:agent_pet/src/utils/simple-future-builder.dart';
import 'package:flutter/material.dart';


class MessagesPage extends StatefulWidget {
  @override
  createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  build(context) => Scaffold(
    appBar: AppBar(
      title: Text("Messages"),
      centerTitle: true,
    ),
      key: _scaffoldKey,
      backgroundColor: Colors.white,

      body: SafeArea(
        top: true,
        child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: CrossFadeNavigator(
                backgroundColor: Colors.primaries[0],
                foregroundColor: Colors.white,
                firstTitle: "Sent",
                secondTitle: "Received",
                fontFamily: 'Quicksand',
                firstChild: MessagesTile(),
                secondChild: MessagesTile(true),
                index: 1,
              ),
            ),
      ),
    );
}



class MessagesTile extends StatefulWidget {
  final bool received;
  MessagesTile([this.received=false]);
  @override
  _MessagesTileState createState() => _MessagesTileState();
}

class _MessagesTileState extends State<MessagesTile> {

  var _service = MessagesService();
  Future<List<Messages>> _messagesFuture;

  @override
  void initState() {
    super.initState();
    _messagesFuture = _service.getAll('messages/${LocalData.user.id}');
  }

  @override
  Widget build(BuildContext context) {
    return
      SimpleFutureBuilder<List<Messages>>.simpler(
          context: context,
          future: _messagesFuture,
          builder: (AsyncSnapshot<List<Messages>> snapshot) {
            return ListView.builder(
                shrinkWrap: true,
                itemCount:  !widget.received ? snapshot.data[0].sentMessages.length : snapshot.data[0].receivedMessages.length,
                itemBuilder: (context, index) {
                  var _message = !widget.received ? snapshot.data[0].sentMessages[index] : snapshot.data[0].receivedMessages[index];
                  return ListTile(
                    title: LocalData.user.id == _message.senderId ? Text(_message.receiverName) : Text(_message.senderName),
                    subtitle: Text(_message.description),
                    trailing: Text("${getFormattedDate(_message.createdAt.toIso8601String())}"),
                    onTap: (){

                    },
                  );
                }
            );
          }
      );
  }
}




