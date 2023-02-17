import 'package:carpooling_passenger/data/datasources/network/booking/booking_remote_data_source.dart';
import 'package:carpooling_passenger/data/respositories/booking/booking_repository_impl.dart';
import 'package:carpooling_passenger/domain/usescases/booking/booking_use_case.dart';
import 'package:carpooling_passenger/presentation/pages/routes/controller/detail_route.controller.dart';
import 'package:get/get.dart';

import '../../../../data/datasources/network/routes/routes_remote_data_source.dart';
import '../../../../data/datasources/network/web_service.dart';
import '../../../../data/respositories/routes/routes_repository_impl.dart';
import '../../../../domain/usescases/routes/routes_use_case.dart';

class DetailRouteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RoutesUseCase(
        RoutesRepositoryImpl(RoutesRemoteDataSourceImpl(WebService()))));
    Get.lazyPut(() => BookingUseCase(
        BookingRepositoryImpl(BookingRemoteDataSourceImpl(WebService()))));
    Get.put(DetailRouteController(Get.find(), Get.find()), permanent: false);
  }
}
