import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni_links/uni_links.dart';

import '../components/main_bottom_bar.dart';
import '../notifiers/current_page_notifier.dart';
import '../pages/chats_page.dart';
import '../pages/contacts_page.dart';
import '../pages/settings_page.dart';
import 'chat_page.dart';

class HomePage extends ConsumerStatefulWidget {
  static const routeName = '/home';

  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  StreamSubscription? _sub;

  // It is assumed that all messages contain a data field with the key 'type'
  Future<void> setupInteractedMessage() async {
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    if (message.data['type'] == 'chat' &&
        message.data['chatUid'] &&
        message.data['displayName']) {
      Navigator.of(context).push(ChatPage.createRoute(
        message.data['title'] ?? 'Chat',
        message.data['chatUid'],
        message.data['userUid'],
        message.data['displayName'],
        message.data['avatarUrl'],
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    _handleIncomingLinks();

    // Run code required to handle interacted messages in an async function
    // as initState() must not be async
    setupInteractedMessage();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  void _handleIncomingLinks() {
    // chatapp://open/{ID}
    if (!kIsWeb) {
      _sub = uriLinkStream.listen((Uri? uri) {
        if (!mounted) return;
        print('got uri: $uri');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Got Deep Link"),
        ));
      }, onError: (Object err) {
        if (!mounted) return;
        print('got err: $err');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentPageIndex = ref.watch(currentPageNotifierProvider);

    return Scaffold(
      body: <Widget>[
        const ContactsPage(),
        const ChatsPage(),
        const SettingsPage(),
      ][currentPageIndex],
      bottomNavigationBar: const MainBottomBar(),
    );
  }
}
