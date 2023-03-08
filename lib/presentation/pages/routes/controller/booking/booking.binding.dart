import 'package:carpooling_passenger/data/datasources/network/booking/booking_remote_data_source.dart';
import 'package:carpooling_passenger/data/datasources/network/web_service.dart';
import 'package:carpooling_passenger/data/respositories/booking/booking_repository_impl.dart';
import 'package:carpooling_passenger/domain/usescases/booking/booking_use_case.dart';
import 'package:get/get.dart';

import 'booking.controller.dart';

class BookingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BookingUseCase(
        BookingRepositoryImpl(BookingRemoteDataSourceImpl(WebService()))));
    Get.put(BookingController(Get.find()));
  }
}
