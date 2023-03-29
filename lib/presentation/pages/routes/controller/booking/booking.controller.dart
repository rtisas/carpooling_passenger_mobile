import 'dart:convert';

import 'package:carpooling_passenger/core/application/preferences.dart';
import 'package:carpooling_passenger/data/models/helpers/bookingState.dart';
import 'package:carpooling_passenger/domain/usescases/booking/booking_use_case.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../data/models/passenger/passenger_response.dart';

class BookingController extends GetxController {
  final BookingUseCase _bookingUseCase;

  var listBookings = [].obs;

  BookingController(this._bookingUseCase);

  @override
  void onInit() async {
    loadBookingsActiveByPassenger();
    super.onInit();
  }

  loadBookingsActiveByPassenger() async {
    listBookings.clear();
    await getBookingsPendientePassenger();
    await getBookingsAprobadoPassenger();
    await getBookingsEjecucionPassenger();
  }

  Future getBookingsPendientePassenger() async {
    PassengerResoponse passenger = PassengerResoponse.fromJson(
        jsonDecode(await Preferences.storage.read(key: 'userPassenger') ?? ''));
    final failureOrBookings = await _bookingUseCase.getBookingsPassengerByState(
        passenger.id.toString(), STATUS_BOOKING.PENDIENTE.value);

    return failureOrBookings.fold((failure) {
      print(
          'LOG Ocurrió un error al momento de consultar los bookings ${failure}');
    }, (listBookingsResponse) {
      listBookings.addAll(listBookingsResponse);
    });
  }

  Future getBookingsAprobadoPassenger() async {
    PassengerResoponse passenger = PassengerResoponse.fromJson(
        jsonDecode(await Preferences.storage.read(key: 'userPassenger') ?? ''));
    final failureOrBookings = await _bookingUseCase.getBookingsPassengerByState(
        passenger.id.toString(), STATUS_BOOKING.APROBADO.value);
    failureOrBookings.fold((failure) {
      print(
          'LOG Ocurrió un error al momento de consultar los bookings ${failure}');
    }, (listBookingsResponse) {
      listBookings.addAll(listBookingsResponse);
    });
  }

  Future getBookingsEjecucionPassenger() async {
    PassengerResoponse passenger = PassengerResoponse.fromJson(
        jsonDecode(await Preferences.storage.read(key: 'userPassenger') ?? ''));
    final failureOrBookings = await _bookingUseCase.getBookingsPassengerByState(
        passenger.id.toString(), STATUS_BOOKING.EN_EJECUCION.value);
    failureOrBookings.fold((failure) {
      print(
          'LOG Ocurrió un error al momento de consultar los bookings ${failure}');
    }, (listBookingsResponse) {
      listBookings.addAll(listBookingsResponse);
    });
  }

  Future deleteBooking(String idBooking) async {
    final failureOrBookings = await _bookingUseCase.deleteBooking(idBooking);
    failureOrBookings.fold((failure) {
      showMessage('Error', failure.message);
    }, (response) async {
      await loadBookingsActiveByPassenger();
      closeDialogLoading();
      showMessage('Reserva cancelada', 'La reserva ha sido cancelada correctamente');
    });
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

  void showMessage(String title, String content) {
    Get.closeAllSnackbars();
    Get.snackbar(
      title,
      content,
      backgroundColor: Colors.grey,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
  }
}
