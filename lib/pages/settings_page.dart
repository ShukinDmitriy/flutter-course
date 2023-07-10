import 'package:chat_app/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

import '../models/user.dart' as app_user;
import 'share_profile.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _controller = TextEditingController();
  final getIt = GetIt.instance;

  bool _isEdit = false;
  bool _isAvatar = false;
  String? _avatarURL;
  String _displayName = 'no_name';
  String _id = '';

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _loadUser() {
    app_user.User user = getIt<UserService>().getCurrentUser();

    if (user.photoUrl != null) {
      setState(() {
        _isAvatar = true;
        _avatarURL = user.photoUrl;
      });
    }
    _displayName = user.displayName;
    _id = user.id;
    _controller.text = _displayName;
  }

  void _edit() {
    setState(() {
      _isEdit = true;
    });
  }

  void _done() async {
    await getIt<UserService>().updateUserDisplayName(_controller.text);

    setState(() {
      _isEdit = false;
      _displayName = _controller.text;
    });
  }

  void pickImage() async {
    final ImagePicker picker = ImagePicker();
    // Pick an image.
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) {
      return;
    }

    await getIt<UserService>().updateUserPhotoUrl(image.path, image.name);

    _loadUser();
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamed(context, '/sign-in');
  }

  _shareProfile() async {
    Navigator.pushNamed(
      context,
      ShareProfile.routeName,
      arguments: ShareArguments(_id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          _isEdit
              ? TextButton(onPressed: _done, child: const Text('Done'))
              : TextButton(onPressed: _edit, child: const Text('Edit')),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(top: 64.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: pickImage,
              child: CircleAvatar(
                radius: 32.0,
                backgroundImage: (_isAvatar && _avatarURL != null)
                    ? NetworkImage(_avatarURL!) as ImageProvider<Object>
                    : const AssetImage('assets/images/avatar.png'),
                backgroundColor: Colors.transparent,
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            _isEdit
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 64.0),
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  )
                : Text(
                    _displayName,
                    style: const TextStyle(fontSize: 24.0),
                  ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: _shareProfile,
                  child: const Text('Share profile'),
                ),
                const SizedBox(
                  width: 20.0,
                ),
                TextButton(
                  onPressed: _signOut,
                  child: const Text('Sign out'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
