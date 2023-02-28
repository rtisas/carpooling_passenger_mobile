import 'dart:convert';

import 'package:carpooling_passenger/core/errors/exeptions.dart';
import 'package:carpooling_passenger/data/models/passenger/passenger_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../../core/application/preferences.dart';
import '../../../../core/errors/failure.dart';
import '../../../../data/models/auth/login_request.dart';
import '../../../../domain/usescases/auth/login_use_case.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthController extends GetxController {
  final LoginUseCase _loginUseCase;

  RxBool loadingAuth = false.obs;
  RxBool successLogin = false.obs;
  Rx<LoginRequest> userLogin = Rx(LoginRequest(email: '', password: ''));
  RxBool isViewPassword = false.obs;
  GlobalKey<FormState> form = GlobalKey<FormState>();
  Rx<FailureResponse?> error = Rx(null);
  PassengerResoponse? passenger;
  AuthController(this._loginUseCase);

  Future<bool> validForm() async {
    if (form.currentState!.validate()) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> login() async {
    loadingAuth.value = true;
    final failureOrLogin = await _loginUseCase.loginUseCase(userLogin.value);
    return failureOrLogin.fold((failure) async {
      loadingAuth.value = false;
      successLogin.value = false;
      error.value = failure as FailureResponse?;

      if (failure.exception is NeedChangePassword) {
        if (!await launchUrl(
          Uri.parse('https://carpooling.solas.com.co/auth/login'),
          mode: LaunchMode.externalApplication,
        )) {
          throw Exception(
              'Could not launch https://carpooling.solas.com.co/auth/login');
        }
      }
      return successLogin.value;
    }, (loginResponse) async {
      passenger = PassengerResoponse.fromJson(jsonDecode(
          await Preferences.storage.read(key: 'userPassenger') ?? ''));
      successLogin.value = true;
      loadingAuth.value = false;
      return successLogin.value;
    });
  }
}
