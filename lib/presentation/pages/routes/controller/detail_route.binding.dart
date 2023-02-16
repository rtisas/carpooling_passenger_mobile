
import 'package:carpooling_passenger/presentation/pages/routes/controller/detail_route.controller.dart';
import 'package:get/get.dart';

class DetailRouteBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DetailRouteController());
  }
}