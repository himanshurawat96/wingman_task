import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:wingman_task/data/model/OTPResponse.dart';
import 'package:wingman_task/data/model/Product.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wingman_task/data/model/api_response.dart';

import '../network/api_service.dart';

class AuthRepository {
  final SharedPreferences prefs;
  final ApiService _api;

  AuthRepository(this.prefs, this._api);


  Future<ApiResponse<String>> sendOTP(String phoneNum) async {
    Map<String, dynamic> data = {
      'mobile': phoneNum,
    };

    var res = await _api.postRequest('sendotp.php', data, cacheRequest: false, forceRefresh: true);
    if(res==null) {
      throw "NO DATA FOUND!";
    }
    var response = jsonDecode(res);
    return ApiResponse.fromJson(response, response['request_id']);
  }

  Future<OtpResponse> verifyOTP(String requestID, String otp) async {
    Map<String, dynamic> data = {
      'request_id': requestID,
      'code': otp,
    };

    var res = await _api.postRequest('verifyotp.php', data, cacheRequest: false, forceRefresh: true);
    if(res==null) {
      throw "NO DATA FOUND!";
    }
    var response = jsonDecode(res);
    return OtpResponse.fromJson(response);
  }

  Future<ApiResponse> register(String name, String email) async {
    Map<String, dynamic> data = {
      'name': name,
      'email': email,
    };

    var res = await _api.postRequest('profilesubmit.php', data, requireToken: true,
        cacheRequest: false, forceRefresh: true);
    return ApiResponse.fromJson(jsonDecode(res));
  }

}