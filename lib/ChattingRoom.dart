import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'ChattingMessage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';


class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  TextEditingController _textEditingController = TextEditingController();
  ScrollController _scollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('user'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            //message list 가져오기
            messageList(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  //하단바
                  Expanded(
                    // 메세지 입력창
                    child: TextField(
                      controller: _textEditingController,
                      decoration: InputDecoration(hintText: '메세지 입력'),
                      // enter로 제출 시
                      onSubmitted: (input) {
                        _handleSubmitted('100', _textEditingController.text, Timestamp.now());
                      },
                    ),
                  ),
                  SizedBox(
                    // 입력창, 버튼 거리 띄우기
                    width: 10.0,
                  ),
                  // 보내기 버튼
                  MaterialButton(
                    onPressed: () {_handleSubmitted('100', _textEditingController.text, Timestamp.now());},
                    child: Text('send'),
                    color: const Color(0xff6990FF),
                  ),
                ],
              ),
            ),
            // SizedBox(
            //   height: 25.0,
            // )
          ],
        ),
      ),
    );
  }

  void _handleSubmitted(String sender, String text, Timestamp stamp) {
    if (text.trim() != '') {
      _textEditingController.clear();

      var documentReference = FirebaseFirestore.instance
          .collection('Chatroom/room1/messages')
          .doc();

      FirebaseFirestore.instance.runTransaction((transaction) async => {
        transaction.set(
          documentReference,
          {
            'sender': sender,
            'text': text,
            'time': stamp,
          },
        )
      });

      // final newMessage = Message(_textEditingController.text, DateTime.now().toString());
    }
    else {
      Fluttertoast.showToast(msg: 'Nothing to send', backgroundColor: Colors.black, textColor: Colors.red);
    }
  }

  Widget messageList() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Chatroom/room1/messages')
            .orderBy('time')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          final documents = snapshot.data!.docs;
          final _length = documents.length;
          return Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _length,
              itemBuilder: (context, index){
                // return Message(documents[(_length-1)-index].get('text').toString());
                return Message(documents[(_length-1)-index].get('sender').toString(),documents[(_length-1)-index].get('text').toString(), documents[(_length-1)-index].get('time'));
              }),
            );
        }
    );
  }
}


