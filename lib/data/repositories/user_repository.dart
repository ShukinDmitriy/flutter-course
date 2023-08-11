import 'package:connectivity_plus/connectivity_plus.dart';

import '../../models/user.dart';
import '../../services/network_user_service.dart';
import '../../services/db_user_service.dart';
import '../mappers/user_mapper.dart';

class UserRepository {
  final NetworkUserService _networkUserService;
  final DbUserService _dbUserService;

  UserRepository({required NetworkUserService networkUserService, required DbUserService dbUserService}) : _dbUserService = dbUserService, _networkUserService = networkUserService;

  Future<List<User>> getUsers({resetDb = false}) async {
    final dbUsers = await getUsersFromDb();
    if (dbUsers.isNotEmpty) {
      return dbUsers;
    }

    final fbUsers = await getUsersFromFirebase();

    await _dbUserService.clearUsers();
    for (var user in fbUsers) {
      _dbUserService.addUser(UserMapper.toDbUserFromUser(user));
    }

    return fbUsers;
  }

  Future<List<User>> getUsersFromDb() async {
    final dbUsers = await _dbUserService.getUsers();
    return Future.value(dbUsers.map((dbUser) => UserMapper.toUserFromDbUser(dbUser)).toList());
  }

  Future<List<User>> getUsersFromFirebase() async {
    late ConnectivityResult result;
    late bool hasConnection;
    try {
      result = await Connectivity().checkConnectivity();
      hasConnection = result != ConnectivityResult.none;
    } catch (e) {
      hasConnection = true;
    }

    if (!hasConnection) {
      return Future.value([]);
    }

    return (await _networkUserService.usersStream.firstWhere((element) => true)).toList();
  }
}