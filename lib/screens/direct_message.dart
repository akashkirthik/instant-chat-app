import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DirectMessages extends StatefulWidget {
  static String id = 'direct_message';

  @override
  _DirectMessagesState createState() => _DirectMessagesState();
}

class _DirectMessagesState extends State<DirectMessages> {
  final auth = FirebaseAuth.instance;
  final messageTextController = TextEditingController();

  Firestore _firestore = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    final List fromChatScreen = ModalRoute.of(context).settings.arguments;
    final String receiver = fromChatScreen[0];
    final String sender = fromChatScreen[1];
    String messageText;
    return Scaffold(
        backgroundColor: kBodyColor,
        appBar: AppBar(
          leading: null,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  //Implement logout functionality
                  //auth.signOut();
                  Navigator.pop(context);
                }),
          ],
          title: Text(
            '⚡️$receiver',
            style: kAppBarTextStyle,
          ),
          backgroundColor: kAppbarColor,
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection("messages")
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Widget> messageWidgets = [];
                    final messages = snapshot.data.documents;
                    for (var message in messages) {
                      final messageText = message.data['text'];
                      final messageSender = message.data['sender'];
                      final messageReceiver = message.data['receiver'];
                      final Timestamp timestamp = message.data['timestamp'];
                      String time = timestamp.toDate().hour.toString() +
                          ":" +
                          timestamp.toDate().minute.toString();
                      if (messageReceiver == receiver && messageSender == sender ||
                          messageReceiver == sender && messageSender == receiver) {
                        final messageWidget = Align(
                            alignment: (sender != messageSender)
                                ? Alignment.centerLeft
                                : Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Column(
                                crossAxisAlignment: (sender == messageSender)
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    time,
                                    style: TextStyle(color: Colors.white60),
                                  ),
                                  Material(
                                    borderRadius: (sender == messageSender)
                                        ? kSenderChatBubble
                                        : kReceiverChatbubble,
                                    elevation: 5.0,
                                    color:
                                        (sender != messageSender) ? Color(0xff255666B) : kChatColor1,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                                      child: Text('$messageText',
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontFamily: 'Raleway_',
                                            fontWeight: FontWeight.w500,
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            ));
                        messageWidgets.add(messageWidget);
                      }
                    }
                    return Expanded(
                      child: ListView(
                        reverse: true,
                        children: messageWidgets,
                      ),
                    );
                  }
                  return Text('START DM');
                },
              ),
              Container(
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                            controller: messageTextController,
                            decoration: kMessageTextFieldDecoration,
                            onChanged: (value) {
                              messageText = value;
                              print(messageText);
                            })),
                    TextButton(
                        onPressed: () async {
                          print('sending message to database');

                          if (messageText.isNotEmpty) {
                            _firestore.collection('messages').add({
                              'text': messageText,
                              'sender': sender,
                              'receiver': receiver,
                              'timestamp': Timestamp.now()
                            });

                            var senderChat =
                                _firestore.collection('users').document(sender).updateData({
                              'chats': FieldValue.arrayUnion([receiver])
                            });
                            try {
                              var receiverChat =
                                  _firestore.collection('users').document(receiver).updateData({
                                'chats': FieldValue.arrayUnion([sender])
                              });
                            } catch (e) {
                              print(e);
                            }
                          }

                          messageTextController.clear();
                        },
                        child: Text(
                          'Send',
                          style: kSendButtonTextStyle,
                        ))
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
