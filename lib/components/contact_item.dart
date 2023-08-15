import 'package:flutter/material.dart';

import '../components/shimmer-loading.dart';
import '../models/user.dart';
import '../pages/contact_page.dart';
import 'user_avatar.dart';

class ContactItem extends StatelessWidget {
  final bool isShimmer;
  final User? user;

  const ContactItem({this.user, this.isShimmer = false, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (user == null) {
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

    return GestureDetector(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            leading: UserAvatar(
                displayName: user!.displayName, avatarUrl: user!.photoUrl),
            title: Text(user!.displayName),
          ),
        ),
        onTap: () {
          Navigator.pushNamed(context, ContactPage.routeName,
              arguments: ContactArguments(user!.id));
        });
  }
}
