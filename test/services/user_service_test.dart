import 'package:chat_app/models/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chat_app/services/user_service.dart';
import 'package:firebase_database_mocks/firebase_database_mocks.dart';
import 'package:firebase_database/firebase_database.dart';

void main() {
  late FirebaseDatabase firebaseDatabase;
  late UserService userService;

  const fakeUserId = 'fakeUserId';
  const fakeUserName = 'fakeUserName';
  const fakeUserPhotoUrl = 'url-to-photo.jpg';
  const fakeUser = {
    'displayName': fakeUserName,
    'photoUrl': fakeUserPhotoUrl,
  };
  const fakeData = {
    'users': {
      fakeUserId: fakeUser,
    }
  };
  MockFirebaseDatabase.instance.ref().set(fakeData);

  setUp(() {
    firebaseDatabase = MockFirebaseDatabase.instance;
    userService = UserService(firebaseDatabase);
  });

  group('UserService', () {
    test('getUserName should return user name', () async {
      final userNameFromFakeDatabase =
          await userService.getUserName(fakeUserId);

      expect(userNameFromFakeDatabase, equals(fakeUserName));
    });

    test('getUser should return user', () async {
      final userFromFakeDatabase = await userService.getUser(fakeUserId);

      expect(
          userFromFakeDatabase,
          equals(const User(
              id: fakeUserId,
              displayName: fakeUserName,
              photoUrl: fakeUserPhotoUrl)));
    });
  });
}
