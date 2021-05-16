import 'package:flash_chat/components/RoundedButton.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'chat_screen.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email;
  String password;
  bool asyncInProgress = false;
  final myTextController1 = TextEditingController();
  final myTextController2 = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBodyColor,
      body: Center(
        child: ModalProgressHUD(
          inAsyncCall: asyncInProgress,
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
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
                    height: 24.0,
                  ),
                  Hero(
                    tag: 'login',
                    child: RoundedButton(Colors.lightBlueAccent, 'Login', () async {
                      setState(() {
                        asyncInProgress = true;
                      });
                      try {
                        var user =
                            await _auth.signInWithEmailAndPassword(email: email, password: password);
                        if (user != null) {
                          print("success");
                          Navigator.pushNamed(context, ChatScreen.id);
                        }
                      } catch (e) {
                        print("LOGIN ERROR");
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text("Alert !"),
                            content: Text("Wrong E-mail or Password !"),
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    myTextController1.clear();
                                    myTextController2.clear();

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
                      setState(() {
                        asyncInProgress = false;
                      });
                    }),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
