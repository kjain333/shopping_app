import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPref{
  Future<dynamic> read(String key)async{
    final prefs = await SharedPreferences.getInstance();
    return (prefs.containsKey(key))?json.decode(prefs.getString(key)):null;
  }
  save(String key, value)async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }
  remove(String key)async{
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

}