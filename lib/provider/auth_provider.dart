import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:outdo_app/model/user_model.dart';
import 'package:outdo_app/provider/shared_pref_helper.dart';
import 'package:outdo_app/util/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/common_functions.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _userId;
  String? _token;
  User _user = User();

  bool get isLoading => _isLoading;
  String? get userId => _userId;
  String? get token => _token;
  User get user => _user;

  Future<void> login(
      String email, String password, BuildContext context) async {
    var url = AppConstants.baseUrl + AppConstants.loginUri;
    _isLoading = true;
    notifyListeners();
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'api_key': AppConstants.apikey,
          'txt_user_name': email,
          'txt_user_pass': password,
        },
      );
      final responseData = json.decode(response.body);
      log('response data is : $responseData');
      if (responseData['success'] == true) {
        final user = UserModel.fromJson(jsonDecode(response.body));
        _user = user.user!;
        _userId = _user.id;
        _token = _user.token;
        log('user : ${_user.toJson()}');

        await SharedPreferenceHelper().setAuthToken(_token!);
        await SharedPreferenceHelper().setUserId(_userId!);
        final prefs = await SharedPreferences.getInstance();
        final userData = json.encode({
          'token': _token,
          'user_id': _userId,
          'user': jsonEncode(_user),
        });
        prefs.setString('userData', userData);
      } else {
        throw const HttpException('Auth Failed');
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      // const errorMsg = 'Could not authenticate!';
      // CommonFunctions.showErrorDialog(errorMsg, context);
      rethrow;
    }
  }

  Future<bool> logOut() async {
    var url = AppConstants.baseUrl + AppConstants.logOut;
    String? token = await SharedPreferenceHelper().getAuthToken();

    try {
      final response = await http.post(Uri.parse(url), body: {
        'api_key': AppConstants.apikey,
        'token': token,
      });
      final responseData = jsonDecode(response.body);
      if (responseData['success'] == true) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // CommonFunctions.showErrorToast(e.toString());
      return false;
    }
  }
}
