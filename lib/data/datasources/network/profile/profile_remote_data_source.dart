import 'dart:convert';
import 'package:carpooling_passenger/data/models/passenger/passenger_response.dart';
import 'package:dio/dio.dart';

import 'package:carpooling_passenger/data/datasources/network/web_service.dart';
import 'package:carpooling_passenger/data/models/file_carpooling/upload_file_response.dart';

import '../../../../core/application/preferences.dart';
import '../../../../core/errors/exeptions.dart';
import '../../../models/passenger/passenger_update_request.dart';

abstract class ProfileRemoteDataSource {
  Future<UploadFileResponse> uploadPictureUserPasseger(
      String pathFilePicture, String idUser);
  Future<PassengerResoponse> updatePassenger(
      String idPassanger, UpdatePassager updatePassager);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final WebService webService;

  ProfileRemoteDataSourceImpl(this.webService);

  @override
  Future<UploadFileResponse> uploadPictureUserPasseger(
      String pathFilePicture, String idUser) async {
    try {
      final http = await webService.httpClient();
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(pathFilePicture),
        'user': idUser
      });
      final response = await http.post('facade/post-s3/file', data: formData);

      if (response.statusCode == 200) {
        UploadFileResponse uploadFileResponse =
            UploadFileResponse.fromJson(response.data);
        await getPassengerByUser(idUser);
        return uploadFileResponse;
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
    }
  }

  @override
  Future<PassengerResoponse> updatePassenger(
      String idPassanger, UpdatePassager updatePassager) async {
    try {
      final http = await webService.httpClient();
      final response = await http.put('facade/put-passenger/$idPassanger',
          data: updatePassager);
      if (response.statusCode == 200) {
        PassengerResoponse passenger = await getPassengerByUser(response.data["basicData"]["id"].toString()); // actualizar el usuario de las preferencias de la aplicación
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
    }
  }

  Future<PassengerResoponse> getPassengerByUser(String idUser) async {
    try {
      final http = await webService.httpClient();
      final response = await http.get('facade/get-passenger/user/$idUser');
      if (response.statusCode == 200) {
        final passenger = PassengerResoponse.fromJson(response.data);
        await Preferences.storage
            .write(key: 'userPassenger', value: jsonEncode(passenger.toJson()));

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
    }
  }
}
