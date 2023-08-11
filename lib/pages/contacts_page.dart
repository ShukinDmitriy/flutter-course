import 'package:chat_app/notifiers/async_users_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../components/shimmer.dart';
import '../components/contact_item.dart';

class ContactsPage extends ConsumerWidget {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncUsers = ref.watch(asyncUsersNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
      ),
      body: asyncUsers.when(data: (userList) {
        if (userList.isNotEmpty) {
          return ListView(
            children: [
              for (final currentUser in userList)
                ContactItem(user: currentUser),
            ],
          );
        } else {
          return Shimmer(
            child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return const ContactItem(isShimmer: true);
                }),
          );
        }
      }, error: (err, stack) {
        return Text('Error: $err');
      }, loading: () {
        return Shimmer(
          child: ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) {
                return const ContactItem(isShimmer: true);
              }),
        );
      }),
    );
  }
}
