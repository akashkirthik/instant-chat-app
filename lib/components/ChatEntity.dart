import 'package:flash_chat/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatEntity extends StatelessWidget {
  ChatEntity(this.i, this.onPressed);
  final String i;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(0.1),
        child: Container(
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.blue))),
          child: Material(
            elevation: 10.0,
            color: Color(0xff000033),
            child: MaterialButton(
              onPressed: onPressed,
              minWidth: 200.0,
              height: 42.0,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  i,
                  style: TextStyle(fontSize: 18, color: Colors.white, letterSpacing: 1.0),
                ),
              ),
            ),
          ),
        ));
  }
}
