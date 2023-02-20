import 'package:carpooling_passenger/data/models/booking/booking_request.dart';
import 'package:carpooling_passenger/data/models/helpers/only_id.dart';
import 'package:carpooling_passenger/domain/usescases/booking/booking_use_case.dart';
import 'package:carpooling_passenger/domain/usescases/routes/routes_use_case.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/models/routes/route_response.dart';

class DetailRouteController extends GetxController {
  RxString idSelectedStartStation = "0".obs;
  RxString idSelectedEndStation = "0".obs;

  //Formulario
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  RxBool isValidForm = false.obs;

  // RxString selectedDate = "".obs;
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
      idSelectedStartStation.value = stationsResponse[0].id.toString();
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
        idSelectedEndStation.value = stationsDropdown[i + 1].value ?? '0';
      }
    }

    stationsDropdownEnd.value =
        stationsDropdown.sublist(positionStationStart + 1);
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
      // PassengerResoponse? passengerResponse = jsonDecode( await Preferences.storage.read(key: "userPassenger") ?? '');
      showLoading();
      BookingRequest bookingRequest = BookingRequest(
        timeBooking: timeinput.text,
        endStation: OnlyId(id: int.parse(idSelectedEndStation.value)),
        startStation: OnlyId(id: int.parse(idSelectedStartStation.value)),
        index: 1,
        route: OnlyId(id: route.id),
        dateBooking: dateinput.text,
        passenger: OnlyId(id: 59),
        service: null,
        startService: "",
        finalizedService: "",
      );

      final failureOrBookingOK =
          await _bookingUseCase.createBooking(bookingRequest);

      failureOrBookingOK.fold((errorResponse ) {
        print('LOG: errorResponse Ocurrió un error ${errorResponse}');
        showMessage('Ocurrió un error', '${errorResponse.message}');
        
      }, (r) {
        print('LOG salió  ${r}');
        closeDialogLoading();
        showMessage('Reserva creada',
            'Gracias por reservar, ten en cuenta que el administrador generará el servicio en base a la cantidad de pasajeros que reserven.');
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
    Get.toNamed('/home');
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
