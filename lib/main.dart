import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firestore_1/ChattingRoom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'chatting room',
      theme: ThemeData(
        primaryColor: const Color(0xff6990FF),
      ),
      home: ChatRoom(),
    );
  }
}