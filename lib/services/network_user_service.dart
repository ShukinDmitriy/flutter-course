import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/user.dart' as app_user;

class NetworkUserService {
  NetworkUserService(this.firebaseDatabase);

  final FirebaseDatabase firebaseDatabase;

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

  Future<app_user.User?> getUserByUid(String userId) async {
    final userSnapshot =
        await firebaseDatabase.ref().child('users').child(userId).get();
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
    Reference ref =
        FirebaseStorage.instance.ref().child("images").child(imageName);
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

  Future<List<app_user.User>> getContactUsers() async {
    final user = getCurrentUser();

    final contacts =
        (await firebaseDatabase.ref("userContacts/${user.id}").get()).value
            as List<Object?>?;

    if (contacts == null) {
      return [];
    }

    final users = Map<dynamic, dynamic>.from(
        (await firebaseDatabase.ref("users").get()).value
            as Map<dynamic, dynamic>);
    final List<app_user.User> userList = [];

    for (final fbUser in users.values) {
      final mapUser = Map<String, Object?>.from(fbUser);
      final user = app_user.User.fromJson(mapUser);
      if (contacts.contains(user.id)) {
        userList.add(user);
      }
    }

    return userList;
  }

  Future<bool> addUserToContact(String uid) async {
    try {
      if (uid == '') {
        throw ArgumentError('empty uid');
      }

      final user = getCurrentUser();

      if (user.id == uid) {
        throw ArgumentError('self user uid');
      }

      final addedUser =
          (await firebaseDatabase.ref("users/${uid}").get()).value;

      if (addedUser == null) {
        throw ArgumentError('user not found');
      }

      var userContacts =
          (await firebaseDatabase.ref("userContacts/${user.id}").get()).value
              as List<Object?>?;
      userContacts = userContacts != null ? [...userContacts] : [];

      if (userContacts.contains(uid)) {
        throw ArgumentError('user already exists');
      }

      userContacts.add(uid);

      await firebaseDatabase.ref("userContacts/${user.id}").set(userContacts);

      return Future.value(true);
    } catch (e) {
      print(e);
      return Future.value(false);
    }
  }

  Future<bool> removeUserFromContact(String uid) async {
    try {
      if (uid == '') {
        throw ArgumentError('empty uid');
      }

      final user = getCurrentUser();

      if (user.id == uid) {
        throw ArgumentError('self user uid');
      }

      final removedUser =
          (await firebaseDatabase.ref("users/${uid}").get()).value;

      if (removedUser == null) {
        throw ArgumentError('user not found');
      }

      var userContacts =
          (await firebaseDatabase.ref("userContacts/${user.id}").get()).value
              as List<Object?>?;
      userContacts = userContacts != null ? [...userContacts] : [];

      if (!userContacts.contains(uid)) {
        return Future.value(true);
      }

      userContacts.remove(uid);

      await firebaseDatabase.ref("userContacts/${user.id}").set(userContacts);

      return Future.value(true);
    } catch (e) {
      print(e);
      return Future.value(false);
    }
  }
}
