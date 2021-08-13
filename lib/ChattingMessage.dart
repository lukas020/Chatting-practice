import 'package:flutter/material.dart';
// DateFormat time 하는거
import 'package:intl/intl.dart';

class Message extends StatelessWidget {
  final String sender = '100';
  final String text;
  final DateTime time;

  Message(this.text, this.time);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                Text(text),
              ],
            ),
          ),
          // 시간 표시
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                //toString 꼭 해야하는가 ?
                DateFormat('kk:mma').format(time).toString(),
                // 연월일 표시 : DateFormat('yyyy-MM-dd, kk:mma').format(date).toString(),
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}