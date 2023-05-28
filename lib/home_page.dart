import 'package:chat_app/messages.dart';
import 'package:chat_app/bottom_bar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Messages(),
        bottomNavigationBar: const BottomBar());
  }
}
