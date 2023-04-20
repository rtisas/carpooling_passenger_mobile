import 'dart:io';

import 'package:carpooling_passenger/data/models/file_carpooling/upload_file_response.dart';
import 'package:carpooling_passenger/core/errors/failure.dart';
import 'package:carpooling_passenger/data/models/passenger/passenger_update_request.dart';
import 'package:carpooling_passenger/data/models/passenger/passenger_response.dart';
import 'package:carpooling_passenger/data/models/user/push_token_request.dart';
import 'package:carpooling_passenger/domain/repositories/profile/profile_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../core/errors/exeptions.dart';
import '../../datasources/network/profile/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepositoy {
  final ProfileRemoteDataSource profileRemoteDataSource;

  ProfileRepositoryImpl(this.profileRemoteDataSource);

  @override
  Future<Either<Failure, UploadFileResponse>> uploadPictureProfile(
      String pathFilePicture, String idUser) async {
    try {
      final uploadProfileResponse = await profileRemoteDataSource
          .uploadPictureUserPasseger(pathFilePicture, idUser);
      return Right(uploadProfileResponse);
    } on DataIncorrect {
      return Left(FailureResponse(
          message: 'Algo salió mal, por favor verifique los datos'));
    } on NoValidRole {
      return Left(FailureResponse(message: 'No eres un usuario válido'));
    } on NoNetwork {
      return Left(
          FailureResponse(message: 'Ocurrió un error, No hay conexión'));
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

  @override
  Future<Either<Failure, PassengerResoponse>> updatePassenger(
      String idPassenger, UpdatePassager updatePassager) async {
    try {
      final passengerResponse = await profileRemoteDataSource.updatePassenger(
          idPassenger, updatePassager);
      return Right(passengerResponse);
    } on DataIncorrect {
      return Left(FailureResponse(message: 'Usuario no es válido'));
    } on NeedChangePassword {
      return Left(
          FailureResponse(message: 'Usuario debe cambiar la constraseña', exception: NeedChangePassword()));
    } on NoValidRole {
      return Left(FailureResponse(message: 'No eres un usuario válido'));
    } on NoNetwork {
      return Left(
          FailureResponse(message: 'Ocurrió un error, No hay conexión'));
    } on NoFound {
      return Left(FailureResponse(
          message:
              'Ocurrió un error por parte de nosotros, por favor intente más tarde'));
    } on ServerException {
      return Left(FailureResponse(
          message: 'Ocurrió un error, comuníquese con administración'));
    }
  }

  @override
  Future<Either<Failure, void>> updatePushTokenPassenger(String idUser, PushTokenRequest pushTokenRequest) async {
    try {
      final pushTokenResponse = await profileRemoteDataSource.updatePushTokenPassenger(idUser, pushTokenRequest);
      return Right(pushTokenResponse);
    } on DataIncorrect {
      return Left(FailureResponse(message: 'Usuario no es válido'));
    } on NeedChangePassword {
      return Left(
          FailureResponse(message: 'Usuario debe cambiar la constraseña', exception: NeedChangePassword()));
    } on NoValidRole {
      return Left(FailureResponse(message: 'No eres un usuario válido'));
    } on NoNetwork {
      return Left(
          FailureResponse(message: 'Ocurrió un error, No hay conexión'));
    } on NoFound {
      return Left(FailureResponse(
          message:
              'Ocurrió un error por parte de nosotros, por favor intente más tarde'));
    } on ServerException {
      return Left(FailureResponse(
          message: 'Ocurrió un error, comuníquese con administración'));
    }
  }
  
  @override
  Future<Either<Failure, File?>> downloadDocumentPassenger(String idPassenger) async {
    try {
      final responseDownload = await profileRemoteDataSource.downloadDocumentPassenger(idPassenger);
      return Right(responseDownload);
    } on DataIncorrect {
      return Left(FailureResponse(message: 'No se pudo descargar el documento'));
    } on NoNetwork {
      return Left(
          FailureResponse(message: 'Ocurrió un error, No hay conexión'));
    } on NoFound {
      return Left(FailureResponse( message:'No se encontro un documento asociado'));
    } on ServerException {
      return Left(FailureResponse( message: 'Ocurrió un error, comuníquese con administración'));
    }
  }
}
