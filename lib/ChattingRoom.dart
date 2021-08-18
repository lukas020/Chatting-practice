import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'ChattingMessage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  TextEditingController _textEditingController = TextEditingController();
  ScrollController _scrollController = ScrollController();
// String a = '';
//   @override
//   void initState() {
//     super.initState();
//     FirebaseFirestore.instance
//         .collection('Chatroom')
//         .snapshots()
//         .single
//         .then((value) {
//        a = value.docs.single.get('userA');
//     });
//   }

  @override
  Widget build(BuildContext context) {

    // print (a);
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
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                  color: const Color(0xf7eeeeee),
                  borderRadius: BorderRadius.circular(15.0)),
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  //하단바
                  Expanded(
                    // 메세지 입력창
                    child: TextField(
                      controller: _textEditingController,
                      decoration: InputDecoration.collapsed(
                        hintText: '메세지 입력',
                        border: InputBorder.none,
                      ),
                      // enter로 제출 시
                      onSubmitted: (input) {
                        _handleSubmitted('100', _textEditingController.text,
                            Timestamp.now());
                      },
                    ),
                  ),
                  SizedBox(
                    // 입력창, 버튼 거리 띄우기
                    width: 10.0,
                  ),
                  // 보내기 버튼
                  Container(
                    width: 65.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(300.0)
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xff6990FF),
                      ),
                      onPressed: () {
                        _handleSubmitted(
                            '100', _textEditingController.text, Timestamp.now());
                      },
                      child: Text('send', style: TextStyle(color: Colors.white/*const Color(0xfff3f3f3)*/),),
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
    _scrollToBottom();
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
    }
  }

  Widget messageList() {
    return StreamBuilder<QuerySnapshot>(
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
                  //Time print 여부
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
                  //Date print 여부
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
