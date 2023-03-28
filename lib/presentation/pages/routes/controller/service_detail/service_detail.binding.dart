import 'package:carpooling_passenger/data/datasources/network/routes/routes_remote_data_source.dart';
import 'package:carpooling_passenger/data/datasources/network/web_service.dart';
import 'package:carpooling_passenger/data/respositories/routes/routes_repository_impl.dart';
import 'package:carpooling_passenger/domain/usescases/routes/routes_use_case.dart';
import 'package:get/get.dart';
import 'service_detail.controller.dart';

class ServiceDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ServiceDetailController(RoutesUseCase(
        RoutesRepositoryImpl(RoutesRemoteDataSourceImpl(WebService())))));
  }
}
