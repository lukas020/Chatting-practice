import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'ChattingMessage.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  TextEditingController _textEditingController = TextEditingController();
  // ScrollController _scollController = ScrollController();

  CollectionReference col = FirebaseFirestore.instance.collection('Chatroom');

  //message를 list에 담아둠.
  List<Message> _chats = [];

  @override
  Widget build(BuildContext context) {
    var documents;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('user'),
      ),
      body: Column(
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
                      _handleSubmitted();
                    },
                  ),
                ),
                SizedBox(
                  // 입력창, 버튼 거리 띄우기
                  width: 10.0,
                ),
                // 보내기 버튼
                MaterialButton(
                  onPressed: () {
                    _handleSubmitted(
                        //documents.single.get('writer')
                    );
                  },
                  child: Text('send'),
                  color: const Color(0xff6990FF),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 25.0,
          )
        ],
      ),
    );
  }

  void _handleSubmitted() {
    if (_textEditingController.text.length > 0) {
      final newMessage = Message(_textEditingController.text, DateTime.now());


      setState(() {
        _chats.insert(0, newMessage);
      });
      _textEditingController.clear();
      // _animListKey.currentState!.insertItem(0);
    }
  }

  Widget messageList() {
    return Flexible(
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Chatroom/room1/messages')
              // .collection('Chatroom')
              // .doc('room1')
              // .collection('messages')
              .orderBy('time', descending: true)
              .snapshots(),
          // FirebaseFirestore.instance.collection('Chatroom/room1/messages').orderBy('timestamp', descending: true).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData){
              listMessage
            }
            documents = snapshot.data!.docs;
            return Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  print(snapshot.data!.docs.length,);
                  FirebaseFirestore.instance
                      .collection('Chatroom/room1/messages')
                      .where('sender', isEqualTo: '100')
                      .get()
                      .then((value) {
                    print(value.docs.single.data().toString());
                  });
                  // print(documents.single.get('writer'));
                  // print(documents.single.get('reader'));
                  return _chats[index];
                },
              ),
            );
          }),
    ),
  }
}


