import 'package:carpooling_passenger/data/respositories/auth/auth_repository_impl.dart';
import 'package:get/get.dart';
import '../../../../data/datasources/network/auth/auth_remote_data_source.dart';
import '../../../../data/datasources/network/web_service.dart';
import '../../../../domain/usescases/auth/login_use_case.dart';
import 'auth.controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginUseCase(AuthRepositoryImpl(AuthRemoteDataSourceImpl(WebService()))));
    Get.put(AuthController(Get.find()), permanent: true);
  }
}