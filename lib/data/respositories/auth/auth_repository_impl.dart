import 'package:dartz/dartz.dart';
import 'package:carpooling_passenger/data/models/auth/login_response.dart';
import 'package:carpooling_passenger/data/models/auth/login_request.dart';
import 'package:carpooling_passenger/core/errors/failure.dart';
import '../../../core/errors/exeptions.dart';
import '../../../domain/repositories/auth/auth_respository.dart';
import '../../datasources/network/auth/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  
  final AuthRemoteDataSource _authRemoteDataSource;
  AuthRepositoryImpl(this._authRemoteDataSource);

  @override
  Future<Either<Failure, LoginResponse>> login(LoginRequest userLogin) async {
    try {
      final loginResponse = await _authRemoteDataSource.login(userLogin);
      return Right(loginResponse);
    } on DataIncorrect {
      return Left(FailureResponse(message: 'Usuario no es válido', exception: DataIncorrect()));
    } on NoValidRole {
      return Left(FailureResponse(message: 'No eres un usuario válido', exception: NoValidRole()));
    }on NeedChangePassword {
      return Left(
          FailureResponse(message: 'Necesita cambiar contraseña', exception: NeedChangePassword()));
    }on NoNetwork {
      return Left(
          FailureResponse(message: 'Ocurrió un error, No hay conexión', exception: NoNetwork())); 
    } on NoFound {
      return Left(FailureResponse(
          message:
              'Ocurrió un error por parte de nosotros, por favor intente más tarde'));
    } on ServerException {
      return Left(FailureResponse(
          message:
              'Su rol no tiene permiso de ingresar, comuníquese con administración'));
    }
  }
}
