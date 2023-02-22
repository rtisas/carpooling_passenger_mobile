
import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../core/application/preferences.dart';
import '../../../../core/errors/exeptions.dart';
import '../../../models/auth/login_request.dart';
import '../../../models/auth/login_response.dart';
import '../../../models/helpers/roles.dart';
import '../../../models/passenger/passenger_response.dart';
import '../web_service.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponse> login(LoginRequest userLogin);
}


class AuthRemoteDataSourceImpl implements AuthRemoteDataSource{
  
  final WebService webService;
  AuthRemoteDataSourceImpl(this.webService);

  @override
  Future<LoginResponse> login(LoginRequest userLogin) async {
    try {
      final http = await webService.httpClient();
      final response = await http.post('facade/login', data: userLogin);
      if (response.statusCode == 200) {
        final loginResonse = LoginResponse.fromJson(response.data);
        if (loginResonse.user.roleId.id != ROL.passenger.value) {
          throw NoValidRole();
        }
        await Preferences.storage.write(key: 'token', value: loginResonse.token);
        await getPassengerByUser(loginResonse.user.id);
        return loginResonse;
      } else {
        throw ServerException();
      }
    } on DioError catch (e) {
      switch (e.response?.statusCode) {
        case 400:
          throw DataIncorrect();
        case 404:
          throw NoFound();
        default:
          throw NoNetwork();
      //TODO: VALIDAR QUE EL USUARIO CON ESTADO CREADO PUEDA INGRESAR NORMAL MIENTRAS QUE EL USUARIO CON ESTADO CAMBIO DE CONTRASEÑA TENGA QUE CAMBIAR LA CONTRASEÑAW

      }
      //TODO: BORRAR LA SESIÓN CUANDO SE EXPIRE EL TOKEN 401
    }
  }

  Future<PassengerResoponse> getPassengerByUser(int idUser) async {
    try {
      final http = await webService.httpClient();
      final response = await http.get('facade/get-passenger/user/${idUser}');
      if (response.statusCode == 200) {
        final passenger = PassengerResoponse.fromJson(response.data);
        await Preferences.storage.write(key: 'userPassenger', value: jsonEncode(passenger.toJson()));

        return passenger;
      } else {
        throw ServerException();
      }
    } on DioError catch (e) {
      switch (e.response?.statusCode) {
        case 400:
          throw DataIncorrect();
        case 404:
          throw NoFound();
        default:
          throw NoNetwork();
      }
      //TODO: BORRAR LA SESIÓN CUANDO SE EXPIRE EL TOKEN 401
    }
  }

}