import '../../models/db_user.dart';
import '../../models/user.dart';
import '../../models/network_user.dart';

class UserMapper {
  static User toUserFromNetworkUser(NetworkUser networkUser) {
    return User(
        id: networkUser.id,
        displayName: networkUser.displayName,
        photoUrl: networkUser.photoUrl);
  }

  static User toUserFromDbUser(DbUser dbUser) {
    return User(
        id: dbUser.userId,
        displayName: dbUser.displayName,
        photoUrl: dbUser.photoUrl);
  }
  
  static DbUser toDbUserFromNetworkUser(NetworkUser networkUser) {
    return DbUser(
        userId: networkUser.id,
        displayName: networkUser.displayName,
        photoUrl: networkUser.photoUrl);
  }
  
  static DbUser toDbUserFromUser(User user) {
    return DbUser(
        userId: user.id,
        displayName: user.displayName,
        photoUrl: user.photoUrl);
  }
}
