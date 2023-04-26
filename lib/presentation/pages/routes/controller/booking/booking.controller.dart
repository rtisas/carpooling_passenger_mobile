import 'dart:convert';

import 'package:carpooling_passenger/core/application/preferences.dart';
import 'package:carpooling_passenger/data/models/booking/update_qualifying.dart';
import 'package:carpooling_passenger/data/models/helpers/bookingState.dart';
import 'package:carpooling_passenger/domain/usescases/booking/booking_use_case.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../data/models/booking/booking_response.dart';
import '../../../../../data/models/passenger/passenger_response.dart';

class BookingController extends GetxController {
  final BookingUseCase _bookingUseCase;

  Rx<List<BookingResponseComplete>> listBookings = Rx([]);
  RxBool isLoading = false.obs;
  BookingController(this._bookingUseCase);

  @override
  void onInit() async {
    loadBookingsActiveByPassenger();
    super.onInit();
  }

  loadBookingsActiveByPassenger() async {
    isLoading.value = true;
    listBookings.value.clear();
    listBookings.value = [];
    await getBookingsEjecucionPassenger();
    await getBookingsAprobadoPassenger();
    await getBookingsPendientePassenger();
    isLoading.value = false;
    listBookings.value.sort((a, b) => b.state.id.compareTo(a.state.id));
  }

  Future getBookingsPendientePassenger() async {
    PassengerResoponse passenger = PassengerResoponse.fromJson(
        jsonDecode(await Preferences.storage.read(key: 'userPassenger') ?? ''));
    final failureOrBookings = await _bookingUseCase.getBookingsPassengerByState(
        passenger.id.toString(), STATUS_BOOKING.PENDIENTE.value);

    return await failureOrBookings.fold((failure) {
      print(
          'LOG Ocurrió un error al momento de consultar los bookings ${failure}');
    }, (listBookingsResponse) {
      listBookings.value.addAll(listBookingsResponse);
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
      listBookings.value.addAll(listBookingsResponse);
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
      listBookings.value.addAll(listBookingsResponse);
    });
  }

  Future deleteBooking(String idBooking) async {
    final failureOrBookings = await _bookingUseCase.deleteBooking(idBooking);
    failureOrBookings.fold((failure) {
      showMessage('Error', failure.message);
    }, (response) async {
      await loadBookingsActiveByPassenger();
      closeDialogLoading();
      showMessage(
          'Reserva cancelada', 'La reserva ha sido cancelada correctamente');
    });
  }

  Future updateQualifyingService(String idBooking, String qualifiying) async {
    UpdateQualifying updateQualifying =
        UpdateQualifying(qualifiying: qualifiying);
    await _bookingUseCase
        .updateQualifyingBooking(idBooking, updateQualifying)
        .then((value) => value.fold((errorResponse) {
              print(
                  'LOG Ocurrió un error al momento de calificar una reserva ${1}');
            }, (response) {
              showMessage('Calificación enviada',
                  '¡Gracias por calificar nuestro servicio! Tus comentarios nos ayudan a mejorar y ofrecerte la mejor experiencia posible.');
            }));
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
