import 'dart:io';

import 'package:chat_app/models/user.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class UserService {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final Reference _firebaseRef = FirebaseStorage.instance.ref();

  Stream<List<User>> get usersStream =>
      FirebaseDatabase.instance.ref("users").onValue.map((e) {
        final value = e.snapshot.value;
        final List<User> userList = [];

        if (value != null) {
          final firebaseUsers =
              Map<dynamic, dynamic>.from(value as Map<dynamic, dynamic>);

          firebaseUsers.forEach((key, value) {
            final user = Map<String, Object?>.from(value);
            userList.add(User.fromJson(user));
          });
        }

        return userList;
      });

  Future<String> getUuid() async {
    final SharedPreferences prefs = await _prefs;

    String? uuid = prefs.getString('uuid');

    if (uuid == null) {
      const uuidHelper = Uuid();
      uuid = uuidHelper.v4();
      prefs.setString('uuid', uuid);

      await saveUser();
    }

    return uuid;
  }

  Future<String> getDisplayName() async {
    final SharedPreferences prefs = await _prefs;

    String? displayName = prefs.getString('displayName');

    return displayName ?? 'no_name';
  }

  Future<void> setDisplayName(String displayName) async {
    final SharedPreferences prefs = await _prefs;

    prefs.setString('displayName', displayName);

    await saveUser();
  }

  Future<String?> getPhotoUrl() async {
    final SharedPreferences prefs = await _prefs;

    String? photoUrl = prefs.getString('photoUrl');

    return photoUrl;
  }

  Future<void> setPhotoUrl(String? photoUrl) async {
    final SharedPreferences prefs = await _prefs;

    photoUrl != null
        ? prefs.setString('photoUrl', photoUrl)
        : prefs.remove('photoUrl');

    await saveUser();
  }

  Future<void> updatePhotoUrl(String imagePath, String imageName) async {
    var imageFile = File(imagePath);
    Reference ref = _firebaseRef.child("images").child(imageName);
    await ref.putFile(imageFile);

    final downloadUrl = await ref.getDownloadURL();

    await setPhotoUrl(downloadUrl);
  }

  Future<User> getCurrentUser() async {
    return User(
        id: await getUuid(),
        displayName: await getDisplayName(),
        photoUrl: await getPhotoUrl());
  }

  Future<void> saveUser() async {
    final User user = await getCurrentUser();
    DatabaseReference ref = FirebaseDatabase.instance.ref("users/${user.id}");

    await ref.set(user.toJson());
  }
}
