
import 'package:carpooling_passenger/data/datasources/network/profile/profile_remote_data_source.dart';
import 'package:carpooling_passenger/data/respositories/profile/profile_repository_impl.dart';
import 'package:carpooling_passenger/domain/usescases/profile/profile_use_case.dart';
import 'package:get/get.dart';

import '../../../../data/datasources/network/routes/routes_remote_data_source.dart';
import '../../../../data/datasources/network/web_service.dart';
import '../../../../data/respositories/routes/routes_repository_impl.dart';
import '../../../../domain/usescases/routes/routes_use_case.dart';
import 'home.controller.dart';

class HomeBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => RoutesUseCase(RoutesRepositoryImpl(RoutesRemoteDataSourceImpl(WebService()))));
    Get.lazyPut(() => ProfileUseCase(ProfileRepositoryImpl(ProfileRemoteDataSourceImpl(WebService()))));
    Get.put(HomeController(Get.find(), Get.find()));
  }
}