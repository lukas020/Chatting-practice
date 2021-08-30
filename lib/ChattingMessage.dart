import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // DateFormat time 하는거

class Message extends StatelessWidget {
  final String sender;
  final String text;
  final Timestamp stamp;
  final bool printTime;
  final bool printDate;

  Message(this.sender, this.text, this.stamp, this.printTime, this.printDate);

  @override
  Widget build(BuildContext context) {
    if (sender == '200')
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        child: Column(
          children: [
            (printDate == true)
                ? Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    DateFormat('yyyy-MM-dd').format(stamp.toDate()).toString(),
                    style: TextStyle(color: Colors.grey, fontSize: 13.5),
                  ),
                  width: 100,
                  height: 20,
                  decoration: BoxDecoration(
                      color: const Color(0xf7eeeeee),
                      borderRadius: BorderRadius.circular(8.0)),
                ),
                SizedBox(
                  height: 18,
                )
              ],
            )
                : Container()
            ,
            Row(
              children: [
                //프로필 사진
                CircleAvatar(
                  backgroundImage: AssetImage('assets/crang.png'),
                  radius: 20.0,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(    // 이름, 메시지
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(sender,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            constraints: BoxConstraints(maxWidth: 280),
                            child: Text(text, style: TextStyle(fontSize: 15)),
                            padding:
                                EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                            decoration: BoxDecoration(
                                color: const Color(0xf7eeeeee),
                                borderRadius: BorderRadius.circular(8.0)),
                          ),
                          SizedBox(width: 5),
                          Container(
                            padding: EdgeInsets.only(bottom:4),
                            child: Text(
                              ((printTime == true)
                                  ? DateFormat('kk:mma')
                                      .format(stamp.toDate())
                                      .toString()
                                  : ""),
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 13.5),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: [
          (printDate == true)
              ? Column(
                children: [
                  Container(
                      alignment: Alignment.center,
                      child: Text(
                        // DateFormat : yyyy-MM-dd (연월일), kk:mma (시간분)
                        DateFormat('yyyy-MM-dd').format(stamp.toDate()).toString(),
                        style: TextStyle(color: Colors.grey, fontSize: 13.5),
                      ),
                    width: 100,
                    height: 20,
                    decoration: BoxDecoration(
                        color: const Color(0xf7eeeeee),
                        borderRadius: BorderRadius.circular(8.0)),
                    ),
                  SizedBox(
                    height: 18,
                  )
                ],
              )
              : Container()
          ,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 4),
                child: Text(((printTime == true)
                      ? DateFormat('kk:mma').format(stamp.toDate()).toString()
                      : ""),
                  style: TextStyle(color: Colors.grey, fontSize: 13.5),
                ),
              ),
              SizedBox(width: 5),
              Container(
                constraints: BoxConstraints(maxWidth: 280),
                child: Text(text, style: TextStyle(fontSize: 15)),
                padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                decoration: BoxDecoration(
                    color: const Color(0x9ebed8ff),
                    borderRadius: BorderRadius.circular(8.0)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
