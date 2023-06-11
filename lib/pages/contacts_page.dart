import 'package:chat_app/services/user_service.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({Key? key}) : super(key: key);

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  final UserService _userService = UserService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
      ),
      body: StreamBuilder(
          stream: _userService.usersStream,
          initialData: [],
          builder: (ctx, snapshot) {
            final userList = snapshot.data;

            if (userList != null && userList.isNotEmpty) {
              return ListView.builder(
                  itemCount: userList.length,
                  itemBuilder: (context, index) {
                    final User currentUser = userList[index];

                    Widget leading;
                    if (currentUser.photoUrl == null) {
                      final String abbr = currentUser.displayName
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
                        backgroundImage: NetworkImage(currentUser.photoUrl!),
                        backgroundColor: Colors.transparent,
                      );
                    }

                    return ListTile(
                      leading: leading,
                      title: Text(currentUser.displayName),
                    );
                  });
            } else {
              return const Text('No contacts');
            }
          }),
    );
  }
}
