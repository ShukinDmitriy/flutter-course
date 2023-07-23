import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../components/shimmer.dart';
import '../components/contact_item.dart';
import '../data/repositories/user_repository.dart';
import '../models/user.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({Key? key}) : super(key: key);

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  final getIt = GetIt.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
      ),
      body: StreamBuilder(
          stream: getIt<UserRepository>().getUsers().asStream(),
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
              return Shimmer(
                child: ListView.builder(
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return const ContactItem(isShimmer: true);
                    }),
              );
            }
          }),
    );
  }
}
