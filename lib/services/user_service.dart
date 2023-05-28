import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class UserService {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  getUuid() async {
    final SharedPreferences prefs = await _prefs;

    String? uuid = prefs.getString('uuid');

    if (uuid == null) {
      const uuidHelper = Uuid();
      uuid = uuidHelper.v4();
      prefs.setString('uuid', uuid);
    }

    return uuid;
  }
}