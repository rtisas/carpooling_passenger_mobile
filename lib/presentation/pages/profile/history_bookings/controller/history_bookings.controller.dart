import 'dart:convert';

import 'package:carpooling_passenger/data/models/booking/booking_response.dart';
import 'package:carpooling_passenger/data/models/helpers/bookingState.dart';
import 'package:carpooling_passenger/domain/usescases/booking/booking_use_case.dart';
import 'package:get/get.dart';

import '../../../../../core/application/preferences.dart';
import '../../../../../data/models/passenger/passenger_response.dart';

class HistoryBookingsController extends GetxController {
  final BookingUseCase _bookingUseCase;
  late PassengerResoponse passenger;
  RxBool isLoading = false.obs;
  Rx<List<BookingResponseComplete>> historyBookings = Rx([]);

  HistoryBookingsController(this._bookingUseCase);

  @override
  void onInit() async {
    passenger = PassengerResoponse.fromJson(
      jsonDecode(await Preferences.storage.read(key: 'userPassenger') ?? ''),
    );
    getHistoryBookingsPassenger();
    super.onInit();
  }

  getHistoryBookingsPassenger()  async {
    isLoading.value = true;
    historyBookings.value = [];
    await _bookingUseCase
        .getBookingsPassengerByState(
            passenger.id.toString(), STATUS_BOOKING.FINALIZADO.value)
        .then((value) => value.fold((errorResponse) {
          isLoading.value = false;
        },(bookingsResponse) {
          isLoading.value = false;
          historyBookings.value = bookingsResponse;
        }));
    await _bookingUseCase
        .getBookingsPassengerByState(
            passenger.id.toString(), STATUS_BOOKING.ELIMINADO.value)
        .then((value) => value.fold((errorResponse) {
          isLoading.value = false;
        },(bookingsResponse) {
          isLoading.value = false;
          historyBookings.value.addAll(bookingsResponse);
        }));
  }
}
