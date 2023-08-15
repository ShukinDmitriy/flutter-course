import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../notifiers/current_page_notifier.dart';

class MainBottomBar extends ConsumerStatefulWidget {
  final ValueChanged<int>? onDestinationSelected;

  const MainBottomBar({super.key, this.onDestinationSelected});

  @override
  ConsumerState<MainBottomBar> createState() => _MainBottomBarState();
}

class _MainBottomBarState extends ConsumerState<MainBottomBar> {
  @override
  Widget build(BuildContext context) {
    final currentPageIndex = ref.watch(currentPageNotifierProvider);

    return NavigationBar(
      onDestinationSelected: (int index) {
        if (index == currentPageIndex) {
          return;
        }

        ref.read(currentPageNotifierProvider.notifier).setCurrentPage(index);

        if (widget.onDestinationSelected != null) {
          widget.onDestinationSelected!(index);
        }
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
    );
  }
}
