
import 'dart:convert';

import 'package:carpooling_passenger/data/models/passenger/passenger_response.dart';
import 'package:get/get.dart';

import '../../../../core/application/preferences.dart';
import '../../../../data/models/routes/route_response.dart';
import '../../../../domain/usescases/routes/routes_use_case.dart';

class HomeController extends GetxController {
  final RoutesUseCase routesUseCase;

  RxBool isLoading = false.obs;
  RxInt tabIndex = 1.obs;
  Rx<PassengerResoponse?> user = Rx(null);
  Rx<List<RouteResponse>> listRoutes = Rx([]);

  HomeController(this.routesUseCase);

  @override
  void onInit() async {
    await getUser();
    await getRoutesAvailable();
    super.onInit();
  }

  Future<PassengerResoponse?> getUser() async {
    //Obteniendo el usuario de las preferenecias del usuario
    user.value = PassengerResoponse.fromJson(
        jsonDecode(await Preferences.storage.read(key: 'userPassenger') ?? ''));
  }

  getRoutesAvailable() async {
    isLoading.value = true;
    return await routesUseCase.routesRepository
        .listRoutesByCompanyResponsible(
            this.user.value?.transportCompany.id.toString() ?? '0')
        .then((value) => value.fold((failure) {
              isLoading.value = false;
              return null;
            }, (responseListRoutes) {
              isLoading.value = false;
              listRoutes.value = responseListRoutes;
              return listRoutes;
            }));
  }
}