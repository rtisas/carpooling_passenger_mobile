import 'package:dartz/dartz.dart';

import '../../../core/errors/failure.dart';
import '../../../data/models/file_carpooling/upload_file_response.dart';

abstract class ProfileRepositoy{
  Future<Either<Failure, UploadFileResponse>> uploadPictureProfile(String pathFilePicture);
}