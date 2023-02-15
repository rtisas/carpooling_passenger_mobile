
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
    Get.put(HomeController(Get.find()), permanent: true);
  }

}