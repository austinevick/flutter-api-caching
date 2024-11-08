import 'dart:async';
import 'dart:convert';

import 'package:api_caching/preferences.dart';
import 'package:api_caching/users_response_model.dart';
import 'package:http/http.dart';

class Repository {
  Future<UserResponseModel> getUsers() async {
    final cachedData = await Preferences.getCachedData('user');

    if (cachedData == null) {
      try {
        final response = await get(
            Uri.parse('https://jsonplaceholder.typicode.com/users/1'));
        final data = jsonDecode(response.body);
        print(data);
        await Preferences.cacheData('user', data, 1);
        return UserResponseModel.fromJson(data);
      } catch (e) {
        rethrow;
      }
    } else {
      return UserResponseModel.fromJson(cachedData);
    }
  }
}
