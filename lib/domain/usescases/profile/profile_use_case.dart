import 'dart:io';

import 'package:carpooling_passenger/data/models/file_carpooling/upload_file_response.dart';
import 'package:carpooling_passenger/data/models/passenger/passenger_response.dart';
import 'package:carpooling_passenger/data/models/user/push_token_request.dart';
import 'package:carpooling_passenger/domain/repositories/profile/profile_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../core/errors/failure.dart';
import '../../../data/models/passenger/passenger_update_request.dart';

class ProfileUseCase {
  final ProfileRepositoy profileRepository;

  ProfileUseCase(this.profileRepository);

  Future<Either<Failure, UploadFileResponse>> uploadFilePictureUser(
      String pathFilePicture, String idUser) {
    return profileRepository.uploadPictureProfile(pathFilePicture, idUser);
  }

  Future<Either<Failure, PassengerResoponse>> updatePassenger(
      String idPassenger, UpdatePassager passager) {
    return profileRepository.updatePassenger(idPassenger, passager);
  }

  Future<Either<Failure, void>> updatePassengerPushToken(
      String idUser, PushTokenRequest pushTokenRequest) {
    return profileRepository.updatePushTokenPassenger(idUser, pushTokenRequest);
  }

  Future<Either<Failure, File?>> downloadDocumentPassenger(String idPassenger) {
    return profileRepository.downloadDocumentPassenger(idPassenger);
  }
}
