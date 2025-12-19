import '../../models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../core/error/exceptions.dart';

abstract class UserLocalDataSource {
  Future<UserModel> getLastUser();
  Future<void> cacheUser(UserModel user);
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final SharedPreferences prefs;
  static const cachedUserKey = "CACHED_USER";

  UserLocalDataSourceImpl({required this.prefs});

  @override
  Future<UserModel> getLastUser() {
    final jsonString = prefs.getString(cachedUserKey);
    if (jsonString != null) {
      return Future.value(UserModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException("No cached user found");
    }
  }

  @override
  Future<void> cacheUser(UserModel user) {
    return prefs.setString(cachedUserKey, json.encode(user.toJson()));
  }
}