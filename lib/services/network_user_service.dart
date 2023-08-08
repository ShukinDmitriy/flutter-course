import 'dart:io';

import 'package:chat_app/models/user.dart' as app_user;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

class NetworkUserService {
  NetworkUserService(this.firebaseDatabase);

  final FirebaseDatabase firebaseDatabase;

  Stream<List<app_user.User>> get usersStream =>
      firebaseDatabase.ref("users").onValue.map((e) {
        final value = e.snapshot.value;
        final List<app_user.User> userList = [];

        if (value != null) {
          final firebaseUsers =
              Map<dynamic, dynamic>.from(value as Map<dynamic, dynamic>);

          firebaseUsers.forEach((key, value) {
            final user = Map<String, Object?>.from(value);
            userList.add(app_user.User.fromJson(user));
          });
        }

        return userList;
      });

  String getUuid() {
    final user = getCurrentUser();

    return user.id;
  }

  Future<void> updateUserDisplayName(String displayName) async {
    final firebaseUser = _getFirebaseUser();

    await firebaseUser.updateDisplayName(displayName);

    await addOrUpdateUser();
  }

  Future<String> getUserName(String userId) async {
    final dataSnapshot = await firebaseDatabase
        .ref()
        .child('users')
        .child(userId)
        .child('displayName')
        .get();

    return dataSnapshot.value.toString();
  }

  Future<app_user.User> getUser(String userId) async {
    final userSnapshot = await firebaseDatabase
        .ref()
        .child('users')
        .child(userId)
        .get();
    final userMap = Map<String, dynamic>.from(userSnapshot.value as Map);
    final user = app_user.User(
      id: userId,
      displayName: userMap['displayName'],
      photoUrl: userMap['photoUrl'],
    );

    return user;
  }

  String? getPhotoUrl() {
    final user = getCurrentUser();

    return user.photoUrl;
  }

  Future<String> updateUserPhotoUrl(String imagePath, String imageName) async {
    var imageFile = File(imagePath);
    Reference ref = FirebaseStorage.instance.ref().child("images").child(imageName);
    await ref.putFile(imageFile);

    final downloadUrl = await ref.getDownloadURL();

    final firebaseUser = _getFirebaseUser();

    await firebaseUser.updatePhotoURL(downloadUrl);

    await addOrUpdateUser();

    return downloadUrl;
  }

  User _getFirebaseUser() {
    final firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser == null) {
      throw Future.error('user is not authorized');
    }

    return firebaseUser;
  }

  app_user.User getCurrentUser() {
    final firebaseUser = _getFirebaseUser();

    return app_user.User(
        id: firebaseUser.uid,
        displayName: firebaseUser.displayName ?? 'no name',
        photoUrl: firebaseUser.photoURL);
  }

  Future<void> addOrUpdateUser() async {
    final user = getCurrentUser();

    DatabaseReference ref = firebaseDatabase.ref("users/${user.id}");

    await ref.set(user.toJson());
  }
}
