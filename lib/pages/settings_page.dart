import 'package:chat_app/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/user.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _controller = TextEditingController();
  final UserService _userService = UserService();

  bool _isEdit = false;
  bool _isAvatar = false;
  String? _avatarURL;
  String _displayName = 'no_name';

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

  _loadUser() async {
    final User user = await _userService.getCurrentUser();

    if (user.photoUrl != null) {
      setState(() {
        _isAvatar = true;
        _avatarURL = user.photoUrl;
      });
    }
    _displayName = user.displayName;
    _controller.text = _displayName;
  }

  void _edit() {
    setState(() {
      _isEdit = true;
    });
  }

  void _done() async {
    await _userService.setDisplayName(_controller.text);

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

    await _userService.updatePhotoUrl(image.path, image.name);
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
          ],
        ),
      ),
    );
  }
}
