import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/saved_address_model.dart';

abstract class LocationLocalDataSource {
  Future<List<SavedAddressModel>> getCachedSavedAddresses();
  Future<void> cacheSavedAddresses(List<SavedAddressModel> addresses);
  Future<void> clearCachedAddresses();
}

class LocationLocalDataSourceImpl implements LocationLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String CACHED_SAVED_ADDRESSES_KEY = 'CACHED_SAVED_ADDRESSES';

  LocationLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<List<SavedAddressModel>> getCachedSavedAddresses() async {
    try {
      final jsonString = sharedPreferences.getString(CACHED_SAVED_ADDRESSES_KEY);
      if (jsonString != null) {
        final List<dynamic> jsonList = json.decode(jsonString);
        return jsonList
            .map((json) => SavedAddressModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      throw CacheException('Failed to get cached saved addresses');
    }
  }

  @override
  Future<void> cacheSavedAddresses(List<SavedAddressModel> addresses) async {
    try {
      final jsonString = json.encode(
        addresses.map((address) => address.toJson()).toList(),
      );
      await sharedPreferences.setString(CACHED_SAVED_ADDRESSES_KEY, jsonString);
    } catch (e) {
      throw CacheException('Failed to cache saved addresses');
    }
  }

  @override
  Future<void> clearCachedAddresses() async {
    try {
      await sharedPreferences.remove(CACHED_SAVED_ADDRESSES_KEY);
    } catch (e) {
      throw CacheException('Failed to clear cached addresses');
    }
  }
}

