import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wakala/constants/constants.dart';

class Message extends StatefulWidget {
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
            "trip": widget.data,
            "textingtime": DateTime.now()
          })
          .then((value) => print(value))
          .catchError((error) => print("Failed to send message: $error"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        backgroundColor: kPrimaryColor,
        title: const Text("Message"),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 18,
            ),
            StreamBuilder<QuerySnapshot>(
              stream: _message
                  .where('trip', isEqualTo: widget.data)
                  .orderBy("textingtime", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: Text("No messages, start conversation"),
                  );
                }
                final messages = snapshot.data!.docs.reversed;
                List<MessageBubble> messageBubbles = [];
                for (var message in messages) {
                  final messageText = message.get('message');
                  final messageSender = message.get('sender');
                  final currentUser = FirebaseAuth.instance.currentUser!.uid;

                  final messageBubble = MessageBubble(
                    sender: messageSender,
                    text: messageText,
                    isMe: currentUser == messageSender,
                  );

                  messageBubbles.add(messageBubble);
                }
                return Expanded(
                  child: ListView(
                    reverse: true,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6.0, vertical: 4.0),
                    children: messageBubbles,
                  ),
                );
              },
            ),
            Form(
              key: _formKey,
              child: Expanded(
                flex: 1,
                child: TextFormField(
                  controller: messageController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter your message",
                    hintStyle: const TextStyle(color: Colors.grey),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    isDense: true,
                    suffixIcon: IconButton(
                      onPressed: () {
                        sendMessage();
                        messageController.clear();
                      },
                      icon: const Icon(
                        Icons.send,
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble(
      {Key? key, required this.sender, required this.text, required this.isMe})
      : super(key: key);

  final String sender;
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            sender,
            style: const TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
          Material(
            borderRadius: isMe
                ? const BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0))
                : const BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
            elevation: 5.0,
            color: isMe ? kPrimaryColor : kSecondaryColor,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                text,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black54,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
