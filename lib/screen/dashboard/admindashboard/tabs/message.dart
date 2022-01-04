import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wakala/constants/constants.dart';

class Message extends StatefulWidget {
  static String id = "Messages";
  final data;
  const Message(this.data);

  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  final messageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final CollectionReference _message =
      FirebaseFirestore.instance.collection('message');

  Future<void> sendMessage() async {
    final formState = _formKey.currentState;
    if (formState!.validate()) {
      return _message
          .add({
            "message": messageController.text,
            "sender": FirebaseAuth.instance.currentUser!.uid,
            "trip": widget.data
          })
          .then((value) => print(value))
          .catchError((error) => print("Failed to send message: $error"));
    }
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        title: Text("Message"),
      ),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
              stream:
                  _message.where("trip", isEqualTo: widget.data).snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text("Something went wrong");
                }
                if (snapshot.hasData) {
                  return Text("done");
                }
                return Text("Loading");
              }),
          Spacer(flex: 2),
          Form(
            key: _formKey,
            child: Expanded(
              child: TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return ("Please Amount");
                  }
                  if (value.length > 6) {}
                },
                controller: messageController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter your message",
                  hintStyle: TextStyle(color: Colors.grey),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  isDense: true,
                  suffixIcon: IconButton(
                    onPressed: () {
                      sendMessage();
                    },
                    icon: Icon(Icons.send),
                  ),
                ),
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.black54,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
