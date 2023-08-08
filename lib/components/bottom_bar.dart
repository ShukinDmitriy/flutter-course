import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'send_button.dart';

class BottomBar extends ConsumerWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatProvider = StateProvider<int>((ref) => 0, name: 'chatProvider');

    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Row(
        children: [
          Expanded(
            child: BottomAppBar(
              child: TextField(
                controller: _controller,
                style: const TextStyle(fontSize: 16.0),
                decoration: const InputDecoration(
                  labelText: 'Message',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 8.0,
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                ),
              ),
            ),
          ),
          SendButton(
            controller: _controller,
          )
        ],
      ),
    );
  }
}

class _BottomBarState extends State<BottomBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Row(
        children: [
          Expanded(
            child: BottomAppBar(
              child: TextField(
                controller: _controller,
                style: const TextStyle(fontSize: 16.0),
                decoration: const InputDecoration(
                  labelText: 'Message',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 8.0,
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                ),
              ),
            ),
          ),
          SendButton(
            controller: _controller,
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
