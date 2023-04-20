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
  Future<Dio> httpClient() async {
    _dio.options.baseUrl = Enviroment.BASE_URL_QA;
    _dio.options.headers.addAll({"content-type": "application/json"});
    _dio.options.headers.addAll({"Accept": "application/json"});
    final token = await Preferences.storage.read(key: 'token');

    if (token != null) {
      _dio.interceptors.add(InterceptorsWrapper(
        onResponse: ((Response response, ResponseInterceptorHandler handler) async {
          int statusCode = response.statusCode ?? 0;
          print('LOG valor del statusCode ${ statusCode }');
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
  Future<Dio> httpClientFromFile() async {
    _dio.options.baseUrl = Enviroment.BASE_URL_QA;
    _dio.options.headers.addAll({"Content-type": "*/*"});
    _dio.options.headers.addAll({"Accept": "*/*"});
    final token = await Preferences.storage.read(key: 'token');

    if (token != null) {
      _dio.interceptors.add(InterceptorsWrapper(
        onResponse: ((Response response, ResponseInterceptorHandler handler) async {
          int statusCode = response.statusCode ?? 0;
          print('LOG valor del statusCode ${ statusCode }');
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
