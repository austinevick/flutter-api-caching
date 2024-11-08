import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static Future<void> cacheData(
      String key, dynamic data, int expiryInMinutes) async {
    final prefs = await SharedPreferences.getInstance();
    final expiryTime = DateTime.now()
        .add(Duration(minutes: expiryInMinutes))
        .millisecondsSinceEpoch;
    prefs.setString(key, jsonEncode({"data": data, "expiry": expiryTime}));
  }

  static Future<dynamic> getCachedData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(key);
    if (data != null) {
      final cachedData = jsonDecode(data);
      print(cachedData);
      final expiry = cachedData['expiry'] as int;
      if (DateTime.now().millisecondsSinceEpoch < expiry) {
        return cachedData['data'];
      } else {
        prefs.remove(key);
      }
    }
    return null;
  }
}
