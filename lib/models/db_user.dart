import 'package:isar/isar.dart';

part 'db_user.g.dart';

@Collection()
class DbUser {
  Id id;
  String userId;
  String displayName;
  String? photoUrl;

  DbUser({
    required this.userId,
    required this.displayName,
    this.photoUrl
  }) : id = Isar.autoIncrement;
}