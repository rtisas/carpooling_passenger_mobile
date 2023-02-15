import 'package:get/get.dart';

import 'package:carpooling_passenger/data/datasources/network/routes/routes_remote_data_source.dart';
import 'package:carpooling_passenger/data/datasources/network/web_service.dart';
import 'package:carpooling_passenger/data/respositories/routes/routes_repository_impl.dart';
import 'package:carpooling_passenger/domain/usescases/routes/routes_use_case.dart';
import 'package:carpooling_passenger/presentation/pages/routes/controller/routes.controller.dart';


class RoutesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RoutesUseCase(
        RoutesRepositoryImpl(RoutesRemoteDataSourceImpl(WebService()))));
    Get.put(RoutesController(Get.find()), permanent: false);
  }
}