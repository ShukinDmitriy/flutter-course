import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../components/shimmer.dart';
import '../components/contact_item.dart';
import '../data/repositories/user_repository.dart';
import '../models/user.dart';

class ContactsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final getIt = GetIt.instance;
    // final exampleProvider = ref.watch(ExampleProvider);
    // print(exampleProvider.toString());

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
