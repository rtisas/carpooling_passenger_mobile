import 'package:carpooling_passenger/core/application/enviroment.dart';
import 'package:dio/dio.dart';
import 'package:get/route_manager.dart';

import '../../../core/application/preferences.dart';
import '../../../presentation/pages/auth/login.page.dart';

class WebService {
  static final WebService _webService = WebService._internal();
  final Dio _dio = Dio();
  factory WebService() {
    return _webService;
  }

  WebService._internal();
  //TODO: BORRAR LA SESIÓN CUANDO SE EXPIRE EL TOKEN 401

  Future<Dio> httpClient() async {
    _dio.options.baseUrl = Enviroment.BASE_URL_QA;
    _dio.options.headers.addAll({"content-type": "application/json"});
    _dio.options.headers.addAll({"Accept": "application/json"});
    // _dio.options.responseType.
    final token = await Preferences.storage.read(key: 'token');

    if (token != null) {
      _dio.interceptors.add(InterceptorsWrapper(
        onResponse: ((Response response, ResponseInterceptorHandler handler) async {
          int statusCode = response.statusCode ?? 0;
          if(statusCode == 401 || statusCode == 0){
                await Preferences.storage.deleteAll();
                Get.offAll(() => const LoginPage());
          }
          return handler.next(response);
        }),
        onRequest: (options, handler) {
        options.headers['Authorization'] = token;
        return handler.next(options);
      }, onError: (error, handler) {
        return handler.reject(error);
      }));
    }
    return _dio;
  }
}
