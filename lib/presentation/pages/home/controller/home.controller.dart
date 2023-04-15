import 'dart:convert';

import 'package:carpooling_passenger/data/models/passenger/passenger_response.dart';
import 'package:carpooling_passenger/data/models/user/push_token_request.dart';
import 'package:carpooling_passenger/domain/usescases/profile/profile_use_case.dart';
import 'package:carpooling_passenger/push_notifications_service.dart';
import 'package:get/get.dart';

import '../../../../core/application/preferences.dart';
import '../../../../data/models/routes/route_response.dart';
import '../../../../domain/usescases/routes/routes_use_case.dart';

class HomeController extends GetxController {
  final RoutesUseCase routesUseCase;
  final ProfileUseCase _profileController;

  RxBool isLoading = false.obs;
  RxInt tabIndex = 1.obs;
  Rx<PassengerResoponse?> user = Rx(null);
  Rx<List<RouteResponse>> listRoutes = Rx([]);

  HomeController(this.routesUseCase, this._profileController);

  @override
  void onInit() async {
    await PushNotificationsService.requestPermission();
    await getUser();
    await getRoutesAvailable();
    super.onInit();
  }

  getUser() async {
    //Obteniendo el usuario de las preferenecias del usuario
    user.value = PassengerResoponse.fromJson(
        jsonDecode(await Preferences.storage.read(key: 'userPassenger') ?? ''));

    await _profileController
        .updatePassengerPushToken(
            user.value?.basicData.id.toString() ?? '0',
            PushTokenRequest(
                pushtoken: PushNotificationsService.token ?? 'TOKEN_NO_VALIDO'))
        .then((value) => value.fold((failure) {
              print('LOG ocurrió un error ${failure.message}');
            }, (response) {
              print('LOG se actualizo el token ${1}');
            }));
  }

  getRoutesAvailable() async {
    isLoading.value = true;
    return await routesUseCase.routesRepository
        .listRoutesByCompanyResponsible(
            user.value?.transportCompany.id.toString() ?? '0')
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
