import 'dart:convert';

import 'package:carpooling_passenger/domain/usescases/profile/profile_use_case.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/application/preferences.dart';
import '../../../../data/models/helpers/only_id.dart';
import '../../../../data/models/passenger/passenger_response.dart';
import '../../../../data/models/passenger/passenger_update_request.dart';

class FrecuentDataController extends GetxController {
  final ProfileUseCase _profileUseCase;

  Map<String, String> frecuentDataPasseger = {};

  FrecuentDataController(this._profileUseCase);

  Future updatePassager() async {
    showLoading();
    PassengerResoponse? passenger = PassengerResoponse.fromJson(
      jsonDecode(await Preferences.storage.read(key: 'userPassenger') ?? ''),
    );
    UpdatePassager updatePassager = UpdatePassager(
        frDestinyLatitude: frecuentDataPasseger["frDestinyLatitude"] ??
            passenger.frDestinyLatitude,
        frDestinyLongitude: frecuentDataPasseger["frDestinyLongitude"] ??
            passenger.frDestinyLongitude,
        frOriginLatitude: frecuentDataPasseger["frOriginLatitude"] ??
            passenger.frOriginLatitude,
        frOriginLongitude: frecuentDataPasseger["frOriginLongitude"] ??
            passenger.frOriginLongitude,
        frOriginHour:
            frecuentDataPasseger["frOriginHour"] ?? passenger.frOriginHour,
        pushToken: passenger.pushToken,
        identification: passenger.basicData.identification,
        firstName: passenger.basicData.firstName,
        lastName: passenger.basicData.lastName,
        phoneNumber: passenger.basicData.phoneNumber,
        email: passenger.basicData.email,
        status: OnlyId(id: passenger.basicData.status.id),
        roleId: OnlyId(id: passenger.basicData.roleId.id),
        updater: OnlyId(id: passenger.basicData.id),
        updateDate: DateTime.now(),
        contractingCompany: OnlyId(id: passenger.contractingCompany.id),
        transportCompany: OnlyId(id: passenger.transportCompany.id),
        identificationType:
            OnlyId(id: passenger.basicData.identificationType.id));

            print('LOG valor ${ updatePassager }');

    _profileUseCase
        .updatePassenger(passenger.id.toString(), updatePassager)
        .then((value) => value.fold((errorResponse) async {
              closeDialogLoading();
              showMessage('¡Algo salió mal!', 'Intenta más tarde');
              Get.offNamed('/home');
              print('LOG Ocurrió un error ${errorResponse.message}');
            }, (responseUpdate) async {

              closeDialogLoading();
              showMessage('¡Todo salió bien!', 'Muchas gracias por completar tu perfil');
              Get.offNamed('/home');
            }));
  }

  void showLoading() {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void showMessage(String title, String content) {
    Get.closeAllSnackbars();
    Get.snackbar(
      title,
      content,
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      colorText: Color.fromARGB(255, 0, 0, 0),
      snackPosition: SnackPosition.TOP,
    );
  }

  void closeDialogLoading() {
    Get.back();
  }
}
