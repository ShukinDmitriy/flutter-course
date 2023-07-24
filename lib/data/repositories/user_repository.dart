import 'package:connectivity_plus/connectivity_plus.dart';

import '../../models/user.dart';
import '../../services/network_user_service.dart';
import '../../services/db_user_service.dart';
import '../mappers/user_mapper.dart';

class UserRepository {
  final NetworkUserService _networkUserService;
  final DbUserService _dbUserService;

  UserRepository({required NetworkUserService networkUserService, required DbUserService dbUserService}) : _dbUserService = dbUserService, _networkUserService = networkUserService;

  Future<List<User>> getUsers() async {
    final dbUsers = await _dbUserService.getUsers();
    if (dbUsers.isNotEmpty) {
      return Future.value(dbUsers.map((dbUser) => UserMapper.toUserFromDbUser(dbUser)).toList());
    }

    late ConnectivityResult result;
    late bool hasConnection;
    try {
      result = await Connectivity().checkConnectivity();
      hasConnection = result != ConnectivityResult.none;
    } catch (e) {
      hasConnection = true;
    }

    if (!hasConnection) {
      return Future.value(dbUsers.map((dbUser) => UserMapper.toUserFromDbUser(dbUser)).toList());
    }

    final users = _networkUserService.usersStream.firstWhere((element) => true);

    users.then((users) => {
      users.forEach((user) {
        _dbUserService.addUser(UserMapper.toDbUserFromUser(user));
      })
    });

    return users;
  }
}