import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../components/add_contact_button.dart';
import '../components/shimmer.dart';
import '../components/contact_item.dart';
import '../notifiers/async_users_notifier.dart';
import '../services/network_user_service.dart';

class ContactsPage extends ConsumerStatefulWidget {
  const ContactsPage({super.key});

  @override
  ConsumerState<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends ConsumerState<ContactsPage> {
  final inputController = TextEditingController();
  final userService = GetIt.instance<NetworkUserService>();

  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }

  onAddedContact(result) {
    Timer(const Duration(milliseconds: 10), () {
      ref.read(asyncUsersNotifierProvider.notifier).loadUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final asyncUsers = ref.watch(asyncUsersNotifierProvider);

    return asyncUsers.when(data: (userList) {
      if (userList.isNotEmpty) {
        return Scaffold(
          key: const ValueKey('userList'),
          appBar: AppBar(
            title: const Text('Contacts'),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: userList.length,
                    itemBuilder: (context, index) {
                      final currentUser = userList[index];
                      return ContactItem(user: currentUser);
                    }),
              ),
              AddContactButton(
                onAddedContact: onAddedContact,
              ),
            ],
          ),
        );
      } else {
        return Scaffold(
          key: const ValueKey('emptyUserList'),
          appBar: AppBar(
            title: const Text('Contacts'),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('You don\'t have contacts yet'),
              AddContactButton(
                onAddedContact: onAddedContact,
              ),
            ],
          ),
        );
      }
    }, error: (err, stack) {
      return Scaffold(
        key: const ValueKey('errorUserList'),
        appBar: AppBar(
          title: const Text('Contacts'),
        ),
        body: Text('Error: $err'),
      );
    }, loading: () {
      return Scaffold(
        key: const ValueKey('loadingUserList'),
        appBar: AppBar(
          title: const Text('Contacts'),
        ),
        body: Shimmer(
          child: ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) {
                return const ContactItem(isShimmer: true);
              }),
        ),
      );
    });
  }
}
