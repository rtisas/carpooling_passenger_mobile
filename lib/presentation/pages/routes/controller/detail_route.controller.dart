import 'dart:convert';

import 'package:carpooling_passenger/data/models/booking/booking_request.dart';
import 'package:carpooling_passenger/data/models/helpers/only_id.dart';
import 'package:carpooling_passenger/domain/usescases/booking/booking_use_case.dart';
import 'package:carpooling_passenger/domain/usescases/routes/routes_use_case.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/application/preferences.dart';
import '../../../../data/models/passenger/passenger_response.dart';
import '../../../../data/models/routes/route_response.dart';

class DetailRouteController extends GetxController {
  RxString idSelectedStartStation = "0".obs;
  RxString idSelectedEndStation = "0".obs;

  //Formulario
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  RxBool isValidForm = false.obs;
  RxBool isInvalidDropdown = false.obs;

  TextEditingController dateinput = TextEditingController();
  TextEditingController timeinput = TextEditingController();

  final route = Get.arguments as RouteResponse;

  RxList<DropdownMenuItem<String>> stationsDropdown = RxList();
  // tiene que ser dos lista debido a que el usuario no puede seleccionar una estación anterior
  RxList<DropdownMenuItem<String>> stationsDropdownEnd = RxList();

  final RoutesUseCase _routesUseCase;
  final BookingUseCase _bookingUseCase;
  DetailRouteController(this._routesUseCase, this._bookingUseCase);

  @override
  void onInit() async {
    getAllStationsResponse();
    super.onInit();
  }

  getAllStationsResponse() async {
    final failureOrStations =
        await _routesUseCase.getStationsByRoute(route.id.toString());
    stationsDropdown.clear();
    return failureOrStations.fold((failure) => null, (stationsResponse) {
      idSelectedStartStation.value = stationsResponse
          .where((element) => element.index == 1)
          .first
          .id
          .toString();
      stationsResponse.sort((a, b) => a.index.compareTo(b.index));
      for (var stationElement in stationsResponse) {
        stationsDropdown.add(
          DropdownMenuItem(
            value: stationElement.id.toString(),
            child: Text(stationElement.nameStation),
          ),
        );
      }
      // stationsDropdownEnd = stationsDropdown;
    });
  }

  findStationsEnd(String idStationStart) {
    int positionStationStart = 0;

    for (var i = 0; i < stationsDropdown.length; i++) {
      if (stationsDropdown[i].value == idStationStart) {
        positionStationStart = i;
        if (i != stationsDropdown.length - 1) {
          //Cuando el usuario selecciona una estación de inicio -> la estación de fin por defecto es la siguiente estación que le sigue
          idSelectedEndStation.value = stationsDropdown[i + 1].value ?? '0';
        } else {
          idSelectedEndStation.value = '0';
          isInvalidDropdown.value = true;
        }
      }
    }
 
    //Se evaluá que si la parada de inicio es la última -> no debe seleccionar una estación de fin
    if (positionStationStart == stationsDropdown.length - 1) {
      isInvalidDropdown.value = true;
      return stationsDropdownEnd.value = [];
    } else {
      isInvalidDropdown.value = false;
      stationsDropdownEnd.value =
          stationsDropdown.sublist(positionStationStart + 1);
    }
  }

  bool validaFormDetail() {
    if (idSelectedStartStation.value != "0" &&
        idSelectedEndStation.value != "0" &&
        dateinput.value.text.length > 3 &&
        timeinput.value.text.length > 3) {
      isValidForm.value = true;
    } else {
      isValidForm.value = false;
    }
    return isValidForm.value;
  }

  createBooking() async {
    if (validaFormDetail()) {
      PassengerResoponse? passengerResponse = PassengerResoponse.fromJson(
          jsonDecode(
              await Preferences.storage.read(key: "userPassenger") ?? ''));

      showLoading();
      BookingRequest bookingRequest = BookingRequest(
        timeBooking: timeinput.text,
        endStation: OnlyId(id: int.parse(idSelectedEndStation.value)),
        startStation: OnlyId(id: int.parse(idSelectedStartStation.value)),
        index: 1,
        route: OnlyId(id: route.id),
        dateBooking: dateinput.text,
        passenger: OnlyId(id: passengerResponse.id),
        service: null,
        startService: "",
        finalizedService: "",
      );

      final failureOrBookingOK =
          await _bookingUseCase.createBooking(bookingRequest);

      failureOrBookingOK.fold((errorResponse) {
        print('LOG: errorResponse Ocurrió un error ${errorResponse}');
        showMessage('Ocurrió un error', '${errorResponse.message}');
      }, (r) {
        print('LOG salió  ${r}');
        closeDialogLoading();
        showMessage('Reserva creada', 'Gracias por reservar, ten en cuenta que el administrador generará el servicio en base a la cantidad de pasajeros que reserven.');
      });
    }
  }

  void showMessage(String title, String content) {
    Get.closeAllSnackbars();
    Get.snackbar(
      title,
      content,
      backgroundColor: Colors.grey,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
    Get.offNamed('/home');
    Get.delete<DetailRouteController>();
  }

  void showLoading() {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void closeDialogLoading() {
    Get.back();
  }
}
