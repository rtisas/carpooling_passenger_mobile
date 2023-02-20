import 'package:carpooling_passenger/data/models/file_carpooling/upload_file_response.dart';
import 'package:carpooling_passenger/core/errors/failure.dart';
import 'package:carpooling_passenger/domain/repositories/profile/profile_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../core/errors/exeptions.dart';
import '../../datasources/network/profile/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepositoy {
  final ProfileRemoteDataSource profileRemoteDataSource;

  ProfileRepositoryImpl(this.profileRemoteDataSource);

  @override
  Future<Either<Failure, UploadFileResponse>> uploadPictureProfile(
      String pathFilePicture) async {
    try {
      final uploadProfileResponse = await profileRemoteDataSource.uploadPictureUserPasseger(pathFilePicture);
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
}
