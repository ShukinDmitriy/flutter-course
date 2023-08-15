import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../models/db_user.dart';

class DbUserService {
  late Isar _isar;

  DbUserService() {
    openIsar();
  }

  Future<void> openIsar() async {
    if (Isar.instanceNames.isEmpty) {
      final directory = await getApplicationDocumentsDirectory();
      _isar = await Isar.open([DbUserSchema],
          inspector: true, directory: directory.path);
    } else {
      _isar = await Future.value(Isar.getInstance());
    }
  }

  Future<void> addUser(DbUser user) async {
    final issetUser =
        await _isar.dbUsers.filter().userIdEqualTo(user.userId).findFirst();
    if (issetUser != null) {
      return;
    }

    await _isar.writeTxn(() async {
      await _isar.dbUsers.put(user);
    });
  }

  Future<List<DbUser>> getUsers() async {
    return await _isar.dbUsers.where().findAll();
  }

  Future<void> clearUsers() async {
    await _isar.writeTxn(() async {
      await _isar.dbUsers.clear();
    });
  }
}
