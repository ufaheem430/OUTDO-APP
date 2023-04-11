import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:outdo_app/model/meeting_model.dart';
import 'package:outdo_app/provider/shared_pref_helper.dart';
import 'package:outdo_app/util/app_constants.dart';

import '../widgets/common_functions.dart';

class MeetingProvider with ChangeNotifier {
  bool _isLoading = false;
  Meeting? _meeting;
  List<Completed> _completedMeetings = [];
  List<Upcoming> _upcomingMeetings = [];
  List<Delay> _delayMeetings = [];

  bool get isLoading => _isLoading;
  Meeting? get meeting => _meeting;

  List<Completed> get completedMeetings => _completedMeetings;
  List<Upcoming> get upcomingMeetings => _upcomingMeetings;
  List<Delay> get delayMeetings => _delayMeetings;

  Future<void> fetchMeetings(String userId) async {
    var url = AppConstants.baseUrl + AppConstants.meetingsUri;
    String? token = await SharedPreferenceHelper().getAuthToken();
    log('userid : $userId');
    log('token : $token');
    log('apikey : ${AppConstants.apikey}');
    _isLoading = true;
    notifyListeners();
    try {
      final response = await http.post(Uri.parse(url), body: {
        'api_key': AppConstants.apikey,
        'token': token,
        'user_id': userId,
      });
      final responseData = jsonDecode(response.body);
      if (responseData['success'] == true) {
        final m = MeetingModel.fromJson(jsonDecode(response.body));
        _meeting = m.meeting;
        _completedMeetings = _meeting!.completed!;
        _upcomingMeetings = _meeting!.upcoming!;
        _delayMeetings = _meeting!.delay!;
      } else {
        throw const HttpException('');
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      log('errors is : $e');
      _isLoading = false;
      notifyListeners();
      // const errorMsg = 'Could get meetings!';
      // CommonFunctions.showErrorToast(errorMsg);
      rethrow;
    }
  }

  String _rescheduleMeetingMessage = '';
  String get rescheduleMeetingMessage => _rescheduleMeetingMessage;
  // bool _isRescheduleLoading = false;
  // bool get isRescheduleLoading => _isRescheduleLoading;

  Future<bool> rescheduleMeeting(
      Upcoming meet, String datetime, String comment) async {
    var url = AppConstants.baseUrl + AppConstants.rescheduleMeeting;
    String? token = await SharedPreferenceHelper().getAuthToken();
    meet.isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(Uri.parse(url), body: {
        'api_key': AppConstants.apikey,
        "meeting_id": meet.id,
        "order_id": meet.ordId,
        "datetime": datetime,
        "comment": comment,
        "order_status": meet.orderStatus,
        'token': token,
      });
      final responseData = jsonDecode(response.body);
      if (responseData['success'] == true) {
        _rescheduleMeetingMessage = responseData['message'];

        meet.isLoading = false;
        notifyListeners();
        return true;
      } else {
        _rescheduleMeetingMessage = responseData['message'];
        meet.isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      meet.isLoading = false;
      notifyListeners();
      // const errorMsg = 'Could not reschedule Meeting!';
      // CommonFunctions.showErrorToast(errorMsg);
      // CommonFunctions.showErrorDialog(errorMsg, context);
      return false;
    }
  }

  Future<bool> changeMeetingState(Upcoming meet, double lat, double long,
      String area, String action) async {
    var url = AppConstants.baseUrl + AppConstants.changeMeetingStatus;
    String? token = await SharedPreferenceHelper().getAuthToken();
    String? userid = await SharedPreferenceHelper().getUserId();
    meet.isChangeMeetingStateLoading = true;
    notifyListeners();

    Map data = {
      'api_key': AppConstants.apikey,
      "meeting_id": meet.id,
      "user_id": userid,
      "action": action,
      "latitude": action == 'Done' ? '' : lat.toString(),
      "longitude": action == 'Done' ? '' : long.toString(),
      'token': token,
      "area": action == 'Done' ? '' : area,
      "ord_id": meet.ordId,
    };
    log('data provided to api is : $data');
    try {
      final response = await http.post(Uri.parse(url), body: {
        'api_key': AppConstants.apikey,
        "meeting_id": meet.id,
        "user_id": userid,
        "action": action,
        "latitude": action == 'Completed' ? '' : lat.toString(),
        "longitude": action == 'Completed' ? '' : long.toString(),
        'token': token,
        "area": action == 'Completed' ? '' : area,
        "ord_id": meet.ordId,
      });
      final responseData = jsonDecode(response.body);
      log('response data : ${responseData.toString()}');
      if (responseData['success'] == true) {
        _rescheduleMeetingMessage = responseData['message'];

        meet.isChangeMeetingStateLoading = false;
        meet.isReachedDone = true;
        notifyListeners();
        return true;
      } else {
        _rescheduleMeetingMessage = responseData['message'];
        meet.isChangeMeetingStateLoading = false;
        notifyListeners();
        return false;
      }
      // meet.isChangeMeetingStateLoading = false;
      // notifyListeners();
      // return false;
    } catch (e) {
      meet.isChangeMeetingStateLoading = false;
      notifyListeners();
      // const errorMsg = 'Could not change Meeting!';
      log('error is : $e');
      CommonFunctions.showErrorToast(e.toString());
      return false;
    }
  }
}
