import 'package:flutter/material.dart';

class NewsCard extends StatelessWidget {

  final String title;

  final String subtitle;

  const NewsCard({required this.title, required this.subtitle, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        onTap: () {
          print('onTap');
        },
        trailing: const Icon(Icons.arrow_right),
      ),
    );
  }
}
