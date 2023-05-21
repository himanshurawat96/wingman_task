import 'dart:async';
import 'dart:io';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wingman_task/data/model/OTPResponse.dart';
import 'package:wingman_task/data/model/api_response.dart';
import 'package:wingman_task/data/repository/auth_repository.dart';
import 'package:wingman_task/utils/message_handler.dart';

import 'bloc.dart';
import 'package:permission_handler/permission_handler.dart';

class AuthBloc extends Bloc {

  final AuthRepository _repo;
  AuthBloc(this._repo);

  StreamController<String> authController = StreamController.broadcast();

  ValueNotifier<bool> loginLoading = ValueNotifier(false);
  ValueNotifier<CountryCode> dialCode = ValueNotifier(const CountryCode(name: 'India', code: 'IN', dialCode: '+91'));
  final TextEditingController phone = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController name = TextEditingController();

  final GlobalKey builderKey = GlobalKey();
  final GlobalKey<FormState> loginForm = GlobalKey<FormState>();

  Timer? timer;
  int start = 1 * 60;

  void startTimer() {
    if(timer!=null) {
      timer?.cancel();
    }
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (start == 0) {
          builderKey.currentState?.setState(() {
            timer.cancel();
          });
        } else {
          builderKey.currentState?.setState(() {
            start--;
          });
        }
      },
    );
  }

  //#region Region - SEND OTP

  final ValueNotifier<bool> showOTPScreen = ValueNotifier(false);
  final ValueNotifier<bool> otpVerifying = ValueNotifier(false);
  String? _requestId;

  final countryPicker = const FlCountryCodePicker(
    // filteredCountries: ['IN', "US"],
    favorites: ['IN'],
    favoritesIcon: Icon(PhosphorIcons.push_pin_bold),
  );
  updateDialCode(CountryCode code) {
    dialCode.value = code;
  }

  Future sendOTP() async {
    try{
      if(loginLoading.value) {
        return;
      }
      loginLoading.value = true;
      _requestId = null;
      var res = await _repo.sendOTP(phone.text);
      if(res.status) {
        _requestId = res.data;
        startTimer();
        showOTPScreen.value = true;
        authController.sink.add("OTP_SENT");
      } else {
        showMessage(MessageType.error(res.response));
      }
    } catch(e,s) {
      debugPrint('$e');
      debugPrintStack(stackTrace: s);
      showMessage(MessageType.error("$e"));
    } finally {
      loginLoading.value = false;
    }
  }

  ValueNotifier<bool> verifyingOTP = ValueNotifier(false);
  otpVerification(String otp) async {

    if(otp.isEmpty) {
      showMessage(const MessageType.error('Please enter otp first!'));
      return;
    }
    if(_requestId==null) {
      showMessage(const MessageType.error('Sorry, we could not find your request id!'));
      return;
    }
    if(verifyingOTP.value) {
      return;
    }
    verifyingOTP.value = true;
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      OtpResponse res = await _repo.verifyOTP(_requestId!, otp);
      if(res.status ?? false) {
        pref.setString('token', res.jwt ?? "");
        if(res.profileExists ?? false) {
          authController.sink.add("AUTH_SUCCESS");
        } else {
          authController.sink.add("NEW_USER");
        }
      } else {
        showMessage(MessageType.error(res.response ?? "Invalid OTP!"));
      }
    } catch(e,s) {
      debugPrint('$e');
      debugPrintStack(stackTrace: s);
      showMessage(MessageType.error("$e"));
    }
    verifyingOTP.value = false;
  }

  //#endregion

  //#region - Register
  GlobalKey<FormState> registerForm = GlobalKey<FormState>();
  ValueNotifier<bool> registering = ValueNotifier(false);
  registerUser() async {
    if(!registerForm.currentState!.validate()) {
      return;
    }
    if(registering.value) {
      return;
    }
    registering.value = true;
    try {
      ApiResponse res = await _repo.register(name.text, email.text);
      if(res.status) {
        authController.sink.add("AUTH_SUCCESS");
      } else {
        showMessage(MessageType.error(res.response));
      }
    } catch(e,s) {
      debugPrint('$e');
      debugPrintStack(stackTrace: s);
      showMessage(MessageType.error("$e"));
    }
    registering.value = false;
  }

  _saveUserDetails() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('email', email.text);
    pref.setString('name', name.text);
  }

  //#endregion

}