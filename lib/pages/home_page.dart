import 'package:chat_app/pages/chats_page.dart';
import 'package:chat_app/pages/contacts_page.dart';
import 'package:chat_app/pages/settings_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 2;

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