import 'package:carpooling_passenger/data/models/file_carpooling/upload_file_response.dart';
import 'package:carpooling_passenger/domain/repositories/profile/profile_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../core/errors/failure.dart';

class ProfileUseCase{
  final ProfileRepositoy profileRepositoy;

  ProfileUseCase(this.profileRepositoy);

  Future<Either<Failure, UploadFileResponse>> uploadFilePictureUser(String pathFilePicture) {
    return profileRepositoy.uploadPictureProfile(pathFilePicture);
  }
}