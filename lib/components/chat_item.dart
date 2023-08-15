import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../components/shimmer-loading.dart';
import '../components/user_avatar.dart';

class ChatItem extends StatelessWidget {
  final Widget? leading;
  final String? title;
  final String? subtitle;
  final DateTime? date;
  final bool isShimmer;

  const ChatItem(
      {this.leading,
      this.title,
      this.subtitle,
      this.date,
      this.isShimmer = false,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isShimmer) {
      return ShimmerLoading(
          isLoading: true,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              leading: const UserAvatar(isShimmer: true),
              title: AspectRatio(
                aspectRatio: 16 / 1,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xffe1e1e1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ));
    }
    return ListTile(
      leading: leading,
      title: Text(title!),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: date != null ? Text(timeago.format(date!)) : null,
    );
  }
}
