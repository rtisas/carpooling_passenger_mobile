import 'package:carpooling_passenger/data/models/file_carpooling/upload_file_response.dart';
import 'package:carpooling_passenger/data/models/passenger/passenger_response.dart';
import 'package:carpooling_passenger/domain/repositories/profile/profile_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../core/errors/failure.dart';
import '../../../data/models/passenger/passenger_update_request.dart';

class ProfileUseCase {
  final ProfileRepositoy profileRepositoy;

  ProfileUseCase(this.profileRepositoy);

  Future<Either<Failure, UploadFileResponse>> uploadFilePictureUser(
      String pathFilePicture, String idUser) {
    return profileRepositoy.uploadPictureProfile(pathFilePicture, idUser);
  }

  Future<Either<Failure, PassengerResoponse>> updatePassenger(
      String idPassenger, UpdatePassager passager) {
    return profileRepositoy.updatePassenger(idPassenger, passager);
  }
}
