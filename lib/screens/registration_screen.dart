import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/components/RoundedButton.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'chat_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String email;
  String password;
  String confirmPassword;
  bool asyncInProgress = false;
  bool dontMatch = false;
  final myTextController1 = TextEditingController();
  final myTextController2 = TextEditingController();
  final myTextController3 = TextEditingController();
  Firestore _firestore = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBodyColor,
      body: ModalProgressHUD(
        inAsyncCall: asyncInProgress,
        child: Center(
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Hero(
                    tag: 'lightning',
                    child: Container(
                      height: 200.0,
                      child: Image.asset('images/logo.png'),
                    ),
                  ),
                  SizedBox(
                    height: 48.0,
                  ),
                  TextField(
                    controller: myTextController1,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                    onChanged: (value) {
                      //Do something with the user input.
                      email = value;
                    },
                    decoration: kInputDecoration.copyWith(hintText: 'Enter E-mail'),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  TextField(
                    controller: myTextController2,
                    textAlign: TextAlign.center,
                    obscureText: true,
                    style: TextStyle(color: Colors.white),
                    onChanged: (value) {
                      //Do something with the user input.
                      password = value;
                    },
                    decoration: kInputDecoration.copyWith(hintText: 'Enter Password'),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  TextField(
                    controller: myTextController3,
                    textAlign: TextAlign.center,
                    obscureText: true,
                    style: TextStyle(color: Colors.white),
                    onChanged: (value) {
                      //Do something with the user input.
                      confirmPassword = value;
                    },
                    decoration: kInputDecoration.copyWith(hintText: 'Confirm Password'),
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  Hero(
                    tag: 'register',
                    child: RoundedButton(Colors.blueAccent, 'Register', () async {
                      if (password == confirmPassword) {
                        setState(() {
                          asyncInProgress = true;
                        });
                        try {
                          final newUser = await _auth.createUserWithEmailAndPassword(
                              email: email, password: password);
                          final user = await _firestore
                              .collection('users')
                              .document(email)
                              .setData({'email': email, 'chats': []});
                          if (newUser != null) {
                            Navigator.pushNamed(context, ChatScreen.id);
                          }
                        } catch (e) {
                          print(e);
                        }
                        setState(() {
                          asyncInProgress = false;
                        });
                      } else {
                        print("Passwords don't match");
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text("Alert !"),
                            content: Text("Passwords don't match !"),
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    myTextController1.clear();
                                    myTextController2.clear();
                                    myTextController3.clear();
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'Okay !',
                                  ))
                            ],
                            elevation: 24.0,
                          ),
                          barrierDismissible: true,
                        );
                      }
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
