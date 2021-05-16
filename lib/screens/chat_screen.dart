import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/screens/direct_message.dart';
import 'package:flash_chat/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/components/ChatEntity.dart';

class Arguments {
  final String receiver;

  Arguments(this.receiver);
}

class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var currChats = [];

  @override
  void initState() {
    // TODO: implement initState
    getCurrentUser();
    super.initState();
  }

  final auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;
  Firestore _firestore = Firestore.instance;

  void getCurrentUserChats() async {
    var currUserChat = [];
    await for (var snapshot
        in _firestore.collection('users').document(loggedInUser.email).snapshots()) {
      currUserChat = [];
      for (var chats in snapshot.data['chats']) {
        currUserChat.add(chats);
      }
      setState(() {
        currChats = currUserChat;
      });
    }
  }

  void getCurrentUser() async {
    try {
      final currentUser = await auth.currentUser();
      if (currentUser != null) {
        loggedInUser = currentUser;
        print("Welcome to chat screen " + loggedInUser.email);
        getCurrentUserChats();
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> x = [];
    for (var i in currChats) {
      x.add(ChatEntity(i, () {
        print('Proceeding to DM between $i');

        Navigator.pushNamed(context, DirectMessages.id, arguments: [i, loggedInUser.email]);
      }));
    }
    return Scaffold(
        backgroundColor: kBodyColor,
        appBar: AppBar(
          leading: null,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  //Implement search functionality
                  Navigator.pushNamed(context, SearchScreen.id, arguments: [loggedInUser.email]);
                }),
            IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  //Implement logout functionality
                  auth.signOut();
                  Navigator.pop(context);
                }),
          ],
          title: Text(
            '⚡️Chats',
            style: kAppBarTextStyle,
          ),
          backgroundColor: kAppbarColor,
        ),
        body: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: SafeArea(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: x,
          )),
        ));
  }
}
