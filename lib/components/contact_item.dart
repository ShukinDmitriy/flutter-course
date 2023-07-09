import 'package:chat_app/components/shimmer-loading.dart';
import 'package:chat_app/models/user.dart';
import 'package:flutter/material.dart';

class ContactItem extends StatelessWidget {
  final bool isShimmer;
  final User? user;

  const ContactItem({this.user, this.isShimmer = false, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget leading;
    if (user == null) {
      return ShimmerLoading(
          isLoading: true,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              leading: const CircleAvatar(
                radius: 32.0,
                backgroundColor: Color(0xffe1e1e1),
              ),
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

    if (user!.photoUrl == null) {
      final String abbr = user!.displayName
          .split(' ')
          .map((String e) => e[0].toUpperCase())
          .take(2)
          .join('');
      leading = CircleAvatar(
        radius: 32.0,
        backgroundColor: Colors.transparent,
        child: Text(abbr),
      );
    } else {
      leading = CircleAvatar(
        radius: 32.0,
        backgroundImage: NetworkImage(user!.photoUrl!),
        backgroundColor: Colors.transparent,
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: leading,
        title: Text(user!.displayName),
      ),
    );
  }
}
