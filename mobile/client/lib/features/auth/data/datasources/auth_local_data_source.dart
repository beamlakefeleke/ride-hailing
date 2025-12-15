import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheAuthTokens({
    required String accessToken,
    required String refreshToken,
  });

  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<void> clearTokens();

  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearUser();

  Future<bool> isAuthenticated();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  static const String _accessTokenKey = 'ACCESS_TOKEN';
  static const String _refreshTokenKey = 'REFRESH_TOKEN';
  static const String _userKey = 'CACHED_USER';
  static const String _isAuthenticatedKey = 'IS_AUTHENTICATED';

  AuthLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> cacheAuthTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    try {
      await sharedPreferences.setString(_accessTokenKey, accessToken);
      await sharedPreferences.setString(_refreshTokenKey, refreshToken);
      await sharedPreferences.setBool(_isAuthenticatedKey, true);
    } catch (e) {
      throw CacheException('Failed to cache auth tokens: ${e.toString()}');
    }
  }

  @override
  Future<String?> getAccessToken() async {
    try {
      return sharedPreferences.getString(_accessTokenKey);
    } catch (e) {
      throw CacheException('Failed to get access token: ${e.toString()}');
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    try {
      return sharedPreferences.getString(_refreshTokenKey);
    } catch (e) {
      throw CacheException('Failed to get refresh token: ${e.toString()}');
    }
  }

  @override
  Future<void> clearTokens() async {
    try {
      await sharedPreferences.remove(_accessTokenKey);
      await sharedPreferences.remove(_refreshTokenKey);
      await sharedPreferences.setBool(_isAuthenticatedKey, false);
    } catch (e) {
      throw CacheException('Failed to clear tokens: ${e.toString()}');
    }
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      final userJson = user.toJson();
      final userJsonString = jsonEncode(userJson);
      await sharedPreferences.setString(_userKey, userJsonString);
    } catch (e) {
      throw CacheException('Failed to cache user: ${e.toString()}');
    }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final userJsonString = sharedPreferences.getString(_userKey);
      if (userJsonString == null) return null;
      final userJson = jsonDecode(userJsonString) as Map<String, dynamic>;
      return UserModel.fromJson(userJson);
    } catch (e) {
      throw CacheException('Failed to get cached user: ${e.toString()}');
    }
  }

  @override
  Future<void> clearUser() async {
    try {
      await sharedPreferences.remove(_userKey);
    } catch (e) {
      throw CacheException('Failed to clear user: ${e.toString()}');
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    try {
      return sharedPreferences.getBool(_isAuthenticatedKey) ?? false;
    } catch (e) {
      return false;
    }
  }
}

