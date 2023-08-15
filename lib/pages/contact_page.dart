import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../components/main_bottom_bar.dart';
import '../components/shimmer.dart';
import '../components/contact_item.dart';
import '../components/user_avatar.dart';
import '../data/repositories/user_repository.dart';
import '../models/user.dart';
import '../notifiers/async_chats_notifier.dart';
import '../notifiers/async_users_notifier.dart';
import '../services/network_user_service.dart';
import '../services/message_service.dart';
import 'chat_page.dart';

class ContactArguments {
  final String uid;

  ContactArguments(this.uid);
}

class ContactPage extends ConsumerStatefulWidget {
  static const routeName = '/contact';

  const ContactPage({super.key});

  @override
  ConsumerState<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends ConsumerState<ContactPage> {
  final MessageService messageService = GetIt.instance<MessageService>();
  final NetworkUserService userService = GetIt.instance<NetworkUserService>();
  final userProvider = FutureProvider.family<User, String>((ref, uid) async {
    return GetIt.instance<UserRepository>().getUserByUid(uid);
  });

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ContactArguments;
    final asyncUser = ref.watch(userProvider(args.uid));

    return asyncUser.when(data: (user) {
      return Scaffold(
        appBar: AppBar(
          title: Text(user.displayName),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: UserAvatar(
                  displayName: user.displayName, avatarUrl: user.photoUrl),
            ),
            Center(
              child: Text(user.displayName,
                  style: const TextStyle(fontSize: 24.0)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  padding: const EdgeInsets.all(15.0),
                  key: const ValueKey('startChat'),
                  onPressed: () async {
                    final chatUid = await messageService.createChat(user);
                    if (chatUid != null) {
                      await ref
                          .read(asyncChatsNotifierProvider.notifier)
                          .loadChats();
                      Navigator.of(context).push(ChatPage.createRoute(
                        user.displayName,
                        chatUid,
                        user.id,
                        user.displayName,
                        user.photoUrl,
                      ));
                    }
                  },
                  icon: const Icon(
                    Icons.message,
                    color: Colors.blue,
                    size: 50,
                  ),
                ),
                IconButton(
                  padding: const EdgeInsets.all(15.0),
                  key: const ValueKey('deleteContact'),
                  onPressed: () async {
                    final deleteUserResult =
                        await userService.removeUserFromContact(user.id);
                    if (deleteUserResult) {
                      await ref
                          .watch(asyncUsersNotifierProvider.notifier)
                          .loadUsers();
                      Navigator.pop(context);
                    }
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                    size: 50,
                  ),
                ),
              ],
            )
          ],
        ),
        bottomNavigationBar: MainBottomBar(
          onDestinationSelected: (int index) {
            Navigator.pop(context);
          },
        ),
      );
    }, error: (err, stack) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error: $err'),
        ),
        body: Shimmer(
          child: ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return const ContactItem(isShimmer: true);
              }),
        ),
        bottomNavigationBar: MainBottomBar(
          onDestinationSelected: (int index) {
            Navigator.pop(context);
          },
        ),
      );
    }, loading: () {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Loading...'),
        ),
        body: Shimmer(
          child: ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return const ContactItem(isShimmer: true);
              }),
        ),
        bottomNavigationBar: MainBottomBar(
          onDestinationSelected: (int index) {
            Navigator.pop(context);
          },
        ),
      );
    });
  }
}
