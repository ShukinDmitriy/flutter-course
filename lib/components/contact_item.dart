import 'package:chat_app/models/user.dart';
import 'package:flutter/material.dart';

class ContactItem extends StatelessWidget {
  final User user;

  const ContactItem({required this.user, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget leading;
    if (user.photoUrl == null) {
      final String abbr = user.displayName
          .split(' ')
          .map((String e) => e[0].toUpperCase())
          .take(2)
          .join('');
      leading = CircleAvatar(
        radius: 32.0,
        child: Text(abbr),
        backgroundColor: Colors.transparent,
      );
    } else {
      leading = CircleAvatar(
        radius: 32.0,
        backgroundImage: NetworkImage(user.photoUrl!),
        backgroundColor: Colors.transparent,
      );
    }

    return ListTile(
      leading: leading,
      title: Text(user.displayName),
    );
  }
}
