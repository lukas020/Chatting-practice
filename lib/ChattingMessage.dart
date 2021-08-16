import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// DateFormat time 하는거
import 'package:intl/intl.dart';



class Message extends StatelessWidget {
  final String sender;
  final String text;
  final Timestamp stamp;
  // final DateTime time;

  Message(this.sender, this.text, this.stamp);

  @override
  Widget build(BuildContext context) {
    if (sender == '200') return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
      child: Row(
        children: [
          //프로필 사진
          CircleAvatar(
            backgroundImage: AssetImage('assets/crang.png'),
            radius: 20.0,
          ),
          SizedBox(width: 10),
          Expanded(
            //이름, 메시지
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(sender, style: TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Container(
                      child: Text(text, style: TextStyle(fontSize: 15)),
                      padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                      decoration: BoxDecoration(color: const Color(0x9ebed8ff), borderRadius: BorderRadius.circular(8.0)),
                    ),
                    SizedBox(width: 5),
                    Column(
                      children: [
                        SizedBox(height: 13),
                        Text(
                          DateFormat('kk:mma').format(stamp.toDate()).toString(),
                          style: TextStyle(color: Colors.grey, fontSize: 13.5),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //         Text(
          //           DateFormat('kk:mma').format(stamp.toDate()).toString(),
          //           // DateFormat('kk:mma').format(time).toString(),
          //           // 연월일 표시 : DateFormat('yyyy-MM-dd, kk:mma').format(date).toString(),
          //           style: TextStyle(color: Colors.grey),
          //         ),
          //     ],
          //   ),
        ],
      ),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            children: [
              SizedBox(height: 13),
              Text(
                DateFormat('kk:mma').format(stamp.toDate()).toString(),
                style: TextStyle(color: Colors.grey, fontSize: 13.5),
                // DateFormat('kk:mma').format(time).toString(),
                // 연월일 표시 : DateFormat('yyyy-MM-dd, kk:mma').format(date).toString(),
              ),
            ],
          ),
          SizedBox(width: 5),
          Container(
            child: Text(text, style: TextStyle(fontSize: 15)),
            padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
            decoration: BoxDecoration(color: const Color(0xf7eeeeee), borderRadius: BorderRadius.circular(8.0)),
          ),
        ],
      ),
    );
  }
}