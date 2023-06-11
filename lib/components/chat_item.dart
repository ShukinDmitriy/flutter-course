import 'package:flutter/material.dart';

class ChatItem extends StatelessWidget {
  final String leading;
  final String title;
  final String subtitle;
  final String date;

  const ChatItem({required this.leading, required this.title, required this.subtitle, required this.date, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(child: Text(leading)),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Text(date),
    );
  }
}
