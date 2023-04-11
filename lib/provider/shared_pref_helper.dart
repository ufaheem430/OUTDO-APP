// ignore_for_file: constant_identifier_names
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  Future<bool> setAuthToken(String? token) async {
    final pref = await SharedPreferences.getInstance();
    return pref.setString(UserPref.AuthToken.toString(), token!);
  }

  Future<String?> getAuthToken() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(UserPref.AuthToken.toString());
  }

  // Future<bool> setUserData(String userData) async {
  //   final pref = await SharedPreferences.getInstance();
  //   return pref.setString(userPref.UserData.toString(), userData);
  // }
  //
  // Future<String?> getUserData() async {
  //   final pref = await SharedPreferences.getInstance();
  //   return pref.getString(userPref.UserData.toString());
  // }

  Future<bool> setUserImage(String image) async {
    final pref = await SharedPreferences.getInstance();
    return pref.setString(UserPref.Image.toString(), image);
  }

  Future<String?> getUserImage() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(UserPref.Image.toString());
  }

  Future<bool> setUserId(String? id) async {
    final pref = await SharedPreferences.getInstance();
    return pref.setString(UserPref.UserId.toString(), id!);
  }

  Future<String?> getUserId() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(UserPref.UserId.toString());
  }
}

enum UserPref {
  AuthToken,
  Image,
  UserId,
}
