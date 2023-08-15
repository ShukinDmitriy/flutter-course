import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final bool isShimmer;
  final bool isShowDefaultAvatar;
  final String? avatarUrl;
  final String? displayName;

  const UserAvatar(
      {String? this.displayName,
      String? this.avatarUrl,
      this.isShimmer = false,
      this.isShowDefaultAvatar = false,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (displayName == null) {
      return const CircleAvatar(
        radius: 32.0,
        backgroundColor: Color(0xffe1e1e1),
      );
    }

    if (avatarUrl != null || isShowDefaultAvatar) {
      return CircleAvatar(
        radius: 32.0,
        backgroundImage: avatarUrl != null
            ? NetworkImage(avatarUrl!) as ImageProvider<Object>
            : const AssetImage('assets/images/avatar.png'),
        backgroundColor: Colors.transparent,
      );
    } else {
      final String abbr = displayName!
          .split(' ')
          .map((String e) => e[0].toUpperCase())
          .take(2)
          .join('');
      return CircleAvatar(
        radius: 32.0,
        backgroundColor: Colors.transparent,
        child: Text(abbr),
      );
    }
  }
}
