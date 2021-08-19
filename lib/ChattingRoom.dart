import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'ChattingMessage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  TextEditingController _textEditingController = TextEditingController();
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('user'),
      ),
      body: SafeArea(   // 메시지 입력창 화면에 안가리도록
        child: Column(
          children: [
            messageList(),  // 메시지 가져오기
            Container(    // 메시지 입력, 보내기 버튼 감싼 컨테이너
              margin: EdgeInsets.symmetric(horizontal: 13.0),
              decoration: BoxDecoration(
                  color: const Color(0xf7eeeeee),
                  borderRadius: BorderRadius.circular(15.0)),
              padding: EdgeInsets.only(left:16, right:5, top:4, bottom:1),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(   // 메시지 입력필드
                      controller: _textEditingController,
                      minLines: 1,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: '메세지 입력',
                        border: InputBorder.none,
                        suffixIcon: IconButton(   // 전송 버튼
                          icon: Icon(Icons.send_rounded, color: Colors.grey,),
                          onPressed: () {_handleSubmitted('100', _textEditingController.text, Timestamp.now());}
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmitted(String sender, String text, Timestamp stamp) {
    _scrollToBottom();    // 메시지 전송 버튼 누르면 가장 아래로 스크롤 -> 메시지 없어도 작동
    if (text.trim() != '') {    // 메시지 있는가 판단
      _textEditingController.clear();

      // TODO: .collection() 안에 room1 -> room ID 받아오도록.
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
    }
  }

  CollectionReference lastMessage = FirebaseFirestore.instance.collection('Chatroom');

  Future <void> updateLastMessage(String text, Timestamp time){   // lastMessage, lastTime 반환 -> 채팅 리스트에 띄울 수 있게
    final String lastTime = DateFormat('yyyy-MM-dd, kk:mma')
        .format(time.toDate())
        .toString();
    return lastMessage
        .doc('room1')
        .update({'lastMessage': text, 'lastTime': lastTime})
        .then((value) => print('updated'));
  }

  Widget messageList() {    // 메시지 띄워줌
    return StreamBuilder<QuerySnapshot>(    // 스트림빌더 -> 실시간 업데이트!
        stream: FirebaseFirestore.instance
            .collection('Chatroom/room1/messages')
            .orderBy('time', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          final documents = snapshot.data!.docs;
          final _length = documents.length;
          return Expanded(
            child: ListView.builder(
                controller: _scrollController,
                reverse: true,
                itemCount: _length,
                itemBuilder: (context, index) {
                  final String sender =
                      documents[index].get('sender').toString();
                  final String text = documents[index].get('text').toString();
                  final time = documents[index].get('time');
                  final printTime;
                  final printDate;
                  //Time print 여부 판단
                  if (index != 0) {
                    final beforeTime = documents[index - 1].get('time');
                    final timeToDate = DateFormat('yyyy-MM-dd, kk:mma')
                        .format(time.toDate())
                        .toString();
                    final beforeTimeToDate = DateFormat('yyyy-MM-dd, kk:mma')
                        .format(beforeTime.toDate())
                        .toString();
                    if (timeToDate == beforeTimeToDate) {
                      printTime = false;
                    } else {
                      printTime = true;
                    }
                  } else {
                    printTime = true;
                  }
                  //Date print 여부 판단
                  if (index != _length - 1) {
                    final nextTime = documents[index + 1].get('time');
                    final timeToDate = DateFormat('yyyy-MM-dd')
                        .format(time.toDate())
                        .toString();
                    final nextTimeToDate = DateFormat('yyyy-MM-dd')
                        .format(nextTime.toDate())
                        .toString();
                    if (timeToDate == nextTimeToDate) {
                      printDate = false;
                    } else {
                      printDate = true;
                    }
                  } else {
                    printDate = true;
                  }
                  if (index == 0) {
                    updateLastMessage(text, time);

                  }
                  return Message(sender, text, time, printTime, printDate);
                }),
          );
        });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.minScrollExtent);
    }
  }
}
