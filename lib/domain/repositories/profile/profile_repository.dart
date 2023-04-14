import 'package:carpooling_passenger/data/models/passenger/passenger_response.dart';
import 'package:carpooling_passenger/data/models/passenger/passenger_update_request.dart';
import 'package:carpooling_passenger/data/models/user/push_token_request.dart';
import 'package:dartz/dartz.dart';

import '../../../core/errors/failure.dart';
import '../../../data/models/file_carpooling/upload_file_response.dart';

abstract class ProfileRepositoy{
  Future<Either<Failure, UploadFileResponse>> uploadPictureProfile(String pathFilePicture, String idUser);
  Future<Either<Failure, PassengerResoponse>> updatePassenger(String idPassenger, UpdatePassager updatePassager);
  Future<Either<Failure, void>> updatePushTokenPassenger(String idUser, PushTokenRequest pushTokenRequest);
}