import 'dart:async';

import 'package:chat_app/pages/chats_page.dart';
import 'package:chat_app/pages/contacts_page.dart';
import 'package:chat_app/pages/settings_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart';

import 'chat_page.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 1;

  StreamSubscription? _sub;

  // It is assumed that all messages contain a data field with the key 'type'
  Future<void> setupInteractedMessage() async {
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    if (message.data['type'] == 'chat') {
      Navigator.of(context).push(ChatPage.createRoute(message.data['title'] ?? 'Chat'));
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
    return Scaffold(
        body: <Widget>[
          const ContactsPage(),
          const ChatsPage(),
          const SettingsPage(),
        ][currentPageIndex],
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          selectedIndex: currentPageIndex,
          destinations: const <Widget>[
            NavigationDestination(
              icon: Icon(Icons.people_alt),
              label: 'Contacts',
            ),
            NavigationDestination(
              icon: Icon(Icons.chat),
              label: 'Chats',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.settings),
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ));
  }
}
