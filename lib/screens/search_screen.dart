import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/screens/direct_message.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/ChatEntity.dart';
import 'package:flash_chat/constants.dart';

class Arguments {
  final String receiver;

  Arguments(this.receiver);
}

class SearchScreen extends StatefulWidget {
  static String id = 'search_screen';

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var currChats = [];

  final searchTextController = TextEditingController();

  Firestore _firestore = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    final List fromChatScreen = ModalRoute.of(context).settings.arguments;

    final String sender = fromChatScreen[0];
    String searchText;
    return Scaffold(
        backgroundColor: kBodyColor,
        appBar: AppBar(
          leading: null,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  //Implement logout functionality

                  Navigator.pop(context);
                }),
          ],
          title: Text(
            '⚡️Search for user',
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
            children: [
              Row(
                children: [
                  Expanded(
                      child: TextField(
                          controller: searchTextController,
                          decoration: kMessageTextFieldDecoration.copyWith(
                              hintText: "Search for "
                                  "user"),
                          onChanged: (value) {
                            searchText = value;
                            print(searchText);
                          })),
                  TextButton(
                      onPressed: () {
                        print('searching...');

                        if (searchText.isNotEmpty) {
                          Navigator.pop(context);

                          Navigator.pushNamed(context, DirectMessages.id,
                              arguments: [searchText, sender]);
                          searchTextController.clear();
                        }
                      },
                      child: Text(
                        'Search',
                        style: kSendButtonTextStyle,
                      ))
                ],
              ),
            ],
          )),
        ));
  }
}
