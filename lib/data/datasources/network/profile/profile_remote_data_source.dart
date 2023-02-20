import 'dart:io';
import 'package:dio/dio.dart';

import 'package:carpooling_passenger/data/datasources/network/web_service.dart';
import 'package:carpooling_passenger/data/models/file_carpooling/upload_file_response.dart';

import '../../../../core/errors/exeptions.dart';

abstract class ProfileRemoteDataSource {

  //Obtener todos las estaciones por la ruta

  Future<UploadFileResponse> uploadPictureUserPasseger(String pathFilePicture);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource{

  final WebService webService;

  ProfileRemoteDataSourceImpl(this.webService);

  @override
  Future<UploadFileResponse> uploadPictureUserPasseger(String pathFilePicture) async {
    try {
      final http = await webService.httpClient();
       FormData formData = FormData.fromMap({'file': await MultipartFile.fromFile('ruta/al/archivo'),
      });
      final response = await http.post('facade/post-s3/file', data: formData);

      if (response.statusCode == 200) {
        UploadFileResponse uploadFileResponse = UploadFileResponse.fromJson(response.data);
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
}