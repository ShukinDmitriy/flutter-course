import 'package:chat_app/services/user_service.dart';
import 'package:flutter/material.dart';

import '../components/contact_item.dart';
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

                    return ContactItem(user: currentUser);
                  });
            } else {
              return const Text('No contacts');
            }
          }),
    );
  }
}
